use v6-alpha;

use HTTP::Message;

class HTTP::Request-0.1[?::URI_CLASS = URI] {
    is HTTP::Message;
    
    has $.method    is rw;
    has $!uri       is rw;
    
    submethod BUILD (Str $.method, $.uri) { }
    
    method parse (Str $str is copy) {
        my $request_line;
        
        if ($str ~~ s/^(.*)\n//) {
            $request_line = $0;
        } else {
            $request_line = $str;
            $str = "";
        }
        
        my $self = self.SUPER::parse($str);
        
        given ($self) {
            my ($method, $uri, $protocol) = $request_line.split(' ');
            .method($method) if $method.defined;
            .uri($uri) if $method.defined;
            .protocol($protocol) if $protocol.defined;
        }
        
        $self;
    }
    
    multi method uri (Str $new) is rw {
        my $old = $!uri;
    
        return Proxy.new(
            FETCH => { $old; },
            STORE => { $!uri = $HTTP::URI_CLASS.new($^new); $old; }
        );
    }
    
    multi method uri (URI $new) is rw {
        my $old = $!uri;
    
        return Proxy.new(
            FETCH => { $old; },
            STORE => { $!uri = $^new; $old; }
        );;
    }
    
    multi method uri () {
        $!uri;
    }
    
    our &url ::= &uri;
    
    method as_string (Str $newline = "\n") {
        my $req_line = $.method // "-";
        my $uri = ($.uri().defined) ?? $.uri().as_string() !! "-";
        
        $req_line ~= $uri;
        
        my $proto = $.protocol;
        
        $req_line ~= $protocol if $proto.defined;
        
        return ($req_line, self.SUPER::as_string($newline)).join($newline);
    }
}
