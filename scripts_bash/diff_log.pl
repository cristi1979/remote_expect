#!/usr/bin/perl

if ( $#ARGV != 2 ) {
    die "We need previous_file current_file result_file.\n";
}

use warnings;
use strict;
use File::Copy;

my $prev = shift;
my $crt = shift;
my $res = shift;
my $done_file = "";
my $delim = '++++++++++++++++++++++++';
$delim = quotemeta $delim;

sub read_block {
    my ($fh, $file) = @_;
    my $block = "";
    while ( my $line = <$fh> ) {
	if ($line !~ /^$delim.*/) {
	    $block .= $line;
	} else {
	    $block .= $line;
	    last;
	}
    }
    if ( eof $fh ) { $done_file = "$file"; print "reached EOF for $done_file. block is $block.\n"; } else {
	$block .= <$fh>;
    }
print $block;
    return $block;
}

sub write_res {
    my $fh = shift;
    while ( my $line = <$fh> ) {
	print RES $line;
    }
}

my $no_prev = 0;
open (PREV,$prev) or $no_prev=1;
if ($no_prev == 1) {
    copy($crt, $res); 
    print "No previous file.\n";
    exit 0;
}
open (CRT,$crt) or die "Cannot read file $crt; $!\n";
open (RES,">$res") or die "Cannot write file $res; $!\n";

print "Get first block from current.\n";
my $block_crt = read_block (\*CRT, "crt");
print "Get first block from previous.\n";
my $block_prev = read_block (\*PREV, "prev");

while ($block_crt ne $block_prev && $done_file eq "" ) {
    $block_prev = read_block (\*PREV, "prev");
}

while ($block_crt eq $block_prev && $done_file eq "") {
    $block_prev = read_block (\*PREV, "prev");
    $block_crt = read_block (\*CRT, "crt");
}

if ( $done_file eq "prev" ) { print RES $block_crt;}
write_res \*CRT;

close RES;
close CRT;
close PREV;
