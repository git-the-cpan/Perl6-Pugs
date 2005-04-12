#!/usr/bin/pugs

use v6;
require Test;

plan(23);

# Simple - with just a single char

is(rindex("Hello World", "H"), 0, "One char, at beginning");
is(rindex("Hello World", "l"), 9, "One char, in the middle");
is(rindex("Hello World", "d"), 10, "One char, in the end");
is(rindex("Hello World", "x"), -1, "One char, no match");

is(rindex("Hello World", "l", 10), 9, "One char, first match, pos @ end");
is(rindex("Hello World", "l", 9), 9, "- 1. match again, pos @ match");
is(rindex("Hello World", "l", 8), 3, "- 2. match");
is(rindex("Hello World", "l", 2), 2, "- 3. match");
is(rindex("Hello World", "l", 1), -1, "- no more matches");

# Simple - with a string

is(rindex("Hello World", "Hello"), 0, "Substr, at beginning");
is(rindex("Hello World", "o W"), 4, "Substr, in the middle");
is(rindex("Hello World", "World"), 6, "Substr, at the end");
is(rindex("Hello World", "low"), -1, "Substr, no match");
is(rindex("Hello World", "Hello World"), 0, "Substr eq Str");

# Empty strings

is(rindex("Hello World", ""), 11, "Substr is empty");
is(rindex("", ""), 0, "Both strings are empty");
is(rindex("", "Hello"), -1, "Only main-string is empty");
is(rindex("Hello", "", 3), 3, "Substr is empty, pos within str");
is(rindex("Hello", "", 5), 5, "Substr is empty, pos at end of str");
is(rindex("Hello", "", 999), 5, "Substr is empty, pos > length of str");

# More difficult strings

is(rindex("abcdabcab", "abcd"), 0, "Start-of-substr matches several times");  

is(rindex("uuúuúuùù", "úuù"), 4, "Accented chars");
is(rindex("Ümlaut", "Ü"), 0, "Umlaut");
