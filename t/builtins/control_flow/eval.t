#!/usr/bin/pugs

use v6;
use Test;

=pod

Tests for the eval() builtin

=cut

plan 5;

# eval should evaluate the code in the lexical scope of eval's caller
sub make_eval_closure { my $a = 5; sub ($s) { eval $s } };
is(make_eval_closure()('$a'), 5);

is(eval('5'), 5);
my $foo = 1234;
is(eval('$foo'), $foo);

# traps die?
ok(!eval('die; 1'));

ok(!eval('my @a = (1); @a<0>'), "eval returns undef on syntax error");