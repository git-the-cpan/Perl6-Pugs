use v6-alpha;

use Test;

plan 2;

=pod

This code shows the bug:
    pugs -e 'my @a = ("one", "two", "three"); sub foo (@a) { my $t = any(@a).pick(); say WHAT($t); say $t }; foo(@a)'

prints out:
    Array
    one two three

But this code:
    pugs -e 'my @a = ("one", "two", "three"); my $t = any(@a).pick(); say WHAT($t); say $t'

prints out:
    Str
    ("one" "two" or "three")
    
And this code:
    pugs -e 'sub foo2 { any(1 .. 10).pick() }; say WHAT(foo2());'

prints out:
    Int

    sub foo (@a) { my $t = any(@a).pick(); say WHAT($t); say $t }; foo(1..3)
succeeds:
    Int
    2

    my @b = (1..3); sub foo (@a) { my $t = any(@a).pick(); say WHAT($t); say $t }; foo(*@b);
succeeds:
    Int
    3

=cut

my @test_string = ("one", "two", "three"); 
my @test_int = 1 .. 10;

sub foo (@a) { any(@a).pick() }

isa_ok(foo(@test_string), 'Str');
isa_ok(foo(@test_int), 'Int');
