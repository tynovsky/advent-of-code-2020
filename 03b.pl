#!/usr/bin/env perl

use strict;
use warnings;

my $input;
chomp, push(@$input, [split //, $_]) while (<<>>);

my $columns = scalar(@{$input->[0]});

my @slopes = (
    [1, 1],
    [1, 3],
    [1, 5],
    [1, 7],
    [2, 1],
);

my $result = 1;
for my $s (@slopes) {
    my $t = num_of_trees(@$s);
    print "Slope: @$s, trees: $t\n";
    $result *= $t;
}
print $result;


sub num_of_trees {
    my ($inc_x, $inc_y) = @_;
    my $trees = 0;
    my $i = 0;
    my $j = 0;
    while ($i <= scalar(@$input)-1) {
        $trees++ if $input->[$i][$j] eq '#';
        $i += $inc_x;
        $j = ($j + $inc_y) % $columns;
    }
    return $trees;
}
