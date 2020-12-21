#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;
use List::Util qw(sum any all min);
use lib qw(.);
use Tile;

my $current_tile;
my $tiles = {};
my @lines;

while (my $line = <>) {
    if ($line =~ /Tile (\d+):/) {
        $current_tile = $1;
        @lines = ();
        next
    }
    if ($line =~ /^$/) {
        $tiles->{$current_tile} = Tile->new(raw => [@lines], id => $current_tile);
    };

    chomp $line;
    push @lines, $line;
}
$tiles->{$current_tile} = Tile->new(raw => [@lines], id => $current_tile);
# map {print Dumper $tiles->{$_}->edges} sort keys %$tiles;

my $size = sqrt(scalar(keys %$tiles));
my $grid = [];
my $remaining = { %$tiles };

my $solution = place_next($grid, $size, $remaining);
# print Dumper $solution;
for my $i (0 .. scalar(@$solution) - 1) {
    if ($i % $size == 0) {
        say "" unless $i == 0;
    }
    else {
        print "\t"
    }
    print $solution->[$i]->{tile}->id . "-" . $solution->[$i]->{orientation};
}
say "";


sub place_next($grid, $size, $remaining) {
    # say "grid:   ", join ',', (map {$_->{tile}->id} @$grid);
    # say "remain: ", join ',', (sort keys %$remaining);
    # say scalar(@$grid);
    if (keys %$remaining == 0) {
        return $grid
    }

    if (!enough_matching_edges($size, $remaining)) {
        # say "not enough matching edges";
        # say "remain: ", join ',', (sort keys %$remaining);
        return
    }

    my @candidates = sort keys %$remaining;
    
    if (scalar(@$grid) % $size != 0) {
        @candidates = grep {
            $remaining->{$_}->contains_edge->{edge_from_grid($grid, -1, 'right')}
        } @candidates;
    }
    if (int(scalar(@$grid) / $size) != 0) {
        @candidates = grep {
            $remaining->{$_}->contains_edge->{
                edge_from_grid($grid, scalar(@$grid) - $size, 'bottom')
            }
        } @candidates;
    }

    for my $key (@candidates) {
        my $tile = delete $remaining->{$key};
        for my $i (0 .. 15) {
            next if !fit($grid, $size, $tile->orientations->[$i]);
            my $solution = place_next(
                [@$grid, {tile=>$tile, orientation=>$i}], $size, $remaining
            );

            next if !$solution;
            return $solution
        }
        $remaining->{$key} = $tile;
    }
    # say "failed path";
    return;
}

sub edge_from_grid($grid, $i, $which) {
    my $tile = $grid->[$i]->{tile};
    my $orientation = $grid->[$i]->{orientation};
    my $edge_index = {
        top    => 0,
        right  => 1,
        bottom => 2,
        left   => 3,
    }->{$which};
    return $tile->orientations->[$orientation]->[$edge_index];
}

sub fit($grid, $size, $edges) {
    my $filled = scalar(@$grid);
    if ($filled % $size == 0 && int($filled / $size) == 0) {
        # say "whatever can be first";
        return 1;
    }
    if ($filled % $size == 0) {
        # say "only check above";
        return reverse($edges->[0]) eq edge_from_grid($grid, $filled - $size, 'bottom')
    }
    if (int($filled / $size) == 0) {
        # say "only check left";
        return reverse($edges->[3]) eq edge_from_grid($grid, $filled - 1, 'right')
    }

    # say "check above and left";
    return 0 if reverse($edges->[0]) ne edge_from_grid($grid, $filled - $size, 'bottom');
    return 0 if reverse($edges->[3]) ne edge_from_grid($grid, $filled - 1, 'right');
    return 1
}

sub enough_matching_edges($size, $remaining) {
    my %edges;
    my @keys = sort keys %$remaining;
    for my $k (@keys) {
        for my $e (@{$remaining->{$k}->edges}) {
            $edges{(sort ($e, scalar(reverse($e))))[0]}++
        }
    }
    my @matching = grep { $edges{$_} >= 2 } keys %edges;

    my $used = $size * $size - scalar(@keys);
    my $required_number = 2 * $size *($size-1) - 2 * $used + int($used / $size);

    return scalar(@matching) >= $required_number
}

