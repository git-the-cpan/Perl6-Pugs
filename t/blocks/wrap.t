use v6-alpha;

use Test;

# L<S06/Wrapping>

# TODO
# named wrapping/unwrapping
# unwrap with no args pops the top most
#
# mutating wraps -- those should be "deep", as in not touching coderefs
# but actually mutating how the coderef works.
#
# of course, if we allow assigning into coderefs, then the wrap semantic
# could become a simple reassignment; but that is unspecced.

plan 20;

my @log;

sub foo {
    push @log, "foo";
}

sub wrapper {
    push @log, "wrapper before";
    try { call };
    push @log, "wrapper after";
}

sub other_wrapper {
    push @log, "wrapper2";
    try { call };
}

foo();
is(+@log, 1, "one event logged");
is(@log[0], "foo", "it's foo");

@log = ();

wrapper();
is(+@log, 2, "two events logged");
is(@log[0], "wrapper before", "wrapper before");
is(@log[1], "wrapper after", "wrapper after");

@log = ();

my $wrapped;
try {
    $wrapped = &foo.wrap(&wrapper);
};

isa_ok($wrapped, "Sub", :todo);

$wrapped ||= -> { };
try { $wrapped.() };

is(+@log, 3, "three events logged", :todo);
is(@log[0], "wrapper before", "wrapper before", :todo);
is(@log[1], "foo", "the wrapped sub", :todo);
is(@log[2], "wrapper after", "wrapper after", :todo);

@log = ();

my $doublywrapped;
try {
    $doublywrapped = $wrapped.wrap(&other_wrapper);
};

isa_ok($doublywrapped, "Sub", :todo);
$doublywrapped ||= -> { };
try { $doublywrapped.() };

is(+@log, 4, "four events", :todo);
is(@log[0], "wrapper2", "additional wrapping takes effect", :todo);
is(@log[1], "wrapper before", "... on top of initial wrapping", :todo);

@log = ();

try { $wrapped.() };
is(+@log, 3, "old wrapped sub was not destroyed", :todo);
is(@log[0], "wrapper before", "the original wrapper is still in effect", :todo);


@log = ();

my $unwrapped;
try {
    $unwrapped = $wrapped.unwrap(&wrapper);
};

isa_ok($unwrapped, "Sub", :todo);
$unwrapped ||= -> {};
try { $unwrapped.() };

is(+@log, 2, "two events for unwrapped", :todo);
is(@log[0], "wrapper2", :todo);
is(@log[1], "foo", :todo);
