use v6-alpha;

use Test;

=pod

Test that the C<--help> command in its various incantations
works.

=cut

my @examples = any <-h --help>;
@examples = map -> Junction $_ { $_.values }, 
            map -> Junction $_ { $_, "-w $_", "$_ -w", "-w $_ -w" },
            @examples;

plan +@examples;
if $*OS eq "browser" {
  skip_rest "Programs running in browsers don't have access to regular IO.";
  exit;
}

diag "Running under $*OS";

my ($pugs,$redir) = ("./pugs", ">");

if $*OS eq any <MSWin32 mingw msys cygwin> {
  $pugs = 'pugs.exe';
  $redir = '>';
};

sub nonce () { return (".$*PID." ~ int rand 1000) }

for @examples -> $ex {
  my $out_fn = "temp-ex-output" ~ nonce;
  my $command = "$pugs $ex $redir $out_fn";
  diag $command;
  system $command;

  my $got      = slurp $out_fn;
  unlink $out_fn;

  like( $got, rx:perl5/^Usage/, "'$ex' displays help");
}
