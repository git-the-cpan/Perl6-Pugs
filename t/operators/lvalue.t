use v6-alpha;

use Test;

plan 4;

{
    my $x = 15;
    my $y = 1;
    ($x = $y) = 5;
    is $x, 5, 'order of assignment respected (1)';
    is $y, 1, 'order of assignment respected (2)';
    $x = $y = 7;
    is $y, 7, 'assignment is right-associative';
}

# From p5 "perldoc perlop"
{
    my $x = 1;
    ($x += 2) *= 3;
    is $x, 9, 'lvalue expressions are only evaluated once';
}

