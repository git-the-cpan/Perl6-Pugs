use v6;

class DateTime::Set-0.01;

has Set::Recurrence $.set;

=for TODO

    * constructors:
    * clone
    * size

    * union
    * intersection
    * complement
    * intersects
    * contains

    * is_empty
    * is_infinite

=cut

submethod BUILD (: $XXX) returns DateTime::Set {
    ...
}

method start () returns Object {
    return $.start;
}
method end () returns Object {
    return $.end;
}
method start_is_open () returns Bool {
    return $.start_is_open;
}
method start_is_closed () returns Bool {
    return ! $.start_is_open;
}
method end_is_open () returns Bool {
    return $.end_is_open;
}
method end_is_closed () returns Bool {
    return $.end_is_closed;
}


=kwid

= NAME

DateTime::Set - An object representing a datetime set

= SYNOPSIS

  use DateTime::Set;

  # XXX

= DESCRIPTION

This class represents a single span.

= CONSTRUCTORS

- `new()`

Without any parameters, returns an empty span.

- `new( start => $start )`

Given a start object, returns a span that has infinite size.

= OBJECT METHODS

The following methods are available for Set::Span objects:

- `start()`

Returns the start.

= AUTHOR

Flavio S. Glock, <fglock@pucrs.br>

= COPYRIGHT

Copyright (c) 2005, Flavio S. Glock.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
