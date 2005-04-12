#!/usr/bin/pugs

use v6;
require Test;

=kwid

I/O tests

=cut

plan 48;

my $filename = 'tempfile';

# create and write a file

my $out = open(">$filename");
isa_ok($out, 'IO');
$out.print("Hello World\n");
print($out, "Foo Bar Baz\n");
$out.print("The End\n");
ok($out.close, 'file closed okay');

# read the file all possible ways

my $in1 = open($filename);
isa_ok($in1, 'IO');
my $line1a = readline($in1);
is($line1a, "Hello World\n", 'readline($in) worked');
my $line1b = readline($in1);
is($line1b, "Foo Bar Baz\n", 'readline($in) worked');
my $line1c = readline($in1);
is($line1c, "The End\n", 'readline($in) worked');
ok($in1.close, 'file closed okay');

my $in2 = open($filename);
isa_ok($in2, 'IO');
my $line2a = $in2.readline();
is($line2a, "Hello World\n", '$in.readline() worked');
my $line2b = $in2.readline();
is($line2b, "Foo Bar Baz\n", '$in.readline() worked');
my $line2c = $in2.readline();
is($line2c, "The End\n", '$in.readline() worked');
ok($in2.close, 'file closed okay');

my $in3 = open($filename);
isa_ok($in3, 'IO');
my $line3a = =$in3;
is($line3a, "Hello World\n", 'unary =$in worked');
my $line3b = =$in3;
is($line3b, "Foo Bar Baz\n", 'unary =$in worked');
my $line3c = =$in3;
is($line3c, "The End\n", 'unary =$in worked');
ok($in3.close, 'file closed okay');

# append to the file

my $append = open(">>$filename");
isa_ok($append, 'IO');
$append.print("... Its not over yet!\n");
ok($append.close, 'file closed okay');

# now read in in list context

my $in4 = open($filename);
isa_ok($in4, 'IO');
my @lines4 = readline($in4);
is(+@lines4, 4, 'we got four lines from the file');
is(@lines4[0], "Hello World\n", 'readline($in) worked in list context');
is(@lines4[1], "Foo Bar Baz\n", 'readline($in) worked in list context');
is(@lines4[2], "The End\n", 'readline($in) worked in list context');
is(@lines4[3], "... Its not over yet!\n", 'readline($in) worked in list context');
ok($in4.close, 'file closed okay');

my $in5 = open($filename);
isa_ok($in5, 'IO');
my @lines5 = $in5.readline();
is(+@lines5, 4, 'we got four lines from the file');
is(@lines5[0], "Hello World\n", '$in.readline() worked in list context');
is(@lines5[1], "Foo Bar Baz\n", '$in.readline() worked in list context');
is(@lines5[2], "The End\n", '$in.readline() worked in list context');
is(@lines5[3], "... Its not over yet!\n", '$in.readline() worked in list context');
ok($in5.close, 'file closed okay');

my $in6 = open($filename);
isa_ok($in6, 'IO');
my @lines6 = =$in6;
is(+@lines6, 4, 'we got four lines from the file');
is(@lines6[0], "Hello World\n", 'unary =$in worked in list context');
is(@lines6[1], "Foo Bar Baz\n", 'unary =$in worked in list context');
is(@lines6[2], "The End\n", 'unary =$in worked in list context');
is(@lines6[3], "... Its not over yet!\n", 'unary =$in worked in list context');
ok($in6.close, 'file closed okay');

# test reading a file into an array and then closing before 
# doing anything with the array (in other words, is pugs too lazy)
my $in7 = open($filename);
isa_ok($in7, 'IO');
my @lines7 = readline($in7);
ok($in7.close, 'file closed okay');
is(+@lines7, 4, 'we got four lines from the file (lazily)');
is(@lines7[0], "Hello World\n", 'readline($in) worked in list context');
is(@lines7[1], "Foo Bar Baz\n", 'readline($in) worked in list context');
is(@lines7[2], "The End\n", 'readline($in) worked in list context');
is(@lines7[3], "... Its not over yet!\n", 'readline($in) worked in list context');

# now be sure to delete the file as well

ok(?unlink($filename), 'file has been removed');
