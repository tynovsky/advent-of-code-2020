#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures);
no warnings qw(experimental::signatures);
use Data::Dumper;

my %ops = (
    L => \&l,
    F => \&f,
    R => sub ($num, $pos, $dir) { l(-$num, $pos, $dir) },
    N => sub ($num, $pos, $dir) { ($pos, [$dir->[0], $dir->[1] + $num]) },
    S => sub ($num, $pos, $dir) { ($pos, [$dir->[0], $dir->[1] - $num]) },
    E => sub ($num, $pos, $dir) { ($pos, [$dir->[0] + $num, $dir->[1]]) },
    W => sub ($num, $pos, $dir) { ($pos, [$dir->[0] - $num, $dir->[1]]) },
);

sub l($num, $pos, $dir) {
    my $steps = ($num / 90) % 4;
    my ($x, $y) = @$dir;
    ($x, $y) = (-$y, $x) for 1 .. $steps;
    return ($pos, [$x, $y]);
}
    
sub f($num, $pos, $dir) {
    return ([$pos->[0] + $num * $dir->[0], $pos->[1] + $num * $dir->[1]], $dir)
}

my $pos = [0, 0];
my $dir = [10, 1];

while (my $line = <<>>) {
    chomp $line;
    my ($op, $arg) = $line =~ /(.)(.*)/g;
    ($pos, $dir) = $ops{$op}->($arg, $pos, $dir);
    print "pos: @$pos, dir @$dir\n";
}

print abs($pos->[0]) + abs($pos->[1]), "\n";
