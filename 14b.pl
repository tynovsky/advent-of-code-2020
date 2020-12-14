#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;
use List::Util qw(sum);

my %values;
my ($ones, $xs);
while (my $line = <>) {
    if ($line =~ /mask/) {
        chomp $line;
        ($ones, $xs) = load_mask($line);
        # print Dumper $ones;
        # print Dumper $xs;
        next;
    }
    my ($index, $value) = $line =~ /mem\[(\d+)\] = (\d+)/;
    my $b = dec2bin($index);
    for my $one (@$ones) {
        $b->[$one] = 1
    }
    my @indices = ($b);
    for my $x (@$xs) {
        # say "x=$x, indices: ";
        my @new_indices;
        for my $i (@indices) {
            my @zero = @$i;
            my @one = @$i;
            $zero[$x] = 0;
            $one[$x] = 1;
            push @new_indices, \@zero;
            push @new_indices, \@one;
        }
        @indices = @new_indices;
        # say join("\n", (map { join'', @$_} @indices));
    }

    for my $i (@indices) {
        $values{bin2dec($i)} = $value
    }
}

say sum(values %values);

sub load_mask($line) {
    $line =~ s/mask = //;
    my @ones;
    my @xs;
    my $i = 0;
    for my $bit (reverse split //, $line) {
        if ($bit eq 'X') {
            push @xs, $i++;
            next
        }
        push @ones, $i if $bit == 1;
        $i++
    }
    return \@ones, \@xs;

}

sub dec2bin($dec) {
    my @bin;
    while ($dec > 0) {
        push @bin, ($dec % 2);
        $dec = int($dec / 2);
    }
    return \@bin
}

sub bin2dec($bin) {
    my @bin = @$bin;
    my $dec = 0;
    for my $i (0 .. $#bin) {
        $dec += 2**$i * ($bin[$i] // 0)
    }
    return $dec
}
