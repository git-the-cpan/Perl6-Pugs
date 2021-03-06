{-# OPTIONS_GHC -fglasgow-exts -fallow-overlapping-instances #-}

{-|
    Common operations on Eval monad.
    
>   One Ring to rule them all,
>   One Ring to find them,
>   One Ring to bring them all
>   and in the darkness bind them...

    Note that the actual monads are defined elsewhere -- try looking at
    "Pugs.AST.SIO" and "Pugs.AST.Internals".
-}

module Pugs.Monads (
    enterLValue, enterRValue,
    enterLex, enterContext, enterEvalContext, enterPackage, enterCaller,
    enterGiven, enterWhen, enterLoop, enterGather, genSymPrim, genSymCC,
    enterBlock, enterSub, envEnterCaller,
    evalVal, tempVar,

    enterFrame, assertFrame, emptyFrames,
    
    MaybeT, runMaybeT,
) where
import Pugs.Internals
import Pugs.AST
import Pugs.Types
import Control.Monad.RWS (MonadPlus(..))
import qualified Data.Map as Map
import qualified Data.Set as Set

newtype MaybeT m a = MaybeT { runMaybeT :: m (Maybe a) }

instance (Monad m) => Monad (MaybeT m) where
    (MaybeT mon) >>= f =
        MaybeT (mon >>= maybe (return Nothing) (runMaybeT . f))
    return              = MaybeT . return . Just

instance MonadTrans MaybeT where
    lift mon = MaybeT (mon >>= return . Just)

instance (Monad m) => MonadPlus (MaybeT m) where
    mzero                       = MaybeT (return Nothing)
    mplus (MaybeT a) (MaybeT b) = MaybeT $ do
        ma <- a
        mb <- b
        return $ ma `mplus` mb

{-|
Perform the given evaluation in an /LValue/ context.
-}
enterLValue :: Eval a -> Eval a
enterLValue = local (\e -> e{ envLValue = True })
{-|
Perform the given evaluation in an /RValue/ (i.e. non-/LValue/) context.
-}
enterRValue :: Eval a -> Eval a
enterRValue = local (\e -> e{ envLValue = False })

{-|
Create a new lexical scope by applying the list of 'Pad'-transformers
(which install new bindings), then perform the specified evaluation in that
new scope.

(Subsequent chained 'Eval's do /not/ see this new scope.)
-}
enterLex :: [PadMutator] -- ^ Transformations on current 'Pad' to produce the
                         --     new 'Pad'.
         -> Eval a       -- ^ Evaluation to be performed in the new scope
         -> Eval a       -- ^ Resulting evaluation (lexical scope enter & exit
                         --     are encapsulated)
enterLex newSyms = local (\e -> e{ envLexical = combine newSyms (envLexical e) })

{-|
Perform the specified evaluation in the specified (Perl 6) context ('Cxt').

(Subsequent chained 'Eval's do /not/ see this new scope.)
-}
enterContext :: Cxt -> Eval a -> Eval a
enterContext cxt = local (\e -> e{ envContext = cxt })

{-|
Evaluate the specified expression in the specified (Perl 6) context ('Cxt').

(Subsequent chained 'Eval's do /not/ see this new scope.)
-}
enterEvalContext :: Cxt -> Exp -> Eval Val
enterEvalContext cxt = enterContext cxt . evalExp

{-|
Perform the specified evaluation in the specified package.

(Subsequent chained 'Eval's do /not/ see this package.)
-}
enterPackage :: ByteString -> Eval a -> Eval a
enterPackage pkg = local (\e -> e{ envPackage = cast pkg })

{-|
Enter a new environment and mark the previous one as 'Caller'.
-}
enterCaller :: Eval a -> Eval a
enterCaller = local envEnterCaller

envEnterCaller :: Env -> Env
envEnterCaller env = env
    { envCaller = Just env
        { envLexical = MkPad (lex `Map.intersection` envImplicit env)
        }
    , envFrames = FrameRoutine `Set.insert` envFrames env
    , envImplicit = Map.fromList [(cast "$_", ())]
    }
    where
    MkPad lex = envLexical env

{-|
Register the fact that we are inside a specially marked control block.
-}
enterFrame :: Frame -> Eval a -> Eval a
enterFrame f = local (\e -> e{ envFrames = f `Set.insert` envFrames e})

enterGather, enterLoop, enterGiven :: Eval Val -> Eval Val
enterGather = enterFrame FrameGather
enterLoop   = enterFrame FrameLoop
enterGiven  = id

assertFrame :: Frame -> Eval a -> Eval a
assertFrame f action = do
    frames <- asks envFrames
    if Set.member f frames
        then action
        else fail ("Cannot use this control structure outside a '" ++ (map toLower (drop 5 (show f))) ++ "' structure")

emptyFrames :: Set Frame
emptyFrames = Set.empty

{-|
Note that this function is /not/ responsible for performing the actual @when@
test, nor is it responsible for adding the implicit @break@ to the end of the
@when@'s block--those are already taken care of by 'Pugs.Eval.reduce'
(see the entry for @('Syn' \"when\" ... )@).
-}
enterWhen :: Eval Val -- ^ The @when@'s body block, as an evaluation
          -> Eval Val
enterWhen action = do
    rv  <- enterFrame FrameWhen action
    case rv of
        VControl (ControlWhen WhenContinue)   -> retEmpty
        VControl (ControlWhen WhenBreak)      -> retShiftEmpty
        _                                     -> retShift rv

{-|
Generate a new Perl 6 operation from a Haskell function, give it a name, and
generate a @('Pad' -> 'Pad')@ transformer that can be used to install it into
a pad.

This transformer is passed into a given \'action\' function, which is
expected to apply the pad-transformer (e.g. in a new lexical scope), then
perform some evaluation in that scope.

Most of the time, this \'action\' is an anonymous function that passes its
argument into 'enterLex'.
-}
genSymPrim :: (MonadSTM m) 
           => String                -- ^ Name installed in 'Pad'
                                    --     (must have leading @&@ sigil)
           -> ([Val] -> Eval Val)   -- ^ The actual primitive to wrap
           -> (PadMutator -> m t)   -- ^ A (lambda) function that the 'Pad'
                                    --     transformer is given to
           -> m t -- ^ Result of passing the pad-transformer to the \'action\'
genSymPrim symName@('&':name) prim action = do
    newSym <- genSym (cast symName) . codeRef $ mkPrim
        { subName = cast name
        , subBody = Prim prim
        }
    action newSym
genSymPrim _ _ _ = error "need a &name"

{-|
Generate a Perl 6 primitive that, when called, will activate the /current/
continuation (i.e. one that can be used to immediately break out of whatever 
evaluation we are about to perform). This is great for @&last@ and the like.

This produces a pad-transformer @('Pad' -> 'Pad')@. This transformer is given
to an \'action\' function, which is expected to apply it (e.g. in a lexical
scope), then perform some evaluation in that scope.
-}
genSymCC :: String -- ^ Name of the primitive in the symbol table ('Pad').
         -> (PadMutator -> Eval Val)   -- ^ An \'action\' function that will
                                       --     take the pad-transformer and use
                                       --     it to perform some evaluation 
         -> Eval Val -- ^ Result of passing the pad-transformer to the 
                     --     \'action\'
genSymCC symName action = callCC $ \esc -> do
    genSymPrim symName (const $ esc undef) action

{-|
Used by 'Pugs.Eval.reduce' when evaluating @('Syn' \"block\" ... )@ 
expressions.
-}
enterBlock :: Eval Val -> Eval Val
enterBlock action = local (\e -> e{ envOuter = Just e }) action

enterSub :: VCode -> Eval Val -> Eval Val
enterSub sub action
    | typ >= SubPrim = runAction -- primitives just happen
    | otherwise     = do
        env <- ask
        rv  <- case typ of
            _ | typ >= SubBlock -> tryT $ do
                doFix <- fixEnv return env
                local doFix runAction

            -- For coroutines, we secretly store a continuation into subCont
            -- whenever "yield" occurs in it.  However, the inner CC must be
            -- delimited on the subroutine boundary, otherwise the resuming
            -- continuation will continue into the rest of the program,
            -- which is now how coroutines are supposed to work.
            -- On the other hand, the normal &?CALLER_CONTINUATION must still
            -- work as an undelimiated continuation, which is why callCC here
            -- occurs before resetT.
            SubCoroutine -> tryT . callCC $ \cc -> resetT $ do
                doFix <- fixEnv cc env
                local doFix runAction

            _ -> tryT . callCC $ \cc -> do
                doFix <- fixEnv cc env
                local doFix runAction
        runBlocks (filter (rejectKeepUndo rv . subName) . subLeaveBlocks)

        when (rv == VControl (ControlLoop LoopLast)) $
            -- We won't have a chance to run the LAST block
            -- once we exit outside the lexical block, so do it now
            runBlocks subLastBlocks

        assertBlocks subPostBlocks "POST"
        case rv of
            VControl l@(ControlLeave ftyp depth val) -> do
                let depth' = if ftyp typ then depth - 1 else depth
                if depth' < 0
                    then return val
                    else retControl l{ leaveDepth = depth' }
            VControl ControlExit{}  -> retShift rv
            VError{}                -> do
                -- XXX - Implement CATCH block here
                retShift rv
            _ -> return rv
    where
    rejectKeepUndo VUndef     = (/= __"KEEP")
    rejectKeepUndo (VControl (ControlLeave _ _ val)) = \n -> rejectKeepUndo val n && (n /= __"NEXT")
    rejectKeepUndo (VControl (ControlLoop LoopNext)) = (/= __"KEEP")
    rejectKeepUndo VControl{} = \n -> (n /= __"KEEP") && (n /= __"NEXT")
    rejectKeepUndo VError{}   = \n -> (n /= __"KEEP") && (n /= __"NEXT")
    rejectKeepUndo _          = (/= __"UNDO")
    runAction = do
        assertBlocks subPreBlocks "PRE"
        runBlocks subEnterBlocks
        action
    runBlocks f = mapM_ (evalExp . Syn "block" . (:[]) . Syn "sub" . (:[]) . Val . castV) (f sub)
    assertBlocks f name = forM_ (f sub) $ \cv -> do
        rv <- fromVal =<< (evalExp . Syn "block" . (:[]) . Syn "sub" . (:[]) . Val . castV $ cv)
        if rv then return () else retError (name ++ " assertion failed") (subName sub)
    typ = subType sub
    doCC :: (Val -> Eval b) -> [Val] -> Eval b
    doCC cc [v] = cc =<< evalVal v
    doCC _  _   = internalError "enterSub: doCC list length /= 1"
    orig :: VCode -> VCode
    orig sub = sub { subBindings = [], subParams = (map fst (subBindings sub)) }
    fixEnv :: (Val -> Eval Val) -> Env -> Eval (Env -> Env)
    fixEnv cc env
        | typ >= SubBlock = do
            blockRec <- genSym (cast "&?BLOCK") (codeRef (orig sub))
            return $ \e -> e
                { envOuter = Just env
                , envPackage = maybe (envPackage e) envPackage (subEnv sub)
                , envLexical = combine [blockRec]
                    (subPad sub `unionPads` envLexical env)
                , envImplicit= envImplicit e `Map.union` Map.fromList
                    [ (cast "&?BLOCK", ()) ]
                }
        | otherwise = do
            subRec <- sequence
                [ genSym (cast "&?ROUTINE") (codeRef (orig sub))
                ]
            -- retRec    <- genSubs env "&return" retSub
            callerRec <- genSubs env "&?CALLER_CONTINUATION" (ccSub cc)
            return $ \e -> e
                { envLexical = combine (concat [subRec, callerRec]) (subPad sub)
                , envPackage = maybe (envPackage e) envPackage (subEnv sub)
                , envOuter   = maybe Nothing envOuter (subEnv sub)
                , envImplicit= envImplicit e `Map.union` Map.fromList
                    [ (cast "&?ROUTINE", ()), (cast "&?CALLER_CONTINUATION", ()) ]
                }
    ccSub :: (Val -> Eval Val) -> Env -> VCode
    ccSub cc env = mkPrim
        { subName = __"CALLER_CONTINUATION"
        , subParams = makeParams env
        , subBody = Prim $ doCC cc
        }

genSubs :: t -> String -> (t -> VCode) -> Eval [PadMutator]
genSubs env name gen = sequence
    [ genMultiSym (cast name) (codeRef $ gen env)
    , genMultiSym (cast name) (codeRef $ (gen env) { subParams = [] })
    ]

makeParams :: Env -> [Param]
makeParams MkEnv{ envContext = cxt, envLValue = lv }
    = [ MkOldParam
        { isInvocant = False
        , isOptional = False
        , isNamed    = False
        , isLValue   = lv
        , isWritable = lv
        , isLazy     = False
        , paramName  = cast $ case cxt of
            CxtSlurpy _ -> "@?0"
            _           -> "$?0"
        , paramContext = cxt
        , paramDefault = Val VUndef
        } ]

evalVal :: Val -> Eval Val
evalVal val@(VRef ref) = do
    lv  <- asks envLValue
    if lv
        then return val
        else if refType ref == mkType "Scalar::Const"
            then evalVal =<< readRef ref
            else do
                cls <- asks envClasses
                typ <- evalValType val
                if isaType cls "Junction" typ
                    then evalVal =<< readRef ref
                    else return val
evalVal val = return val

tempVar :: Var -> Val -> Eval a -> Eval a
tempVar var val action = do
    old <- readVar var
    writeVar var val
    rv  <- action
    writeVar var old
    return rv

