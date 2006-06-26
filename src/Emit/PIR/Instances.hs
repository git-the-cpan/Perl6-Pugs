{-# OPTIONS_GHC -fglasgow-exts -fallow-overlapping-instances -fno-warn-orphans -funbox-strict-fields -cpp #-}




{- 
-- WARNING WARNING WARNING --

This is an autogenerated file from src/Emit/PIR.hs.

Do not edit this file.

All changes made here will be lost!

-- WARNING WARNING WARNING --
-}

#ifndef HADDOCK









module Emit.PIR.Instances ()
where
import Emit.PIR
import Data.Yaml.Syck
import DrIFT.YAML
import DrIFT.JSON
import DrIFT.Perl5
import Control.Monad
import qualified Data.ByteString as Buf

{-* Generated by DrIFT : Look, but Don't Touch. *-}
instance YAML Decl where
    fromYAML MkYamlNode{nodeTag=Just t, nodeElem=e} | 't':'a':'g':':':'h':'s':':':tag <- unpackBuf t = case tag of
	"DeclSub" -> do
	    let YamlMap assocs = e
	    let [aa, ab, ac] = map snd assocs
	    liftM3 DeclSub (fromYAML aa) (fromYAML ab) (fromYAML ac)
	"DeclNS" -> do
	    let YamlMap assocs = e
	    let [aa, ab] = map snd assocs
	    liftM2 DeclNS (fromYAML aa) (fromYAML ab)
	"DeclInc" -> do
	    let YamlMap assocs = e
	    let [aa] = map snd assocs
	    liftM DeclInc (fromYAML aa)
	"DeclHLL" -> do
	    let YamlMap assocs = e
	    let [aa, ab] = map snd assocs
	    liftM2 DeclHLL (fromYAML aa) (fromYAML ab)
	_ -> fail $ "unhandled tag: " ++ show t ++ ", expecting " ++ show ["DeclSub","DeclNS","DeclInc","DeclHLL"] ++ " in node " ++ show e
    fromYAML _ = fail "no tag found"
    asYAML (DeclSub aa ab ac) = asYAMLmap "DeclSub"
	   [("dsName", asYAML aa), ("dsFlags", asYAML ab),
	    ("dsBody", asYAML ac)]
    asYAML (DeclNS aa ab) = asYAMLmap "DeclNS"
	   [("dnPackage", asYAML aa), ("dnBody", asYAML ab)]
    asYAML (DeclInc aa) = asYAMLmap "DeclInc" [("diFile", asYAML aa)]
    asYAML (DeclHLL aa ab) = asYAMLmap "DeclHLL"
	   [("dhLang", asYAML aa), ("dhGroup", asYAML ab)]

instance YAML Stmt where
    fromYAML MkYamlNode{nodeTag=Just t, nodeElem=e} | 't':'a':'g':':':'h':'s':':':tag <- unpackBuf t = case tag of
	"StmtComment" -> do
	    let YamlSeq [aa] = e
	    liftM StmtComment (fromYAML aa)
	"StmtLine" -> do
	    let YamlSeq [aa, ab] = e
	    liftM2 StmtLine (fromYAML aa) (fromYAML ab)
	"StmtPad" -> do
	    let YamlSeq [aa, ab] = e
	    liftM2 StmtPad (fromYAML aa) (fromYAML ab)
	"StmtRaw" -> do
	    let YamlSeq [aa] = e
	    liftM StmtRaw (fromYAML aa)
	"StmtIns" -> do
	    let YamlSeq [aa] = e
	    liftM StmtIns (fromYAML aa)
	"StmtSub" -> do
	    let YamlSeq [aa, ab] = e
	    liftM2 StmtSub (fromYAML aa) (fromYAML ab)
	_ -> fail $ "unhandled tag: " ++ show t ++ ", expecting " ++ show ["StmtComment","StmtLine","StmtPad","StmtRaw","StmtIns","StmtSub"] ++ " in node " ++ show e
    fromYAML _ = fail "no tag found"
    asYAML (StmtComment aa) = asYAMLseq "StmtComment" [asYAML aa]
    asYAML (StmtLine aa ab) = asYAMLseq "StmtLine"
	   [asYAML aa, asYAML ab]
    asYAML (StmtPad aa ab) = asYAMLseq "StmtPad" [asYAML aa, asYAML ab]
    asYAML (StmtRaw aa) = asYAMLseq "StmtRaw" [asYAML aa]
    asYAML (StmtIns aa) = asYAMLseq "StmtIns" [asYAML aa]
    asYAML (StmtSub aa ab) = asYAMLseq "StmtSub" [asYAML aa, asYAML ab]

instance YAML Ins where
    fromYAML MkYamlNode{nodeTag=Just t, nodeElem=e} | 't':'a':'g':':':'h':'s':':':tag <- unpackBuf t = case tag of
	"InsLocal" -> do
	    let YamlSeq [aa, ab] = e
	    liftM2 InsLocal (fromYAML aa) (fromYAML ab)
	"InsNew" -> do
	    let YamlSeq [aa, ab] = e
	    liftM2 InsNew (fromYAML aa) (fromYAML ab)
	"InsBind" -> do
	    let YamlSeq [aa, ab] = e
	    liftM2 InsBind (fromYAML aa) (fromYAML ab)
	"InsAssign" -> do
	    let YamlSeq [aa, ab] = e
	    liftM2 InsAssign (fromYAML aa) (fromYAML ab)
	"InsPrim" -> do
	    let YamlSeq [aa, ab, ac] = e
	    liftM3 InsPrim (fromYAML aa) (fromYAML ab) (fromYAML ac)
	"InsFun" -> do
	    let YamlSeq [aa, ab, ac] = e
	    liftM3 InsFun (fromYAML aa) (fromYAML ab) (fromYAML ac)
	"InsTailFun" -> do
	    let YamlSeq [aa, ab] = e
	    liftM2 InsTailFun (fromYAML aa) (fromYAML ab)
	"InsLabel" -> do
	    let YamlSeq [aa] = e
	    liftM InsLabel (fromYAML aa)
	"InsComment" -> do
	    let YamlSeq [aa, ab] = e
	    liftM2 InsComment (fromYAML aa) (fromYAML ab)
	"InsExp" -> do
	    let YamlSeq [aa] = e
	    liftM InsExp (fromYAML aa)
	"InsConst" -> do
	    let YamlSeq [aa, ab, ac] = e
	    liftM3 InsConst (fromYAML aa) (fromYAML ab) (fromYAML ac)
	_ -> fail $ "unhandled tag: " ++ show t ++ ", expecting " ++ show ["InsLocal","InsNew","InsBind","InsAssign","InsPrim","InsFun","InsTailFun","InsLabel","InsComment","InsExp","InsConst"] ++ " in node " ++ show e
    fromYAML _ = fail "no tag found"
    asYAML (InsLocal aa ab) = asYAMLseq "InsLocal"
	   [asYAML aa, asYAML ab]
    asYAML (InsNew aa ab) = asYAMLseq "InsNew" [asYAML aa, asYAML ab]
    asYAML (InsBind aa ab) = asYAMLseq "InsBind" [asYAML aa, asYAML ab]
    asYAML (InsAssign aa ab) = asYAMLseq "InsAssign"
	   [asYAML aa, asYAML ab]
    asYAML (InsPrim aa ab ac) = asYAMLseq "InsPrim"
	   [asYAML aa, asYAML ab, asYAML ac]
    asYAML (InsFun aa ab ac) = asYAMLseq "InsFun"
	   [asYAML aa, asYAML ab, asYAML ac]
    asYAML (InsTailFun aa ab) = asYAMLseq "InsTailFun"
	   [asYAML aa, asYAML ab]
    asYAML (InsLabel aa) = asYAMLseq "InsLabel" [asYAML aa]
    asYAML (InsComment aa ab) = asYAMLseq "InsComment"
	   [asYAML aa, asYAML ab]
    asYAML (InsExp aa) = asYAMLseq "InsExp" [asYAML aa]
    asYAML (InsConst aa ab ac) = asYAMLseq "InsConst"
	   [asYAML aa, asYAML ab, asYAML ac]

instance YAML Expression where
    fromYAML MkYamlNode{nodeTag=Just t, nodeElem=e} | 't':'a':'g':':':'h':'s':':':tag <- unpackBuf t = case tag of
	"ExpLV" -> do
	    let YamlSeq [aa] = e
	    liftM ExpLV (fromYAML aa)
	"ExpLit" -> do
	    let YamlSeq [aa] = e
	    liftM ExpLit (fromYAML aa)
	_ -> fail $ "unhandled tag: " ++ show t ++ ", expecting " ++ show ["ExpLV","ExpLit"] ++ " in node " ++ show e
    fromYAML _ = fail "no tag found"
    asYAML (ExpLV aa) = asYAMLseq "ExpLV" [asYAML aa]
    asYAML (ExpLit aa) = asYAMLseq "ExpLit" [asYAML aa]

instance YAML LValue where
    fromYAML MkYamlNode{nodeTag=Just t, nodeElem=e} | 't':'a':'g':':':'h':'s':':':tag <- unpackBuf t = case tag of
	"VAR" -> do
	    let YamlSeq [aa] = e
	    liftM VAR (fromYAML aa)
	"PMC" -> do
	    let YamlSeq [aa] = e
	    liftM PMC (fromYAML aa)
	"STR" -> do
	    let YamlSeq [aa] = e
	    liftM STR (fromYAML aa)
	"INT" -> do
	    let YamlSeq [aa] = e
	    liftM INT (fromYAML aa)
	"NUM" -> do
	    let YamlSeq [aa] = e
	    liftM NUM (fromYAML aa)
	"KEYED" -> do
	    let YamlSeq [aa, ab] = e
	    liftM2 KEYED (fromYAML aa) (fromYAML ab)
	_ -> fail $ "unhandled tag: " ++ show t ++ ", expecting " ++ show ["VAR","PMC","STR","INT","NUM","KEYED"] ++ " in node " ++ show e
    fromYAML _ = fail "no tag found"
    asYAML (VAR aa) = asYAMLseq "VAR" [asYAML aa]
    asYAML (PMC aa) = asYAMLseq "PMC" [asYAML aa]
    asYAML (STR aa) = asYAMLseq "STR" [asYAML aa]
    asYAML (INT aa) = asYAMLseq "INT" [asYAML aa]
    asYAML (NUM aa) = asYAMLseq "NUM" [asYAML aa]
    asYAML (KEYED aa ab) = asYAMLseq "KEYED" [asYAML aa, asYAML ab]

instance YAML Literal where
    fromYAML MkYamlNode{nodeTag=Just t, nodeElem=e} | 't':'a':'g':':':'h':'s':':':tag <- unpackBuf t = case tag of
	"LitStr" -> do
	    let YamlSeq [aa] = e
	    liftM LitStr (fromYAML aa)
	"LitInt" -> do
	    let YamlSeq [aa] = e
	    liftM LitInt (fromYAML aa)
	"LitNum" -> do
	    let YamlSeq [aa] = e
	    liftM LitNum (fromYAML aa)
	_ -> fail $ "unhandled tag: " ++ show t ++ ", expecting " ++ show ["LitStr","LitInt","LitNum"] ++ " in node " ++ show e
    fromYAML _ = fail "no tag found"
    asYAML (LitStr aa) = asYAMLseq "LitStr" [asYAML aa]
    asYAML (LitInt aa) = asYAMLseq "LitInt" [asYAML aa]
    asYAML (LitNum aa) = asYAMLseq "LitNum" [asYAML aa]

instance YAML SubFlag where
    fromYAML MkYamlNode{nodeTag=Just t, nodeElem=e} | 't':'a':'g':':':'h':'s':':':tag <- unpackBuf t = case tag of
	"SubMAIN" -> do
	    return SubMAIN
	"SubLOAD" -> do
	    return SubLOAD
	"SubANON" -> do
	    return SubANON
	"SubMETHOD" -> do
	    return SubMETHOD
	"SubMULTI" -> do
	    let YamlSeq [aa] = e
	    liftM SubMULTI (fromYAML aa)
	"SubOUTER" -> do
	    let YamlSeq [aa] = e
	    liftM SubOUTER (fromYAML aa)
	_ -> fail $ "unhandled tag: " ++ show t ++ ", expecting " ++ show ["SubMAIN","SubLOAD","SubANON","SubMETHOD","SubMULTI","SubOUTER"] ++ " in node " ++ show e
    fromYAML _ = fail "no tag found"
    asYAML (SubMAIN) = asYAMLcls "SubMAIN"
    asYAML (SubLOAD) = asYAMLcls "SubLOAD"
    asYAML (SubANON) = asYAMLcls "SubANON"
    asYAML (SubMETHOD) = asYAMLcls "SubMETHOD"
    asYAML (SubMULTI aa) = asYAMLseq "SubMULTI" [asYAML aa]
    asYAML (SubOUTER aa) = asYAMLseq "SubOUTER" [asYAML aa]

instance YAML RegType where
    fromYAML MkYamlNode{nodeTag=Just t, nodeElem=e} | 't':'a':'g':':':'h':'s':':':tag <- unpackBuf t = case tag of
	"RegInt" -> do
	    return RegInt
	"RegNum" -> do
	    return RegNum
	"RegStr" -> do
	    return RegStr
	"RegPMC" -> do
	    return RegPMC
	_ -> fail $ "unhandled tag: " ++ show t ++ ", expecting " ++ show ["RegInt","RegNum","RegStr","RegPMC"] ++ " in node " ++ show e
    fromYAML _ = fail "no tag found"
    asYAML (RegInt) = asYAMLcls "RegInt"
    asYAML (RegNum) = asYAMLcls "RegNum"
    asYAML (RegStr) = asYAMLcls "RegStr"
    asYAML (RegPMC) = asYAMLcls "RegPMC"

instance YAML ObjType where
    fromYAML MkYamlNode{nodeTag=Just t, nodeElem=e} | 't':'a':'g':':':'h':'s':':':tag <- unpackBuf t = case tag of
	"PerlScalar" -> do
	    return PerlScalar
	"PerlArray" -> do
	    return PerlArray
	"PerlHash" -> do
	    return PerlHash
	"PerlInt" -> do
	    return PerlInt
	"PerlPair" -> do
	    return PerlPair
	"PerlRef" -> do
	    return PerlRef
	"PerlEnv" -> do
	    return PerlEnv
	"Sub" -> do
	    return Sub
	"Closure" -> do
	    return Closure
	"Continuation" -> do
	    return Continuation
	"BareType" -> do
	    let YamlSeq [aa] = e
	    liftM BareType (fromYAML aa)
	_ -> fail $ "unhandled tag: " ++ show t ++ ", expecting " ++ show ["PerlScalar","PerlArray","PerlHash","PerlInt","PerlPair","PerlRef","PerlEnv","Sub","Closure","Continuation","BareType"] ++ " in node " ++ show e
    fromYAML _ = fail "no tag found"
    asYAML (PerlScalar) = asYAMLcls "PerlScalar"
    asYAML (PerlArray) = asYAMLcls "PerlArray"
    asYAML (PerlHash) = asYAMLcls "PerlHash"
    asYAML (PerlInt) = asYAMLcls "PerlInt"
    asYAML (PerlPair) = asYAMLcls "PerlPair"
    asYAML (PerlRef) = asYAMLcls "PerlRef"
    asYAML (PerlEnv) = asYAMLcls "PerlEnv"
    asYAML (Sub) = asYAMLcls "Sub"
    asYAML (Closure) = asYAMLcls "Closure"
    asYAML (Continuation) = asYAMLcls "Continuation"
    asYAML (BareType aa) = asYAMLseq "BareType" [asYAML aa]

instance YAML Sig where
    fromYAML MkYamlNode{nodeTag=Just t, nodeElem=e} | 't':'a':'g':':':'h':'s':':':tag <- unpackBuf t = case tag of
	"MkSig" -> do
	    let YamlMap assocs = e
	    let [aa, ab] = map snd assocs
	    liftM2 MkSig (fromYAML aa) (fromYAML ab)
	_ -> fail $ "unhandled tag: " ++ show t ++ ", expecting " ++ show ["MkSig"] ++ " in node " ++ show e
    fromYAML _ = fail "no tag found"
    asYAML (MkSig aa ab) = asYAMLmap "MkSig"
	   [("sigFlags", asYAML aa), ("sigIdent", asYAML ab)]

instance YAML ArgFlag where
    fromYAML MkYamlNode{nodeTag=Just t, nodeElem=e} | 't':'a':'g':':':'h':'s':':':tag <- unpackBuf t = case tag of
	"MkArgFlatten" -> do
	    return MkArgFlatten
	"MkArgSlurpyArray" -> do
	    return MkArgSlurpyArray
	"MkArgMaybeFlatten" -> do
	    return MkArgMaybeFlatten
	"MkArgOptional" -> do
	    return MkArgOptional
	_ -> fail $ "unhandled tag: " ++ show t ++ ", expecting " ++ show ["MkArgFlatten","MkArgSlurpyArray","MkArgMaybeFlatten","MkArgOptional"] ++ " in node " ++ show e
    fromYAML _ = fail "no tag found"
    asYAML (MkArgFlatten) = asYAMLcls "MkArgFlatten"
    asYAML (MkArgSlurpyArray) = asYAMLcls "MkArgSlurpyArray"
    asYAML (MkArgMaybeFlatten) = asYAMLcls "MkArgMaybeFlatten"
    asYAML (MkArgOptional) = asYAMLcls "MkArgOptional"

--  Imported from other files :-

type Buf = Buf.ByteString

#endif
