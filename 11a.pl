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
                if ($neighbours_count < 4) {
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

    my $count = 0;
    for my $k (max($i-1, 0) .. min($i+1, $rows-1)) {
        for my $l (max($j-1, 0) .. min($j+1, $cols-1)) {
            next if $k == $i && $l == $j;
            $count++ if $input->[$k][$l] eq '#';
        }
    }
    return $count
}

