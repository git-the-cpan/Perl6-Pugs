use Test::More 'no_plan';
use strict;

BEGIN { chdir 't' if -d 't' };
BEGIN { use lib qw[../lib inc] };

my $Class = 'JIB::Utils';

use_ok( $Class );
    
# Local variables:
# c-indentation-style: bsd
# c-basic-offset: 4
# indent-tabs-mode: nil
# End:
# vim: expandtab shiftwidth=4:
