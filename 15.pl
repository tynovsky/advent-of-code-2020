#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;
use List::Util qw(sum);


my $input = <>; chomp $input;
my @start = split /,/, $input;

my $round = 0;
my %seen;
my $last = -1;
for my $n ( @start ) {
    say "$last";
    $seen{$last} = $round++;
    $last = $n;
}

print Dumper \%seen;
say $last;

for my $round (scalar(@start)..30_000_000) {
    say "$round: $last";
    if (not defined $seen{$last}) {
        $seen{$last} = $round;
        $last = 0;
        next;
    }
    my $seen = $seen{$last};
    $seen{$last} = $round;
    $last = $round - $seen;
}
