#!/usr/bin/env perl

use strict;
use warnings;

my @input;
push @input, $_ while (<<>>);

for my $i (@input) {
    for my $j (@input) {
        print $i * $j, "\n" if $i + $j == 2020
    }
}
