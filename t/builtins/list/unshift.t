#!/usr/bin/pugs

use v6;
require Test;

=kwid

Unshift tests

=cut

plan 39;

# basic unshift tests

my @unshift1 = ();

is(+@unshift1, 0, 'we have an empty list');

unshift(@unshift1, 1);
is(+@unshift1, 1, 'we have 1 element in the list');
is(@unshift1[0], 1, 'we found the right element');

unshift(@unshift1, 2);
is(+@unshift1, 2, 'we have 2 elements in the list');
is(@unshift1[0], 2, 'we found the right element');
is(@unshift1[1], 1, 'we found the right element');

unshift(@unshift1, 3);
is(+@unshift1, 3, 'we have 3 element in the list');
is(@unshift1[0], 3, 'we found the right element');
is(@unshift1[1], 2, 'we found the right element');
is(@unshift1[2], 1, 'we found the right element');

unshift(@unshift1, 4);
is(+@unshift1, 4, 'we have 4 element in the list');
is(@unshift1[0], 4, 'we found the right element');
is(@unshift1[1], 3, 'we found the right element');
is(@unshift1[2], 2, 'we found the right element');
is(@unshift1[3], 1, 'we found the right element');

# try other variations on calling unshift()

my @unshift2 = ();

my $val = 100;

unshift @unshift2, $val;
is(+@unshift2, 1, 'we have 1 element in the list');
is(@unshift2[0], $val, 'unshift @list, $val worked');

@unshift2.unshift(200);
is(+@unshift2, 2, 'we have 2 elements in the list');
is(@unshift2[0], 200, '@unshift2.unshift(200) works');
is(@unshift2[1], $val, 'unshift @list, $val worked');

@unshift2.unshift(400);
is(+@unshift2, 3, 'we have 3 elements in the list');
is(@unshift2[0], 400, '@unshift2.unshift(400) works');
is(@unshift2[1], 200, '@unshift2.unshift(200) works');
is(@unshift2[2], $val, 'unshift @list, $val worked');

# try unshifting more than one element

my @unshift3 = ();

unshift @unshift3, (1, 2, 3);
is(+@unshift3, 3, 'we have 3 elements in the list');
is(@unshift3[0], 1, 'got the expected element');
is(@unshift3[1], 2, 'got the expected element');
is(@unshift3[2], 3, 'got the expected element');

my @val2 = (4, 5);
unshift @unshift3, @val2;  
is(+@unshift3, 5, 'we have 5 elements in the list');
is(@unshift3[0], 4, 'got the expected element');
is(@unshift3[1], 5, 'got the expected element');
is(@unshift3[2], 1, 'got the expected element');
is(@unshift3[3], 2, 'got the expected element');
is(@unshift3[4], 3, 'got the expected element');

# now for the unshift() on an uninitialized list issue

my @unshift4;

unshift @unshift4, 42;
is(+@unshift4, 1, 'we have 1 element in the list');
is(@unshift4[0], 42, 'got the element expected');

unshift @unshift4, 2000;
is(+@unshift4, 2, 'we have 1 element in the list');
is(@unshift4[0], 2000, 'got the element expected');
is(@unshift4[1], 42, 'got the element expected');

