#!/usr/bin/pugs

use v6;
require Test;

plan 22;

=pod

Parameterized role tests, see L<S12/"Roles">

=cut

# L<S12/"Roles" /to be considered part of the long name:>
# L<A12/"Encapsulated Attributes" /to be considered part of the long name:/>
todo_eval_ok '
  role InitialAttribVal[: $val] {
    has $.attr = $val;
  }
', "parameterized role definition (1)";

my $a;
todo_eval_ok '$a does InitialAttribVal[42]',
  "imperative does to apply a parametrized role (1)";
todo_eval_is '$a.attr', 42,
  "attribute was initialized correctly (1)";
# L<A12/"Encapsulated Attributes" /In which case all of these are true:/>
todo_eval_ok '$a.meta.does(InitialAttribVal)',
  ".meta.does gives correct information (1-1)";
# L<A12/"Encapsulated Attributes" /but this is false:/>
todo_eval_ok '!$a.meta.does(InitialAttribVal[42])',
  ".meta.does gives correct information (1-2)";

my $b;
todo_eval_ok '$a does InitialAttribVal[23]',
  "imperative does to apply a parametrized role (2)";
todo_eval_is '$a.attr', 23,
  "attribute was initialized correctly (2)";
# L<A12/"Encapsulated Attributes" /In which case all of these are true:/>
todo_eval_ok '$a.meta.does(InitialAttribVal)',
  ".meta.does gives correct information (2-1)";
# L<A12/"Encapsulated Attributes" /but this is false:/>
todo_eval_ok '!$a.meta.does(InitialAttribVal[23])',
  ".meta.does gives correct information (2-2)";



# L<A12/"Parametric types" /but you can also parameterize other types explicitly:/>
# (Explanation: The role gets a parameter of type Type (e.g. Code, Num, etc.).
# Then, the method .hi accepts only {$foo}s of that $type.  Yes, it's a bit
# tricky. ;))
todo_eval_ok '
  role InitialAttribType[Type $type:] {
    method hi(::($type) $foo) { 42 }
  }
', "parameterized role definition (2)";
my $c;
todo_eval_ok '$c does InitialAttribType[Code]',
  "imperative does to apply a parametrized role (3)";
todo_eval_ok '$c.meta.does(InitialAttribType)',
  ".meta.does gives correct information (3-1)";
todo_eval_ok '$c.meta.does(InitialAttribType[Code])',
  ".meta.does gives correct information (3-2)";
todo_eval_is '$c.hi(sub {})', 42,
  "type information was processed correctly (1)";
todo_eval_ok '!try { $c.hi("not a code object") }',
  "type information was processed correctly (2)";




# Parameterized role using both a parameter which will add to the "long name"
# of the role and one which doesn't.
# (Explanation: This one is easier. The two attributes $.type and $.name will
# be predefined (using the role parameterization). The $type adds to the long
# name of the role, $name does not. Such:
#   my $a does InitialAttribBoth["foo", "bar"];
#   my $b does InitialAttribBoth["foo", "grtz"];
#   $a ~~ InitialAttribBoth                ==> true
#   $b ~~ InitialAttribBoth                ==> true
#   $a ~~ InitialAttribBoth["foo"]         ==> true
#   $b ~~ InitialAttribBoth["foo"]         ==> true
#   $a ~~ InitialAttribBoth["foo", "bar"]  ==> false
#   $b ~~ InitialAttribBoth["foo", "grtz"] ==> false
# Heavy stuff, eh?)
todo_eval_ok '
  role InitialAttribBoth[Str $type: Str $name] {
    has $.type = $type;
    has $.name = $name;
  }
', "parameterized role definition (3)";
my $d;
todo_eval_ok '$d does InitialAttribBoth["type1", "name1"]',
  "imperative does to apply a parametrized role (4)";
todo_eval_ok '$c.meta.does(InitialAttribType)',
  ".meta.does gives correct information (4-1)";
todo_eval_ok '$d.meta.does(InitialAttribType["type1"])',
  ".meta.does gives correct information (4-2)";
todo_eval_ok '!$d.meta.does(InitialAttribType["type1", "name1"])',
  ".meta.does gives correct information (4-3)";
todo_eval_is '$d.type', "type1", ".type works correctly";
todo_eval_is '$d.name', "name1", ".name works correctly";