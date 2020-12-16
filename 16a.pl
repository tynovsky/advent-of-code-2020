#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;
use List::Util qw(sum);

my @rules;

while (<>) {
    last if /^$/;
    push @rules, [ /(\d+)/g ];
}

my $heading = <>;
die if $heading !~ /your ticket/;
my $ticket = [map {chomp; $_} split /,/, <>];

<>; $heading = <>;
die if $heading !~ /nearby tickets/;

my @nearby;
push @nearby, [map {chomp; $_} split /,/, $_] while <>;

my $total = 0;
for my $n (@nearby) {
    for my $value (@$n) {
        $total += $value if !check($value);
    }
}
say $total;

sub check {
    my $value = shift;
    my $match = 0;
    for my $rule (@rules) {
        $match++ if $rule->[0] <= $value && $rule->[1] >= $value;
        $match++ if $rule->[2] <= $value && $rule->[3] >= $value;
    }
    return $match > 0;
}

