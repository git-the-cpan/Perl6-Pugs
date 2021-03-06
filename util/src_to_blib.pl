#!/usr/bin/perl
#
# Copy all of the source, header, object and intermediate files in `src`
# to the blib6 archlib, so that it will all get installed. This is
# needed to be able to build Haskell based Perl6 extensions outside of
# the pugs tree.
#
use Config;
use File::Copy qw(copy);
use File::Path qw(mkpath);

my @pmc_files;

{
#   copy_all('src', 'blib6/arch/CORE/pugs');
    copy_all("$_/blib/", 'blib6/pugs/perl5') for <perl5/*>;
    copy_all("$_/blib6/", 'blib6/pugs/perl6') for <perl5/*>;
    copy_all("$_/blibjs/", 'blib6/pugs/js') for <perl5/*>;
}
sleep 1;
utime undef, undef, @pmc_files;

print "*** Successfully built!  Type '$Config{make} install' to install.\n";

# make an educated guess of whether we'll need root permission.
print "    (You may need to do that as the 'root' user.)\n"
    unless -w $Config{sitelib};

sub copy_all {
    my ($src, $dest) = @_;
    mkpath($dest);
    local *DIR;
    opendir(DIR, $src) or warn "opendir failed for $src: $!", return;
    my @nodes = readdir(DIR);
    foreach my $node (sort @nodes) {
        next if $node =~ /^(\.|\.\.|\.svn|t)$/;
        my $src_path = "$src/$node";
        my $dest_path = "$dest/$node";
        if (-f $src_path) {
            copy($src_path, $dest_path);
        }
        if (-d $src_path) {
            copy_all($src_path, $dest_path);
        }
	push @pmc_files, $dest_path if $node =~ m/\.pmc$/;
    }
}
