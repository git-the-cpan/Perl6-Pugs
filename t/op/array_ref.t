#!/usr/bin/pugs

use v6;
require Test;

=kwid

Array refs

=cut

plan 28;

# array_ref of strings

my $array_ref1 = ("foo", "bar", "baz");

is(+$array_ref1, 3, 'the array_ref1 has 3 elements');
is($array_ref1[0], 'foo', 'got the right value at array_ref1 index 0');
is($array_ref1[1], 'bar', 'got the right value at array_ref1 index 1');
is($array_ref1[2], 'baz', 'got the right value at array_ref1 index 2');

is($array_ref1.[0], 'foo', 'got the right value at array_ref1 index 0 using the . notation');

# array_ref with strings, numbers and undef

my $array_ref2 = [ "test", 1, undef ];

is(+$array_ref2, 3, 'the array_ref2 has 3 elements');
is($array_ref2[0], 'test', 'got the right value at array_ref2 index 0');
is($array_ref2[1], 1,      'got the right value at array_ref2 index 1');
is($array_ref2[2], undef,  'got the right value at array_ref2 index 2');

# array_ref slice

# NOTE:
# the [] creation must be forced here, because $array_ref<n> = is
# not seen as array_ref context, because it's not

my $array_ref4 = [ $array_ref2[2, 1, 0] ];

is(+$array_ref4, 3, 'the array_ref4 has 3 elements');
is($array_ref4[0], undef,  'got the right value at array_ref4 index 0');
is($array_ref4[1], 1,      'got the right value at array_ref4 index 1');
is($array_ref4[2], 'test', 'got the right value at array_ref4 index 2');

# create new array_ref with 2 array_ref slices

my $array_ref5 = [ $array_ref2[2, 1, 0], $array_ref1[2, 1, 0] ];

is(+$array_ref5, 6, 'the array_ref5 has 6 elements');
is($array_ref5[0], undef,  'got the right value at array_ref5 index 0');
is($array_ref5[1], 1,      'got the right value at array_ref5 index 1');
is($array_ref5[2], 'test', 'got the right value at array_ref5 index 2');
is($array_ref5[3], 'baz',  'got the right value at array_ref5 index 3');
is($array_ref5[4], 'bar',  'got the right value at array_ref5 index 4');
is($array_ref5[5], 'foo',  'got the right value at array_ref5 index 5');

# create an array_ref slice with an array_ref (in a variable)

my $slice = [ 2, 0, 1 ];
my $array_ref6 = [ $array_ref1[$slice] ];

is(+$array_ref6, 3, 'the array_ref6 has 3 elements');
is($array_ref6[0], 'baz', 'got the right value at array_ref6 index 0');
is($array_ref6[1], 'foo', 'got the right value at array_ref6 index 1');
is($array_ref6[2], 'bar', 'got the right value at array_ref6 index 2');

# create an array_ref slice with an array_ref constructed with []

my $array_ref7 = [ $array_ref1[[2, 1, 0]] ];

is(+$array_ref7, 3, 'the array_ref7 has 3 elements');
is($array_ref7[0], 'baz', 'got the right value at array_ref7 index 0');
is($array_ref7[1], 'bar', 'got the right value at array_ref7 index 1');
is($array_ref7[2], 'foo', 'got the right value at array_ref7 index 2');

