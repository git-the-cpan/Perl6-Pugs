use strict;
use lib "../../", "../../inc";
use inc::Module::Install prefix => '../../inc';

name       ('CGI');
version    ('0.01');
abstract   ('CGI for Pugs');
author     ('Stevan Little <stevan@iinteractive.com>');
license    ('perl');

WritePugs  (6);
