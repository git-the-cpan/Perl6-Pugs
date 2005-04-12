#!/usr/bin/pugs

use v6;
require Test;

=kwid 

Pop tests

=cut

plan 20;

my @pop1 = (1, 2, 3, 4);

is(+@pop1, 4, 'we have 4 elements in the list');
my $a = pop(@pop1);
is($a, 4, 'pop(@pop1) works');

is(+@pop1, 3, 'we have 3 elements in the list');
my $a = pop @pop1;
is($a, 3, 'pop @pop1 works');

is(+@pop1, 2, 'we have 2 elements in the list');
my $a = @pop1.pop();
is($a, 2, '@pop1.pop() works');

is(+@pop1, 1, 'we have 1 element in the list');
my $a = @pop1.pop;
is($a, 1, '@pop1.pop works');

is(+@pop1, 0, 'we have no more element in the list');
ok(!defined(pop(@pop1)), 'after the list is exhausted pop() returns undef');


my @pop2 = (1, 2, 3, 4);

is(+@pop2, 4, 'we have 4 elements in the list');
is(pop(@pop2), 4, 'inline pop(@pop2) works');

is(+@pop2, 3, 'we have 3 elements in the list');
is(pop @pop2, 3, 'inline pop @pop2 works');

is(+@pop2, 2, 'we have 2 elements in the list');
is(@pop2.pop(), 2, 'inline @pop2.pop() works');

is(+@pop2, 1, 'we have 1 element in the list');
is(@pop2.pop, 1, 'inline @pop2.pop works');

is(+@pop2, 0, 'we have no more element in the list');
ok(!defined(pop(@pop2)), 'after the list is exhausted pop() returns undef');

