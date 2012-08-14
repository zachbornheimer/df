#!/usr/bin/perl

# idf.pl
# Install Dot Files
# Will check the first lines of dot files for a version number
#   after the first whitespace character.

use strict;
use warnings;
require File::Copy;


if ($#ARGV > 0) {
    if ($ARGV[0] eq "store") {
        shift(@ARGV);
        foreach (@ARGV) {
            my $file = $_;
            print "~/$file";
            system("cp ~/$file ~/df");
            open(F, $file);
my @removeVersionNumber = ();           
            my $i = 0;
            while(<F>) {
                chomp($_);
                if ($i == 0) {
                    if (!($_ =~ /^" \d+\.\d+\.\d+/)) {
                        push (@removeVersionNumber, $_);
                    }
                }
            }
            close (F);
            open (F, ">" . $file);
            print F join("\n", @removeVersionNumber);
            close(F);
            system("git add .; git commit -a");
        }
    } else {
        print @ARGV. "akldfj";
    }
    exit;
}
{ # reset git and pull the latest.
    system("git reset --hard");
    system("git pull");
}


my $target = "$ENV{HOME}/";

my @files = ();
foreach (<.*>) {
    if (!($_ =~ /\.git/) && !($_ =~ /\.swp$/) && ($_ ne '.') && ($_ ne '..')) {
        push @files, $_;
    }
}

my $log = `git log`;
my @log = split /\n/, $log;
my $gitV = 0;
foreach (@log) {
    if ($_ =~ /^commit\s+/) {
        $gitV++;
    }
}
{
    use integer;
    my $d1 = 0;
    my $d2 = 0;
    my $d3 = $gitV;
    $d1 = $gitV / 100;
    $gitV -= $d1 * 100;
    $d2 = $gitV / 10;
    $gitV -= $d2 * 10;
    $gitV = $d1 . "." . $d2 . "." . $gitV;
}

chdir($target);

my %commentSymbols = ();
$commentSymbols{vimrc} = '"';
$commentSymbols{def} = '#';

foreach (@files) {
    my $file = $_;
    my $fileNoDot = $file;
    $fileNoDot =~ s/^.//;
    my $comment;
    if ($commentSymbols{$fileNoDot}) {
        $comment = $commentSymbols{$fileNoDot} . " ";
    } else {
        $comment = $commentSymbols{def} . " ";
    }
    my $version;
    if (-e $_) {
        $version = `head -n 1 $_`; 
        $version =~ s/^.*?\s+?((\d*\.*)*)$/$1/;
        chomp($version);
    } else {
        $version = "0.0.0";
    }
    my $v = `head -n 1 df/$_`;
    $v =~ s/^.*?\s+?((\d*\.*)*)$/$1/;
    chomp($v); 
    if ($v eq "") {
        open (F, "df/".$file); 
        my @f = <F>;
        close (F);
        open (F, ">df/".$file);
        print F $comment . $gitV . "\n";
        print F join("", @f);
        close(F);
        $v = `head -n 1 df/$file`; 
        $v =~ s/^.*?\s+?((\d*\.*)*)$/$1/;
        chomp($v); 
    }
    my @varray = split /\./, $v;
    my @versionarray = split /\./, $version;
    for (0..2) {
        my $i = 0;
        if (!$versionarray[$_] || $versionarray[$_] == "" || $varray[$_] > $versionarray[$_]) {
            use File::Copy;
            move('df/' . $file, $target . $file) or die $!; 
            print "Installed " . $file . "\n";
            $i = 1;
            last;
        }
        if (($_ == 2) && (!$i)) {
            print "The existing '$file' is not a candidate for replacement.\n"
        }
    }
}
