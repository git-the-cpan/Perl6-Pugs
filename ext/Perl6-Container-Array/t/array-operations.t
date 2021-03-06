use v6-alpha;
use Test;

plan 39;
force_todo <3 4 5 6 7 8 9 16 17 26 27>;

# use_ok( 'Perl6::Container::Array' );
use Perl6::Container::Array; 
use Perl6::Value::List;

{
  # string range
  my $iter = Perl6::Value::List.from_range( start => 'a', end => Inf, step => undef );
  is( $iter.shift, 'a', 'string range' );  
  is( $iter.shift, 'b', 'string range 1' );
}

{
  # 'Iter' object
  my $iter = Perl6::Value::List.from_range( start => 0, end => 13, step => 1 );
  my $span = Perl6::Container::Array.from_list( -1, 9, $iter );

  my $grepped = $span.to_list.Perl6::Value::List::grep:{ $_ % 3 == 0 };
  is( $grepped.shift, 9, 'grep  ' );  
  is( $grepped.shift, 0, 'grep 0' );
  is( $grepped.shift, 3, 'grep 1' );

  my $mapped = $grepped.map:{ $_ % 6 == 0 ?? ($_, $_) !! () };
  is( $mapped.shift,  6, 'map 0' );
  is( try { $mapped.shift },  6, 'map 1' );
  is( try { $mapped.shift }, 12, 'map 0' );
  is( try { $mapped.shift }, 12, 'map 1' );

  is( try { $mapped.shift }, undef, 'end' );
}

{
  # multidimensional lazy array
  my $iter = Perl6::Value::List.from_range( start => 0, end => 9, step => 1 );
  my $a1 = Perl6::Container::Array.from_list( $iter );
  my @a2 = 1..10;
  my $b1 = Perl6::Container::Array.from_list( $a1, [[@a2]] );  # XXX why does it need double []?
  isa_ok( $b1.shift, 'Perl6::Container::Array', 'without "splat", inserts an array' );
  isa_ok( $b1.shift, 'Array' );
}

{
  # splat
  my $iter = Perl6::Value::List.from_range( start => 0, end => 9, step => 1 );
  my $a1 = Perl6::Container::Array.from_list( $iter );
  my $b1 = Perl6::Container::Array.from_list( $a1.to_list, 1..10 );
  isa_ok( $b1.shift, 'Int', 'with "splat", inserts the elements' );
  isa_ok( $b1.shift, 'Int' );
}

{
  # uniq
  my $iter = Perl6::Value::List.from_range( start => 0, end => 9, step => 1 );
  my $a1 = Perl6::Container::Array.from_list( 1, $iter );
  $a1 = $a1.to_list.Perl6::Value::List::uniq;
  is( $a1.shift, 1, 'not seen element' );
  is( $a1.shift, 0, 'not seen element' );

  flunk "infinite loop";
# is( $a1.shift, 2, 'seen element was skipped' );

  # end
  $a1 = Perl6::Container::Array.from_list( $a1 );
  is( $a1.end, 9, 'end' );
  is( $a1.pop, 9, 'end is still there' );
}

{
  # coroutine
  
  my coro mylist { yield $_ for 1..2; yield; }
  
  my $iter = Perl6::Value::List.new( cstart => &mylist ); 
  my $a1 = Perl6::Container::Array.from_list( $iter );
  is( $a1.shift, 1, 'lazy array from coroutine' );
  is( $a1.shift, 2, 'coroutine' );
  is( $a1.shift, undef, 'coroutine end' );
  is( $a1.shift, undef, 'coroutine really ended' );
}

{
  # kv
  
  my coro mylist { yield $_ for 4..5; yield; }
  
  my $iter = Perl6::Value::List.new( cstart => &mylist ); 
  my $a1 = Perl6::Container::Array.from_list( $iter );
  $a1 = $a1.to_list.Perl6::Value::List::kv;
  is( $a1.shift, 0, 'kv' );
  is( $a1.shift, 4, 'kv' );

  flunk("erratic behaviour, disable for now");
  flunk("erratic behaviour, disable for now");
# is( $a1.shift, 1, 'kv' );
# is( $a1.shift, 5, 'kv' );
}

{
  # pairs
  
  my coro mylist { yield $_ for 4..5; yield; }
  
  my $iter = Perl6::Value::List.new( cstart => &mylist ); 
  my $a1 = Perl6::Container::Array.from_list( $iter );
  $a1 = $a1.to_list.Perl6::Value::List::pairs;
  my $p = $a1.shift;
  is( ~($p.WHAT),  'Pair',     'pair' );
  is( $p.perl, '(0 => 4)', 'pair' );
}

{
  # zip
  
  my coro mylist1 { yield $_ for 4..5; yield; }
  my $iter1 = Perl6::Value::List.new( cstart => &mylist1 ); 
  my $a1 =    Perl6::Container::Array.from_list( $iter1 );
  
  my coro mylist2 { yield $_ for 1..3; yield; }
  my $iter2 = Perl6::Value::List.new( cstart => &mylist2 ); 
  my $a2 =    Perl6::Container::Array.from_list( $iter2 );
  
  $a1 = $a1.to_list.Perl6::Value::List::zip( $a2 );
  is( try { $a1.shift }, 4, 'zip' );
  is( try { $a1.shift }, 1, 'zip' );
  is( try { $a1.shift }, 5, 'zip' );
  is( try { $a1.shift }, 2, 'zip' );
  is( try { $a1.shift }, undef, 'zip' );
  is( try { $a1.shift }, 3, 'zip' );
  is( try { $a1.shift }, undef, 'zip' );
}

{
  # elems
  my $iter = Perl6::Value::List.from_range( start => 1, end => 1000000, step => 2 );
  is( $iter.Perl6::Value::List::elems, 500000, 'Lazy List elems' );

  is( $iter.kv.Perl6::Value::List::elems, 1000000, 'Lazy List elems doubles after kv()' );

  my $a1 =    Perl6::Container::Array.from_list( 'z', $iter );
  is( $a1.elems, 500001, 'Lazy Array elems' );
}
