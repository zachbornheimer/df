#!/usr/bin/perl

# Copyright (C) 2013 Zachary Bornheimer
#
# idf.pl
# Install Dot Files
# Will check the first lines of dot files for a version number
#   after the first whitespace character.

use strict;
use warnings;
require integer;
use Cwd qw(abs_path); # for $pwd

=pod

=head1 NAME

idf.pl (Install Dot Files)
by Z. Bornheimer

=head1 PERL MODULES

idf.pl requires "integer" and "File::Copy"

=head1 SOFTWARE REQUIREMENTS

idf.pl requires perl (obviously) and git.

=head1 USAGE

perl idf.pl
(This method installs files)

===========

perl idf.pl store <file relative to ~/>
(This method stores files and commits them to the git repo).

=cut

# $home = user's home dir
# $pwd = scripts directory (directory of all the dot files)
my $home = `sh -c "echo ~\$(whoami)"`;
my $pwd = abs_path(__FILE__);
$pwd =~ s|(.*)/.*|$1|;
chomp($home);
chomp($pwd);

my %target;
$target{'.lua'} = $home . '/.config/awesome/';
$target{'.vim'} = $home . '/.vim/colors/';
$target{'.vimplugin'} = $home . '/.vim/plugins/';
$target{'.zsh_conf'} = $home . '/.zkbd/';

my @vimFiles = qw/ Tomorrow-Night.vim Tomorrow-Night-Bright.vim /;
my @vimPlugins = qw/ ctrlp surround fugitive speeddating toggle-bool sideways vim-schlepp/;

foreach (@vimFiles) {
    $target{$_} = $home . '/.vim/colors/';
}

foreach (@vimPlugins) {
    install_latest_vim_plugin($_);
}

foreach (keys %target) {
    system("mkdir -p " . $target{$_});
}

if ($#ARGV > 0) {
    if ($ARGV[0] eq "store") {
        shift(@ARGV);
        foreach (@ARGV) {
            my $file = $_;
            print "~/$file";
            system("cp ~/$file ~/df");
            $file =~ s/.*\///;
            open(F, $file);
            my @removeVersionNumber = ();           
            my $i = 0;
            while(<F>) {
                chomp($_);
                if ($i == 0) {
                    if (!($_ =~ /^(--|") \d+\.\d+\.\d+/)) {
                        push (@removeVersionNumber, $_);
                    }
                }
            }
            close (F);
            open (F, ">" . $file);
            print F join("\n", @removeVersionNumber);
            close(F);
            system("git commit $file");
        }
    }
    exit;
}

{ # reset git and pull the latest.
    system("git reset --hard");
    system("git pull origin master");
}


my $target = "$home/";

my @files = ();
foreach (<.*>) {
    if (!($_ =~ /\.git/) && !($_ =~ /\.swp$/) && ($_ ne '.') && ($_ ne '..') && ($_ ne '.DS_Store')) {
        push @files, $_;
    }
}
foreach (<*>) {
    if (!($_ =~ /\.pl$/)) {
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
$commentSymbols{'vimrc'} = '"';
$commentSymbols{'vim'} = '"';
$commentSymbols{'vimplugin'} = '"';
$commentSymbols{'def'} = '#';
$commentSymbols{'lua'} = '--';

foreach (@files) {
    my $file = $_;
    my $fileNoDot = $file;
    $fileNoDot =~ /\.(.*)$/;
    $fileNoDot = $1;

    my $comment;
    if ($commentSymbols{$fileNoDot}) {
        $comment = $commentSymbols{$fileNoDot} . " ";
    } else {
        $comment = $commentSymbols{def} . " ";
    }
    my $version;
    my $filepath = $pwd . "/" . $_;
    if (-e $_) {
        $version = `head -n 1 $filepath`; 
        $version =~ s/^.*?\s+?((\d*\.*)*)$/$1/;
        chomp($version);
    } else {
        $version = "0.0.0";
    }
    my $v = `head -n 1 $filepath`;
    $v =~ s/^.*?\s+?((\d*\.*)*)$/$1/;
    if ($v eq "") {
        open (F, "$pwd/$file"); 
        my @f = <F>;
        close (F);
        open (F, ">$pwd/$file");
        print F $comment . $gitV . "\n";
        print F join("", @f);
        close(F);
        $v = `head -n 1 $pwd/$file`; 
        $v =~ s/^.*?\s+?((\d*\.*)*)$/$1/;
        chomp($v); 
    }
    my @varray = split /\./, $v;
    my @versionarray = split /\./, $version;
    for (0..2) {
        my $i = 0;
        if (!$versionarray[$_] || $versionarray[$_] == "" || $varray[$_] > $versionarray[$_]) {
        $file =~ m/(\..+)$/;
        my $ext = $1;
            if (!$target{$ext} || $target{$ext} eq ".") {
                $target{$ext} = $home.'/';
            }
            system("mv $pwd/$file $target{$ext}$file"); 
            print "Installed " . $file . "\n";
            $i = 1;
            last;
        }
        if (($_ == 2) && (!$i)) {
            print "The existing '$file' is not a candidate for replacement.\n"
        }
    }
}

sub install_latest_vim_plugin {
    my $plugin = shift;
    my %programs;
    @{$programs{'ctrlp'}} = ('https://github.com/ctrlpvim/ctrlp.vim.git', 'ctrlp.vim');
    @{$programs{'surround'}} = ('https://github.com/tpope/vim-surround.git', 'surround.vim');
    @{$programs{'fugitive'}} = ('https://github.com/tpope/vim-fugitive', 'fugative.vim');
    @{$programs{'speeddating'}} = ('https://github.com/tpope/vim-speeddating', 'speeddating.vim');
    @{$programs{'sideways'}} = ('https://github.com/AndrewRadev/sideways.vim', 'sideways');
    @{$programs{'toggle-bool'}} = ('https://github.com/zysys/toggle-bool', 'toggle-bool');
    @{$programs{'vim-schlepp'}} = ('https://github.com/zirrostig/vim-schlepp', 'vim-schlepp');

    if ($programs{$plugin} > 0) {
        if (-d "$ENV{HOME}/.vim/bundle/$programs{$plugin}[1]") {
            print "Updating vim plugin $plugin using git repo\n";
            system("git -C ~/.vim/bundle/$programs{$plugin}[1] pull");
        } else {
            print "Installing vim plugin $plugin\n";
            system("git clone $programs{$plugin}[0] ~/.vim/bundle/$programs{$plugin}[1]");
        }
    } else {
        print "Plugin $plugin not identified\n";
    }
}
