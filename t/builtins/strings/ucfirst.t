use v6-alpha;

use Test;

plan 4;

# L<S29/"Str" /ucfirst/>

is ucfirst("hello world"), "Hello world", "simple";
is ucfirst(""),            "",            "empty string";
is ucfirst("üüüü"),        "Üüüü",        "umlaut";
is ucfirst("óóóó"),        "Óóóó",        "accented chars";
