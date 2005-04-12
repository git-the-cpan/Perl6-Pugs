#!/usr/bin/pugs

use v6;
require Test;

plan 7;

=pod

Pair list a la http://www.nntp.perl.org/group/perl.perl6.language/19360

=cut

skip(7, "Nested pairs does not parse correctly");

=pod

my $list = eval '(1 => (2 => (3 => 4)))';
isa_ok($list, 'Pair');

my $key = eval '$list.key';
is($key, 1, 'the key is 1');
isa_ok(eval '$list.value', 'Pair', '$list.value is-a Pair');
is(eval '$list.value.key', 2, 'the list.value.key is 2');
isa_ok(eval '$list.value.value', 'Pair', '$list.value.value is-a Pair');
is(eval '$list.value.value.key', 3, 'the list.value.value.key is 3');
is(eval '$list.value.value.value', 4, 'the list.value.value.value is 4');

=cut