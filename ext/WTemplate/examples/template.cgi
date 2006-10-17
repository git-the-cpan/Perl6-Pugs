use v6-alpha;
use CGI-0.1; 
my $q = CGI.new;
$q.set_url_encoding('utf-8');
use WTemplate;

my %variables;
%variables{'title'} = "WTemplate example";
%variables{'familyname'} = "Barthazi";
%variables{'firstname'} = "Andras";
%variables{'todo'} = [ { item => 'clean up the code' },
                       { item => 'extend the functionality of the widgets' }
                     ];

$q.header(charset=>'utf-8').print;

(slurp 'example.tpl').fill_with(%variables).say;
