#!/usr/bin/pugs

use v6;
require Test;

=kwid 

Pair test

=cut

plan 36;

# basic Pair

my $pair = 'foo' => 'bar';
isa_ok($pair, 'Pair');

# get key and value from the pair as many was as possible

is(key($pair), 'foo', 'got the right key($pair)');
is(value($pair), 'bar', 'got the right value($pair)');

is(key $pair, 'foo', 'got the right key $pair');
is(value $pair, 'bar', 'got the right value $pair');

is($pair.key(), 'foo', 'got the right $pair.key()');
is($pair.value(), 'bar', 'got the right $pair.value()');

is($pair.key, 'foo', 'got the right $pair.key');
is($pair.value, 'bar', 'got the right $pair.value');

# get both (kv) as many ways as possible

my @pair1a = kv($pair);
is(+@pair1a, 2, 'got the right number of elements in the list');
is(@pair1a[0], 'foo', 'got the right key');
is(@pair1a[1], 'bar', 'got the right value');

my @pair1b = kv $pair;
is(+@pair1b, 2, 'got the right number of elements in the list');
is(@pair1b[0], 'foo', 'got the right key');
is(@pair1b[1], 'bar', 'got the right value');

my @pair1c = $pair.kv;
is(+@pair1c, 2, 'got the right number of elements in the list');
is(@pair1c[0], 'foo', 'got the right key');
is(@pair1c[1], 'bar', 'got the right value');

my @pair1d = $pair.kv();
is(+@pair1d, 2, 'got the right number of elements in the list');
is(@pair1d[0], 'foo', 'got the right key');
is(@pair1d[1], 'bar', 'got the right value');

# Pair with a numeric value

my $pair2 = 'foo' => 2;
isa_ok($pair2, 'Pair');

is($pair2.value, 2, 'got the right value');

# Pair with a Pair value

my $pair3 = "foo" => ("bar" => "baz");
isa_ok($pair3, 'Pair');

my $pair3a = $pair3.value;
isa_ok($pair3a, 'Pair');
is($pair3a.key, 'bar', 'got right nested pair key');
is($pair3a.value, 'baz', 'got right nested pair key');

is($pair3.value.key, 'bar', 'got right nested pair key (method chaining)');
is($pair3.value.value, 'baz', 'got right nested pair key (method chaining)');

# Pair with a Pair key

my $pair4 = ("foo" => "bar") => "baz";
isa_ok($pair4, 'Pair');

is($pair4.value, 'baz', 'got the right value');

isa_ok($pair4.key, 'Pair');
is($pair4.key.key, 'foo', 'got right nested key');
is($pair4.key.value, 'bar', 'got right nested value');

my $quux = (quux => "xyzzy");
is($quux.key, 'quux', "lhs quotes" );

# lvalue Pair assignments from S06 and thread starting with
# http://www.nntp.perl.org/group/perl.perl6.language/19425

my $val;
eval '("foo" => $val) = "baz"';
todo_ok($val eq "baz", "lvalue lists");

