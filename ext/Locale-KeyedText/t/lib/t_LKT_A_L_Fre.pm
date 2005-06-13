#!pugs
use v6;

module t_LKT_A_L_Fre;

my Str $xy = 'AF'; # is constant
my Str %text_strings = ( # is constant
	'one' => $xy~' - word {fork} { fork } {spoon} {{fork}}',
	'two' => $xy~' - sky pie rye',
);

sub get_text_by_key( Str $msg_key ) returns Str {
	return %text_strings{$msg_key};
}