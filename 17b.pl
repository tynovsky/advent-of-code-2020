#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;
use List::Util qw(sum);

my $active;
my $z = 0;
my $w = 0;
my $x = 0;
while (<>) {
    chomp;
    my @row = split //;
    my $y = 0;
    for my $c (@row) {
        $active->{"$x:$y:$z:$w"} = 1 if $c eq '#';
        $y++;
    }
    $x++
}

for my $i (1..6) {
    $active = iteration($active);
    say join(' ', keys %$active);
}

say scalar(keys %$active);

sub count_neighbors($active) {
    my %neighbors;
    for my $a (keys %$active) {
        my ($x, $y, $z, $w) = split /:/, $a;
        for my $i ($x-1 .. $x+1) {
            for my $j ($y-1 .. $y+1) {
                for my $k ($z-1 .. $z+1) {
                    for my $l ($w-1 .. $w+1) {
                        next if $i == $x && $j == $y && $k == $z && $l == $w;
                        $neighbors{"$i:$j:$k:$l"}++
                    }
                }
            }
        }
    }
    return \%neighbors
}

sub iteration($prev_active) {
    my %active;
    my $neighbors = count_neighbors($active);
    for my $cube (keys %$neighbors) {
        $active{$cube} = 1 if $neighbors->{$cube} == 3;
        $active{$cube} = 1 if $neighbors->{$cube} == 2 && $prev_active->{$cube};
    }
    return \%active;
}
