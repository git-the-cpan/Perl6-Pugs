use v6-alpha;


use Test;
plan 23;

=head1 DESCRIPTION

Basic C<exists> tests, see S29.

=cut

# L<S29/"Array"/=item exists>

my @array = <a b c d>;
ok @array.exists(0),    "exists(positive index) on arrays (1)";
ok @array.exists(1),    "exists(positive index) on arrays (2)";
ok @array.exists(2),    "exists(positive index) on arrays (3)";
ok @array.exists(3),    "exists(positive index) on arrays (4)";
ok !@array.exists(4),   "exists(positive index) on arrays (5)";
ok !@array.exists(42),  "exists(positive index) on arrays (2)";
ok @array.exists(-1),   "exists(negative index) on arrays (1)";
ok @array.exists(-2),   "exists(negative index) on arrays (2)";
ok @array.exists(-3),   "exists(negative index) on arrays (3)";
ok @array.exists(-4),   "exists(negative index) on arrays (4)";
ok !@array.exists(-5),  "exists(negative index) on arrays (5)";
ok !@array.exists(-42), "exists(negative index) on arrays (6)";

# L<S29/"Hash"/=item exists>
my %hash = (a => 1, b => 2, c => 3, d => 4);
ok %hash.exists("a"),   "exists on hashes (1)";
ok !%hash.exists("42"), "exists on hashes (2)";

# This next group added by Darren Duncan following discovery while debugging ext/Locale-KeyedText:
# Not an exists() test per se, but asserts that elements shouldn't be added to 
# (exist in) a hash just because there was an attempt to read nonexistent elements.
{
  sub foo( $any ) {}
  sub bar( $any is copy ) {}

  my $empty_hash = hash();
  is( $empty_hash.pairs.sort.join( ',' ), '', "empty hash stays same when read from (1)" );
  $empty_hash{'z'};
  is( $empty_hash.pairs.sort.join( ',' ), '', "empty hash stays same when read from (2)" );
  bar( $empty_hash{'y'} );
  is( $empty_hash.pairs.sort.join( ',' ), '', "empty hash stays same when read from (3)" );
  my $ref = \( $empty_hash{'z'} );
  is( $empty_hash.pairs.sort.join( ',' ), '', "taking a reference to a hash element does not auto-vivify the element");
  foo( $empty_hash{'x'} );
  is( $empty_hash.pairs.sort.join( ',' ), '', "empty hash stays same when read from (4)", :todo<bug> );

  my $popul_hash = hash(('a'=>'b'),('c'=>'d'));
  my sub popul_hash_contents () {
    $popul_hash.pairs.sort.map:{ $_.key ~ ":" ~ $_.value }.join( ',' );
  }

  is( popul_hash_contents, "a:b,c:d", "populated hash stays same when read from (1)" );
  $popul_hash{'z'};
  is( popul_hash_contents, "a:b,c:d", "populated hash stays same when read from (2)" );
  bar( $popul_hash{'y'} );
  is( popul_hash_contents, "a:b,c:d", "populated hash stays same when read from (3)" );
  foo( $popul_hash{'x'} );
  is( popul_hash_contents, "a:b,c:d", "populated hash stays same when read from (4)", :todo<bug> );
}
