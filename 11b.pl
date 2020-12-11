#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(min max);

my $input = [ map { [split //, $_] } map { chomp; $_ } <<>> ];
my $rows = @$input;
my $cols = @{ $input->[0] };

my $output = $input;
while (1) {
    my $changed;
    ($output, $changed) = iteration($output, $rows, $cols);
    print "\n";
    print_seat_layout($output);
    print "\n";

    last if not $changed;
}

print count_occupied($output, $rows, $cols), "\n";

sub iteration {
    my ($input, $rows, $cols) = @_;

    my $output = [];
    my $changed = 0;
    for my $i (0 .. $rows-1) {
        for my $j (0 .. $cols-1) {
            if ($input->[$i][$j] eq '.') {
                $output->[$i][$j] = '.';
                next
            }
            my $neighbours_count = count_neighbours($input, $i, $j, $rows, $cols);
            if ($input->[$i][$j] eq 'L') {
                if ($neighbours_count != 0) {
                    $output->[$i][$j] = 'L';
                    next
                }
                $output->[$i][$j] = '#';
                $changed = 1;
                next
            }
            if ($input->[$i][$j] eq '#') {
                if ($neighbours_count < 5) {
                    $output->[$i][$j] = '#';
                    next
                }
                $output->[$i][$j] = 'L';
                $changed = 1;
                next;
            }
            die "Invalid item ($i, $j): $input->[$i][$j]";
        }
    }

    return ($output, $changed);
}

sub print_seat_layout {
    my ($input) = @_;
    for my $i (0 .. $rows-1) {
        for my $j (0 .. $cols-1) {
            print $output->[$i][$j];
        }
        print "\n";
    }
}

sub count_occupied {
    my ($input, $rows, $cols) = @_;
    my $count = 0;
    for my $i (0 .. $rows-1) {
        for my $j (0 .. $cols-1) {
            $count++ if $input->[$i][$j] eq '#'
        }
    }
    return $count;
}

sub count_neighbours {
    my ($input, $i, $j, $rows, $cols) = @_;

    my $left = 0;
    for my $k (reverse(0 .. $i-1)) {
        my $s = $input->[$k][$j];
        last if $s eq 'L';
        $left = 1 if $s eq '#';
    }

    my $right = 0;
    for my $k ($i+1 .. $rows-1) {
        my $s = $input->[$k][$j];
        last if $s eq 'L';
        $right = 1 if $s eq '#';
    }

    my $up = 0;
    for my $l (reverse(0 .. $j-1)) {
        my $s = $input->[$i][$l];
        last if $s eq 'L';
        $up = 1 if $s eq '#';
    }

    my $down = 0;
    for my $l ($j+1 .. $cols-1) {
        my $s = $input->[$i][$l];
        last if $s eq 'L';
        $down = 1 if $s eq '#';
    }

    my $up_left = 0;
    for my $k (1 .. min($i, $j)) {
        my $s = $input->[$i-$k][$j-$k];
        last if $s eq 'L';
        $up_left = 1 if $s eq '#';
    }

    my $up_right = 0;
    for my $k (1 .. min($i, $cols-$j-1)) {
        my $s = $input->[$i-$k][$j+$k];
        last if $s eq 'L';
        $up_right = 1 if $s eq '#';
    }

    my $down_left = 0;
    for my $k (1 .. min($rows-$i-1, $j)) {
        my $s = $input->[$i+$k][$j-$k];
        last if $s eq 'L';
        $down_left = 1 if $s eq '#';
    }

    my $down_right = 0;
    for my $k (1 .. min($rows-$i-1, $cols-$j-1)) {
        my $s = $input->[$i+$k][$j+$k];
        last if $s eq 'L';
        $down_right = 1 if $s eq '#';
    }

    return $up + $down + $left + $right
        + $up_left + $up_right + $down_left + $down_right;
}

