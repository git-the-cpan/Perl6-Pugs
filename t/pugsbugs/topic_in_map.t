#!/usr/bin/pugs

use v6;
use Test;

plan 5;

# Note: int is only an example, say and all other builtins which default to $_
# don't work, either.
is ~((1,2,3).map:{ int $_ }), "1 2 3", "dependency for following test (1)";
$_ = 4; is int, 4,                   "dependency for following test (2)";
is ~((1,2,3).map:{ int }),    "1 2 3", 'int() should default to $_ inside map, too', :todo<bug>;

# This works...
is ~(({1},{2},{3}).map:{ $_; $_() }), "1 2 3", 'lone $_ in map should work (1)';
# ...but this hardfails!
fail 'lone $_ in map should work (2)', :todo<bug>;
#is +(({1},{2},{3}).map:{ $_() }), "1 2 3", 'lone $_ in map should work';