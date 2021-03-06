#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 24;
use Test::Exception;

use Perl6::MetaModel;

=pod

This test is primarily focues on Roles and subroles

=cut

my $Foo = $::Role->new('$:name' => 'Foo');
isa_ok($Foo, 'Role');
ok(!$Foo->isa('Foo'), '... $Foo is not a Foo'); 

ok($Foo->does('Role'), '... our role does Role');

ok($Foo->does('Foo'), '... our role does Foo');
ok(!$Foo->does('Baz'), '... our role does not do Baz');

my $Bar = $::Role->new('$:name' => 'Bar');
isa_ok($Bar, 'Role');
ok(!$Bar->isa('Bar'), '... $Bar is not a Bar'); 

ok($Bar->does('Bar'), '... our role does Bar');
ok(!$Bar->does('Baz'), '... our role does not do Baz');

is_deeply(
    $Foo->roles(),
    [],
    '... no subroles yet in Foo');

$Foo->roles([ $Bar ]);

is_deeply(
    $Foo->roles(),
    [ $Bar ],
    '... subroles added successfully');

ok($Foo->does('Foo'), '... our role still does Foo');
ok($Foo->does('Bar'), '... our role does Bar');
ok(!$Foo->does('Baz'), '... our role still does not do Baz');

my $Baz = $::Role->new('$:name' => 'Baz');
isa_ok($Baz, 'Role');
ok(!$Baz->isa('Baz'), '... $Baz is not a Baz'); 

ok($Baz->does('Baz'), '... our role does Baz');

is_deeply(
    $Bar->roles(),
    [],
    '... no subroles yet in Bar');

$Bar->roles([ $Baz ]);

is_deeply(
    $Bar->roles(),
    [ $Baz ],
    '... subroles added successfully');
    
ok($Bar->does('Bar'), '... our role still does Bar');
ok($Bar->does('Baz'), '... our role now does Baz');    

ok($Foo->does('Foo'), '... our role still does Foo');
ok($Foo->does('Bar'), '... our role still does Bar');
ok($Foo->does('Baz'), '... our role now does Baz');

