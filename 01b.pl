#!/usr/bin/env perl

use strict;
use warnings;

my @input;
push @input, $_ while (<<>>);

for my $i (@input) {
    for my $j (@input) {
        for my $k (@input) {
            print $i * $j * $k, "\n" if $i + $j + $k == 2020
        }
    }
}
