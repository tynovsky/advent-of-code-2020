#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my @input = sort {$a <=> $b} map { chomp; $_ } <<>>;

my %dist;
my $prev = 0;
for my $n (@input) {
    # print "$n\n";
    # print $n - $prev, "\n";
    $dist{$n - $prev}++;
    $prev = $n;
}

$dist{3}++;

print $dist{1} * $dist{3};
