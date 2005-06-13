#!/usr/bin/pugs

use v6;
use Test;

plan 70;
force_todo 2, 11, 19, 23, 34, 38;

=pod

Class attributes tests from L<S12/"Attributes">

=cut

dies_ok {
    has $.x;
}, "has only works inside of class|role definitions", :todo<feature>;

# L<S12/"Attributes" /the automatic generation of an accessor method of the same name\./>

class Foo1 { has $.bar; };

{
    my $foo = Foo1.new();
    ok($foo ~~ Foo1, '... our Foo1 instance was created');
    my $val;
    lives_ok {
        $val = $foo.can("bar")
    }, '.. checking autogenerated accessor existence', :todo<feature>;
    ok($val, '... $foo.can("bar") should have returned true', :todo<feature>);
    is($foo.bar(), undef, '.. autogenerated accessor works');
    is($foo.bar, undef, '.. autogenerated accessor works w/out parens');    
}

# L<S12/"Attributes" /Pseudo-assignment to an attribute declaration specifies the default/>

eval 'class Foo2 { has $.bar = "baz"; }';

{
    my $foo = eval 'Foo2.new()';
    eval_ok('$foo ~~ Foo2', '... our Foo2 instance was created', :todo<feature>);
    eval_ok('$foo.can("bar")', '.. checking autogenerated accessor existence', :todo<feature>);
    eval_is('$foo.bar()', "baz", '.. autogenerated accessor works', :todo<feature>);
    eval_is('$foo.bar', "baz", '.. autogenerated accessor works w/out parens', :todo<feature>);    
    # what exactly will happen if we try to set bar()
}

# L<S12/"Attributes" /trait causes the generated accessor to be declared C\<rw\>\, making it/>

class Foo3 { has $.bar is rw; };

{
    my $foo = Foo3.new();
    ok($foo ~~ Foo3, '... our Foo3 instance was created');
    my $val;
    lives_ok {
        $val = $foo.can("bar");
    }, '.. checking autogenerated accessor existence', :todo<feature>;
    ok($val, '... $foo.can("bar") should have returned true', :todo<feature>);
    is($foo.bar(), undef, '.. autogenerated accessor works');
    lives_ok {
        $foo.bar = "baz";
    }, '.. autogenerated mutator as lvalue works';
    is($foo.bar, "baz", '.. autogenerated mutator as lvalue set the value correctly');    
    lives_ok {
        $foo.bar("baz2");
    }, '.. autogenerated mutator works as method', :todo<feature>;    
    is($foo.bar, "baz2", '.. autogenerated mutator as method set the value correctly', :todo<feature>);        
}

# L<S12/"Attributes" /Private attributes use a colon to indicate that no public accessor is/>

class Foo4 { has $:bar; };

{
    my $foo = Foo4.new();
    ok($foo ~~ Foo4, '... our Foo4 instance was created');
    eval_ok('!$foo.can("bar")', '.. checking autogenerated accessor existence', :todo<feature>);
}

eval 'class Foo4a { has $:bar = "baz"; }';

{
    my $foo = eval 'Foo4a.new()';
    eval_ok('$foo ~~ Foo4a', '... our Foo4a instance was created', :todo<feature>);
    eval_ok('!$foo.can("bar")', '.. checking autogenerated accessor existence', :todo<feature>);
}


# L<S12/"Attributes">

class Foo5 {
  has $.tail is rw;
  has @.legs;
  has $:brain;

  method set_legs  (*@legs) { @.legs = @legs }
  method inc_brain ()      { $:brain++ }
  method get_brain ()      { $:brain }
};

{
    my $foo = Foo5.new();
    ok($foo ~~ Foo5, '... our Foo5 instance was created');
        
    lives_ok {
        $foo.tail = "a";
    }, "setting a public rw attribute";
    is($foo.tail, "a", "getting a public rw attribute");
    
    lives_ok {
        $foo.set_legs(1,2,3)
    }, "setting a public ro attribute (1)";
    is($foo.legs.[1], 2, "getting a public ro attribute (1)");
    
    dies_ok {
        $foo.legs = (4,5,6);
    }, "setting a public ro attribute (2)", :todo<feature>;
    is($foo.legs.[1], 2, "getting a public ro attribute (2)", :todo<feature>);
    
    lives_ok {
        $foo.inc_brain();
    },  "modifiying a private attribute (1)";
    is($foo.get_brain, 1, "getting a private attribute (1)");
    lives_ok {
        $foo.inc_brain();
    },  "modifiying a private attribute (2)";
    is($foo.get_brain, 2, "getting a private attribute (2)");
}

# L<S12/"Construction and Initialization" /If you name an attribute as a parameter, that attribute is initialized directly, so/>

class Foo6 {
  has $.bar is rw;
  has $.baz;
  has $:hidden;

  submethod BUILD($.bar, $.baz, $:hidden) {}
  method get_hidden() { $:hidden }
}

{
    my $foo = Foo6.new(bar => 1, baz => 2, hidden => 3);
    ok($foo ~~ Foo6, '... our Foo6 instance was created');
        
    is($foo.bar,        1, "getting a public rw attribute (1)", :todo<bug>);
    is($foo.baz,        2, "getting a public rw attribute (2)", :todo<bug>);
    is($foo.get_hidden, 3, "getting a private ro attribute (3)", :todo<bug>);
}

# check that doing something in submethod BUILD works
class Foo6a {
  has $.bar is rw;
  has $.baz;
  has $:hidden;

  submethod BUILD($.bar, $.baz, $:hidden) {
    $.baz = 5;
  }
  method get_hidden() { $:hidden }
}

{
    my $foo = Foo6a.new(bar => 1, hidden => 3);
    ok($foo ~~ Foo6a, '... our Foo6a instance was created');
        
    is($foo.bar,        1, "getting a public rw attribute (1)", :todo<bug>);
    is($foo.baz,        5, "getting a public rw attribute (2)");
    is($foo.get_hidden, 3, "getting a private ro attribute (3)", :todo<bug>);
}

# L<A12/"Default Values">
eval_ok 'class Foo7 { has $.attr = 42 }', "class definition worked", :todo<feature>;
eval_is 'Foo7.new.attr', 42,              "default attribute value (1)", :todo<feature>;

# L<A12/"Default Values" /is equivalent to this:/>
eval_ok 'class Foo8 { has $.attr is build(42) }',
  "class definition using 'is build' worked", :todo<feature>;
eval_is 'Foo8.new.attr', 42, "default attribute value (2)", :todo<feature>;

# L<A12/"Default Values" /is equivalent to this:/>
eval_ok 'class Foo9 { has $.attr will build(42) }',
  "class definition using 'will build' worked", :todo<feature>;
eval_is 'Foo9.new.attr', 42, "default attribute value (3)", :todo<feature>;

my $was_in_supplier = 0;
sub forty_two_supplier() { $was_in_supplier++; 42 }
# XXX: Currently hard parsefail!
#todo_eval_ok 'class Foo10 { has $.attr = { forty_two_supplier() } }',
#  "class definition using '= {...}' worked";
fail "hard parsefail", :todo<feature>;
eval_is 'Foo10.new.attr', 42, "default attribute value (4)", :todo<feature>;
is      $was_in_supplier, 1,  "forty_two_supplier() was actually executed (1)", :todo<feature>;

# The same, but using 'is build {...}'
# XXX: Currently hard parsefail!
#todo_eval_ok 'class Foo11 { has $.attr is build { forty_two_supplier() } }',
#  "class definition using 'is build {...}' worked";
fail "hard parsefail", :todo<feature>;
eval_is 'Foo11.new.attr', 42, "default attribute value (5)", :todo<feature>;
is      $was_in_supplier, 2,  "forty_two_supplier() was actually executed (2)", :todo<feature>;

# The same, but using 'will build {...}'
# XXX: Currently hard parsefail!
#todo_eval_ok 'class Foo12 { has $.attr will build { forty_two_supplier() } }',
#  "class definition using 'will build {...}' worked";
fail "hard parsefail", :todo<feature>;
eval_is 'Foo11.new.attr', 42, "default attribute value (6)", :todo<feature>;
is      $was_in_supplier, 3,  "forty_two_supplier() was actually executed (3)", :todo<feature>;

# check that doing something in submethod BUILD works
class Foo7 {
  has $.bar;
  has $.baz;

  submethod BUILD (?$.bar = 5, ?$baz = 10 ) {
    $.baz = 2 * $baz;
  }
}

my $foo7 = Foo7.new();
is( $foo7.bar, 5,
    'optional attribute should take default value without passed-in value' );
is( $foo7.baz, 20,
    '... optional non-attribute should too' );
$foo7    = Foo7.new( :bar(4), :baz(5) );
is( $foo7.bar, 4,
    'optional attribute should take passed-in value over default', :todo<bug> );
is( $foo7.baz, 10,
    '... optional non-attribute should too' );


# check that args are passed to BUILD
class Foo8 {
  has $.a;
  has $.b;
  
  submethod BUILD(+$foo, +$bar) {
    $.a = $foo;
    $.b = $bar;
  }
}

{
    my $foo = Foo8.new(foo => 'c', bar => 'd');
    ok($foo.isa(Foo8), '... our Foo8 instance was created');
        
    is($foo.a, 'c', 'BUILD received $foo');
    is($foo.b, 'd', 'BUILD received $bar');
}

# check mixture of positional/named args to BUILD

class Foo9 {
  has $.a;
  has $.b;
  
  submethod BUILD($foo, +$bar) {
    $.a = $foo;
    $.b = $bar;
  }
}

{
    my $foo = Foo9.new('pos', bar => 'd');
    ok($foo.isa(Foo9), '... our Foo9 instance was created');
        
    is($foo.a, 'pos', "BUILD received 'pos'", :todo<feature>);
    is($foo.b, 'd',   'BUILD received $bar');
}

# check $self is passed to BUILD
class Foo10 {
  has $.a;
  has $.b;
  has $.c;
  
  submethod BUILD(Class $self: +$foo, +$bar) {
    $.a = $foo;
    $.b = $bar;
    $.c = 'y' if $self.isa(Foo10);
  }
}

{
    my $foo = Foo10.new(foo => 'c', bar => 'd');
    ok($foo.isa(Foo10), '... our Foo10 instance was created');
    
    is($foo.a, 'c', 'BUILD received $foo');
    is($foo.b, 'd', 'BUILD received $bar');
    is($foo.c, 'y', 'BUILD received $self');
}
