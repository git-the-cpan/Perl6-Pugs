use v6-alpha;

use Test;

plan 19;

=pod

Test attributes with recursively typed attributes

=cut

#L<S12/Attributes>
{
    class A {
        has A $.attr is rw;
    };

    ok !($!), 'Can create class with a recursively-typed attribute';

    my A $a;
    my A $b;
    try {
        $a .= new();
        $b .= new(:attr($a));
    };
    ok !($!), 'Can instantiate class with recursively-typed attribute';
    isa_ok $a, 'A', 'Sanity check, $a is of type A';
    is $b.attr, $a, "Recursively-typed attribute stores correctly";
    try {
        $a.attr = $b;
    };
    ok !($!), "Cycles are fine";
    is $b.attr.attr, $b, "Cycles resolve correctly";
}

#L<S12/Attributes/"Class attributes are declared">
{
    class B {
        my B $.attr is rw;
    };
    
    ok !($!), "Can create class with a recursively-typed class lexical";

    my B $a;
    try {
        $a .= new();
        B.attr = $a;
    };
    ok !($!), "Can instantiate class with recursively-typed class lexical";
    is B.attr, $a, "Recursively-typed class lexical stores correctly";
    
}

#L<S12/Methods/current lexically-determined class ::?CLASS>
{
    class C {
        has ::?CLASS $.attr is rw;
    };
    ok !($!), 'Can create class with attribute of type ::?CLASS';
    
    my C $a;
    my C $b;
    try {
        $a .= new();
        $b .= new(:attr($a));
    };
    ok !($!), 'Can instantiate class with ::?CLASS attribute';
    is $b.attr, $a, '::?CLASS attribute stores correctly';
    try {
        $a.attr = $b;
    };
    ok !($!), '::?CLASS cycles are fine';
    is $b.attr.attr, $b, '::?CLASS cycles resolve correctly';
    try {
        $a.attr .= new();
    };
    ok !($!), 'Can instantiate attribute of type ::?CLASS';
    isa_ok $a.attr, C, '::?CLASS instantiates to correct class';


    class D is C { };
    ok !($!), 'Can create a subclass of class with ::?CLASS attribute';
    my D $d;
    try {
        $d .= new();
        $d.attr .= new();
    };
    ok !($!), 'Can instantiate derived class with ::?CLASS attribute';
    isa_ok $d.attr, C, '::?CLASS is lexical, not virtual', :todo<bug>;
}

