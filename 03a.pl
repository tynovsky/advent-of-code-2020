#!/usr/bin/env perl

use strict;
use warnings;

my $input;
chomp, push(@$input, [split //, $_]) while (<<>>);

my $columns = scalar(@{$input->[0]});

my $trees = 0;
my $j = 0;
for my $i (1 .. scalar(@$input)-1) {
    $j = ($j + 3) % $columns;
    $trees++ if $input->[$i][$j] eq '#';
}

print "$trees\n";
