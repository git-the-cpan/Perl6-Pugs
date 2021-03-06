use v6-alpha;

use Span;
# Set::Symbols is defined in the Recurrence.pm package
use Set::Symbols;
use Set::Infinite::Functional;

class Set::Infinite-0.01
    does Set::Symbols
{
    has Set::Infinite::Functional $.set;

=begin TODO

  Bugs:
    * Lazy lists are not implemented
    * Constructors should emit error messages if there are unknown parameters

  Tests:
    * unicode, overloading - ~ <=> 
    * compare - depends on finishing Set::Infinite::Functional.compare() 
      and Span::Code.compare()
    * contains
    * size
   
  Constructor:
    * new() from Array
   
  Methods:
    * set_start_open / set_start_closed
    * set_end_open / set_end_closed - better names ?
    * is_singleton
    * first_span/last_span; span_iterator
    * see also: Span.pm TODO

  Optimizations:
    * create a store for single elements (Span::Singleton)
    * use binary search instead of linear search

  From Perl5 version of Set::Infinite:
    * "backtracking"  
    * map / grep / intersected_spans / span 
    * recurrence of spans

  From "Set" API:
    * equal/not_equal
    * symmetric_difference
    * proper_subset
    * proper_superset
    * subset
    * superset
    * includes/member/has

=cut

submethod BUILD ($class: *%param ) {    
    my @spans;
    for %param<objects spans recurrence>.map:{ $_ ?? @$_ !! () } -> $span {
        # TODO - write t/test for Array (such as 1 .. 10 and 1..10,20..30)
        next unless defined( $span );
        my $sp;
        if $span.isa( 'Recurrence' ) {
            $sp = Span.new().union( $span );
        }
        else {
            $sp = Span.new( object => $span );
        }
        next if $sp.is_empty;
        push @spans, $sp;
    }
    # TODO - use reduce()
    $.set = Set::Infinite::Functional.empty_set();
    $.set = $.set.union( Set::Infinite::Functional.new( spans => [$_] ) ) for @spans;
}

method universal_set ($class: ) returns Set::Infinite { 
    $class.new( spans => [Span.new( start => -Inf, end => Inf )] );
}

method empty_set ($class: ) returns Set::Infinite { $class.new() }

method spans ()         returns List of Span {
    my $set = $.set;
    return $set.spans;
}
method is_empty ()      returns bool   { return $.set.is_empty }
method is_infinite ()   returns bool   { return $.set.is_infinite }
method start ()         returns Object { return $.set.start }
method end ()           returns Object { return $.set.end }
method start_is_open () returns Bool   { return $.set.start_is_open }
method start_is_closed () returns Bool { return $.set.start_is_closed }
method end_is_open ()   returns Bool   { return $.set.end_is_open }
method end_is_closed () returns Bool   { return $.set.end_is_closed }
method stringify ()     returns String { return $.set.stringify }
method size ()          returns Object { return $.set.size }

submethod _normalize_parameter ($self: $span) {
    # is it a Set::Infinite ?
    return $span.set if $span.isa( $self.WHAT );
    # is it a Set::Infinite::Functional ?
    my $span0 = $self.set;
    return $span if $span.isa( $span0.WHAT );
    # new() knows what to do: Span, Span::Num, Span.Int, Object
    my $result = $self.new( spans => $span );
    return $result.set;
}

method compare ($self: $span is copy) {
    my $span0 = $self.set;
    my $span1 = $self._normalize_parameter( $span );
    return $span0.compare( $span1 );
}

method contains ($self: $span is copy) returns bool {
    return Bool::False if $.span.is_empty;
    my $span0 = $self.set;
    my $span1 = $self._normalize_parameter( $span );
    my $union = $span0.union( $span1 );
    return $span0.compare( $union ) == 0;
}

method intersects ($self: $span is copy) returns bool {
    my $span0 = $self.set;
    my $span1 = $self._normalize_parameter( $span );
    return $span0.intersects( $span1 );
}

method union ($self: $span ) returns Set::Infinite {
    my $span0 = $self.set;
    my $span1 = $self._normalize_parameter( $span );
    my $tmp = $span0.union( $span1 );
    my $res = Set::Infinite.new();
    $res.set = $tmp;
    return $res;
}
method intersection ($self: $span ) returns Set::Infinite {
    my $span0 = $self.set;
    my $span1 = $self._normalize_parameter( $span );
    my $tmp = $span0.intersection( $span1 );
    my $res = Set::Infinite.new();
    $res.set = $tmp;
    return $res;
}
method complement ($self: ) returns Set::Infinite {
    my $span0 = $self.set;
    my $tmp = $span0.complement;
    my $res = Set::Infinite.new();
    $res.set = $tmp;
    return $res;
}
method difference ($self: $span ) returns Set::Infinite {
    my $span0 = $self.set;
    my $span1 = $self._normalize_parameter( $span );
    my $tmp = $span1.complement;
    $tmp = $span0.intersection( $tmp );
    my $res = Set::Infinite.new();
    $res.set = $tmp;
    return $res;
}

# mutators

method add ($self: $span ) {
    my $tmp = $self.union( $span );
    $.set = $tmp.set;
}
method remove ($self: $span ) {
    my $tmp = $self.difference( $span );
    $.set = $tmp.set;
}

# scalar methods, iterators

method next ( $x ) { 
    # TODO - simplify this 
    for $.set.spans {
        my $result = $_.next( $x );
        return $result if $result != Inf;
    }
    return Inf;
}

method previous ( $x ) { 
    # TODO - simplify this 
    my @a = $.set.spans;
    @a = reverse @a;
    for @a {
        my $result = $_.previous( $x );
        return $result if $result != -Inf;
    }
    return -Inf;
}

method current ($self: $x ) {
    return $self.next( $self.previous( $x ) );
}

method closest ($self: $x ) {
    my $n = $self.next( $x );
    my $p = $self.current( $x );
    return $n - $x < $x - $p ?? $n !! $p;
}

method iterator ($self: ) returns Set::Infinite::Iterator {
    return ::Set::Infinite::Iterator.new( set => $.set );
}

coro lazy ($self: ) {
    my $iter = $self.iterator();
    loop { 
        my $n = $iter.next;
        return unless defined $n;
        yield $n;
    }
}

} # class Set::Infinite

class Set::Infinite::Iterator
{
    has $.current_span;
    has $.current;
    has $.set;
    submethod BUILD ( $.set ) {}
    method next ($self: ) {
        # TODO - simplify this
        my @spans = $.set.spans;
        loop {
            if defined $.current {
                my $span = @spans[$.current_span];
                $.current = $span.next( $.current );                
            }
            else {
                if defined $.current_span {
                    $.current_span++ 
                }
                else {
                    $.current_span = 0
                }
                if $.current_span > @spans.end {
                    $self.reset();
                    return;
                }
                my $span = @spans[$.current_span];
                $.current = $span.next( -Inf );
            }
            return $.current if $.current != Inf;
            undefine $.current;
        }
    }
    method previous ($self: ) {
        # TODO - simplify this
        my @spans = $.set.spans;
        loop {
            if defined $.current {
                my $span = @spans[$.current_span];
                $.current = $span.previous( $.current );                
            }
            else {
                if defined $.current_span {
                    $.current_span--
                }
                else {
                    $.current_span = @spans.end
                }
                if $.current_span < 0 {
                    $self.reset();
                    return;
                }
                my $span = @spans[$.current_span];
                $.current = $span.previous( Inf );
            }
            return $.current if $.current != -Inf;
            undefine $.current;
        }
    }
    method reset () {
        undefine $.current_span;
        undefine $.current;
    }
}

=kwid

= NAME

Set::Infinite - An object representing an ordered set of spans

= SYNOPSIS

  use Set::Infinite;

  my $set = Set::Infinite.new( spans => $span );

= DESCRIPTION

This class represents an ordered set of spans.

The problem this class solves is when you need do perform "set" operations on 
Span objects, that return lists of spans.

In this example, @span may contain zero, one, two, or three spans, depending on
the contents of $span1 and $span2:

  @span = $span1.union( $span2 );
  say @span.map:{ .stringify }.join(",");

On the other hand, a Set::Infinite object is more practical to work with:

  $set = $set1.union( $set2 );
  say $set.stringify;

= CONSTRUCTORS

- `new()`

Without any parameters, returns an empty span.

- `new( objects => ( 1, 3, 9 ) )`

Creates a `Set::Infinite` object with a few elements.

- `new( spans => ( $span1, $span2 ) )`

Creates a `Set::Infinite` object using existing Span objects.

- `new( recurrence => $recurr )`

Creates a `Set::Infinite` object using an existing Recurrence object.

- `universal_set()`

Creates an object with a continuous span (-Inf..Inf).

- `empty_set()`

Creates an empty set.

= OBJECT METHODS

The following methods are available for Set::Infinite objects:

- `start()` / `end()`

Return the start or end value of the set.

These methods may return nothing if the set is empty.

- `start_is_open()` / `end_is_open()` / `start_is_closed()` / `end_is_closed()`

Return a logical value, whether the `start` or `end` values belong to the 
set ("closed") or not ("open").

- `size()`

Return the "size" of the set.

For example: if `start` and `end` are times, then `size` will be a duration.

If the set contains lazy recurrences, it may not be possible to calculate the 
set size.

- `contains( $object )` / `intersects( $object )`

These methods return a logical value. 

The argument can be a Set::Infinite, a Span object, a Recurrence object, or a scalar value.

- `union( $object )` / `intersection( $span )` / `difference( $object )`

Returns a Set::Infinite. 

The argument can be a Set::Infinite, a Span object, a Recurrence object, or a scalar value.

- `complement()`

Returns a Set::Infinite.

- `stringify()`

Return a string representation of the set.

- `compare( $object )`

Compares the sets numerically. Returns -1, 0, or 1.

The argument can be a Set::Infinite, a Span object, a Recurrence object, or a scalar value.

- `is_empty()`

Returns `true` if the set is empty.

- `is_infinite()`

Returns true if the start or the end of the set are Infinite.

= ITERATORS AND LIST OPERATIONS

- `spans()`

Returns a list of `Span` objects.

- `iterator()`

Returns an iterator:

    $iter = $set.iterator;
    say $i while $i = $iter.next;

The iterator has `next()`, `previous()`, `current()`, and `reset()` methods.

If the set is "continuous", this method emits a warning and returns undef.

- `lazy()`

Makes a lazy iterator:

    say $a while $a = $set.lazy;

= MUTATOR METHODS

- `add( $set )`

Includes new elements in the set

- `remove( $set )`

Removes elements from the set

= SEE ALSO

    Span
    
    Recurrence

= AUTHOR

Flavio S. Glock, <fglock@gmail.com>

= COPYRIGHT

Copyright (c) 2005, Flavio S. Glock.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
