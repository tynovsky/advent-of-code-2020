#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures);
no warnings qw(experimental::signatures);
use Data::Dumper;

my $pos = [0, 0];
my $dir = [1, 0];

my %ops = (
    L => \&l,
    R => \&r,
    F => \&f,
    N => \&n,
    S => \&s,
    E => \&e,
    W => \&w,
);

while (my $line = <<>>) {
    chomp $line;
    my ($op, $arg) = $line =~ /(.)(.*)/g;
    ($pos, $dir) = $ops{$op}->($arg, $pos, $dir);
    print Dumper [$pos, $dir];
}

print abs($pos->[0]) + abs($pos->[1]), "\n";

sub l($num, $pos, $dir) {
    my @dirs = ([1,0], [0,1], [-1,0], [0,-1]);
    my %ord_of_dir;
    my $i = 0;
    $ord_of_dir{join(',', @$_)} = $i++ for @dirs;
    print Dumper \%ord_of_dir;
    my $steps = $num / 90;
    my $ord = ($ord_of_dir{join(',', @$dir)} + $steps) % 4;
    return ($pos, $dirs[$ord]);
}
    
sub r($num, $pos, $dir) {
    return l(-$num, $pos, $dir);
}

sub f($num, $pos, $dir) {
    my $new_pos = [$pos->[0] + $num * $dir->[0], $pos->[1] + $num * $dir->[1]];
    return ($new_pos, $dir);
}
    
sub n($num, $pos, $dir) {
    return ([$pos->[0], $pos->[1] + $num], $dir)
}

sub s($num, $pos, $dir) {
    return ([$pos->[0], $pos->[1] - $num], $dir)
}

sub e($num, $pos, $dir) {
    return ([$pos->[0] + $num, $pos->[1]], $dir)
}

sub w($num, $pos, $dir) {
    return ([$pos->[0] - $num, $pos->[1]], $dir)
}
