#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my $size = 25;
my @context;

for (0..$size-1) {
    my $n = <<>>;
    chomp $n;
    push @context, $n
}

while (my $n = <<>>) {
    if (!check_number($n, \@context)) {
        print "$n\n";
        last
    }
    shift @context;
    push @context, $n;
}

sub check_number {
    my ($n, $context) = @_;

    for my $i (@$context) {
        for my $j (@$context) {
            return 1 if $i + $j == $n
        }
    }
    return 0
}
