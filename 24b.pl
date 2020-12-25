#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;
use List::Util qw(sum);


my %tiles;
while (my $line = <>) {
    my %counts;

    for my $dir (qw(se sw ne nw e w)) {
        $counts{$dir} = () = $line =~ /$dir/g;
        $line =~ s/$dir//g;
    }

    my $x = 2 * $counts{e} + sum(@counts{qw(ne se)})
          - 2 * $counts{w} - sum(@counts{qw(nw sw)});
    my $y = sum(@counts{qw(ne nw)}) - sum(@counts{qw(se sw)});
    
    $tiles{"$x:$y"} = ! $tiles{"$x:$y"};
}

for my $k (keys %tiles) {
    delete $tiles{$k} if ! $tiles{$k};
}

my %next_day;
for my $i (0 .. 100) {
    say "Day $i: " . scalar(keys %tiles);
    for my $k (keys %tiles) {
        for my $coords ($k, neighbour_coords($k)) {
            my $a = count_adjacent($coords, \%tiles);
            $next_day{$coords} = 1 if $tiles{$coords} && $a > 0 && $a <= 2;
            $next_day{$coords} = 1 if !$tiles{$coords} && $a == 2;
        }
    }
    %tiles = %next_day;
    %next_day = ();
}

sub count_adjacent($coords, $tiles) {
    my $sum = 0;
    for my $n (neighbour_coords($coords)) {
        $sum += $tiles->{$n} // 0;
    }
    return $sum;
}

sub neighbour_coords($coords) {
    my ($x, $y) = split /:/, $coords;
    return (
        ($x-2) . ':' . ($y),
        ($x+2) . ':' . ($y),
        ($x-1) . ':' . ($y-1),
        ($x-1) . ':' . ($y+1),
        ($x+1) . ':' . ($y-1),
        ($x+1) . ':' . ($y+1),
    )
}
