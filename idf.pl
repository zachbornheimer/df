#!/usr/bin/perl

# idf.pl
# Install Dot Files
# Will check the first lines of dot files for a version number
#   after the first whitespace character.

use strict;
use warnings;
require File::Copy;

my $target = "$ENV{HOME}/";

my @files = ();
foreach (<.*>) {
    if (!($_ =~ /\.git/) && !($_ =~ /\.swp$/) && ($_ ne '.') && ($_ ne '..')) {
        push @files, $_;
    }
}

chdir($target);

foreach (@files) {
    my $file = $_;
    my $version = `head -n 1 $_`; 
    $version =~ s/^.*?\s+?((\d*\.*)*)$/$1/;
    chomp($version); 
    my $v = `head -n 1 df/$_`;
    $v =~ s/^.*?\s+?((\d*\.*)*)$/$1/;
    chomp($v); 
    $v =~ s/\.//g;
    $version =~ s/\.//g;
    if ($v > $version) {
        use File::Copy;
        move('df/' . $file, $target . $_) or die $!; 
        print "Installed " . $file . "\n";
    } else {
        print "Existing file is newer.\n";
    }
    
}
