#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;

my $min_depart = <>; chomp $min_depart;
my @intervals = map {chomp; $_} split(/,/, <>);

say $min_depart;
print Dumper \@intervals;

my $min_wait = "inf";
my $result;
for my $i (@intervals) {
    next if $i eq 'x';
    my $wait = $i - ($min_depart % $i);
    if ($wait < $min_wait) {
        $min_wait = $wait;
        $result = $i * $wait;
    }
}

say $result;
