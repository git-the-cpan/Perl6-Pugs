#!/usr/bin/pugs

use v6;
use Test;

plan 8;

# L<S04/"The Relationship of Blocks and Declarations" /There is a new state declarator that introduces/>

# state() inside subs
{
    sub inc () {
        state $svar;
        $svar++;
        return $svar;
    };

    is(inc(), 1, "state() works inside subs (#1)");
    is(inc(), 2, "state() works inside subs (#2)");
    is(inc(), 3, "state() works inside subs (#3)");
}

# state() inside coderefs
{
    my $gen = {
        # Note: The following line is only executed once, because it's equivalent
        # to
        #   state $svar will first{ 42 };
        # See L<S04/"Closure traits" /emantics to any initializer, so this also works/>
        state $svar = 42;
        my $ret = { $svar++ };
    };

    my $a = $gen(); # $svar == 42
    $a(); $a();     # $svar == 44
    my $b = $gen(); # $svar == 44

    is $b(), 44, "state() works inside coderefs", :todo<feature>;
}

# state() inside for-loops
{
    for [1,2,3] -> $val {
        state $svar;
        $svar++;

        # Only check on last run
        if($val == 3) {
            is $svar, 3, "state() works inside for-loops", :todo<feature>;
        }
    }
}

# state will first{...}
{
    my ($a, $b);
    eval '
        my $gen = {
            state $svar will first { 42 };
            -> { $svar++ };
        }
        $a = $gen();    # $svar == 42
        $a(); $a();     # $svar == 44
        $b = $gen()();  # $svar == 44
    ';

    is $b, 44, 'state will first{...} works', :todo<feature>;
}

# Return of a reference to a state() var
{
    my $gen = {
        state $svar = 42;
        \$svar;
    };

    my $svar_ref = $gen();
    $svar_ref++; $svar_ref++;

    my $svar_ref = $gen();
    is $svar_ref, 44, "reference to a state() var", :todo<feature>;
}

# Anonymous state vars
# http://groups.google.de/group/perl.perl6.language/msg/07aefb88f5fc8429
{
    my $gen = { try { \state } };

    my $svar_ref = $gen();    # $svar == 0
    $svar_ref++; $svar_ref++; # $svar == 2

    my $svar_ref = $gen();    # $svar == 2
    is $svar_ref, 2, "reference to a state() var", :todo<feature>;
}

# http://www.nntp.perl.org/group/perl.perl6.language/20888
# ("Re: Declaration and definition of state() vars" from Larry)
{
    my ($a, $b);
    eval '
        my $gen = {
            (state $svar) = 42;
            my $ret = { $svar++ };
        };

        $a = $gen();        # $svar == 42
        $a(); $a();         # $svar == 44
        $b = $gen()();      # $svar == 42
    '
    is $b, 42, "state() and parens", :todo<feature>; # svar == 43
}