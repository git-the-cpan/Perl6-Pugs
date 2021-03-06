use v6-alpha;
use Test;
plan 5;

# L<S29/"Hash"/"=item kv">

# (1,).kv works correctly
my @a = ();
@a = try { (1,).kv };
is(@a[0],0, "first element is 0", :todo<bug>);
is(@a[1],1, "second element is 1", :todo<bug>);

# ('a',).kv works correctly
@a = try { ('a',).kv };
is(@a[0],0, "first element is 0", :todo<bug>);
is(@a[1],'a', "second element is 'a'", :todo<bug>);

# Check that (42).kv does *not* work, as this it the same as $some_int.kv:
dies_ok { (42).kv }, "(42).kv should not and does not work";
