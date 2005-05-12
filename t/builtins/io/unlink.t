#!/usr/bin/pugs

use v6;
use Test;

plan 6;

sub nonces() { ".$*PID." ~ int rand 1000 }

my $fn = "unlink-test-file" ~ nonces;

my $iswin32 = ?($*OS eq any<MSWin32 mingw msys cygwin>) ?? "Timely closing of file handles does not yet work" :: undef;

# open, explicit close, unlink, test
{
  my $fh = open "> $fn";
  close $fh;

  ok -e $fn,      "open() created a tempfile";
  is(unlink($fn), 1, "unlink() returned true");
  ok !-e $fn,     "unlink() actually deleted the tempfile";
}

# open, implicit close because of scope exit, unlink, test
{
  { my $fh = open "> $fn" }

  ok -e $fn,      "open() created a tempfile";
  is(unlink($fn), 1, "unlink() returned true", todo => $iswin32);
  ok !-e $fn,     "unlink() actually deleted the tempfile", todo => $iswin32;
}