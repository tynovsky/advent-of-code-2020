#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;

my $min_depart = <>; chomp $min_depart;
my @intervals = map {chomp; $_} split(/,/, <>);

print Dumper \@intervals;


my $result = shift @intervals;
my $inc = $result;
my $prev = $result;
my $remainder = 0;
for my $i (@intervals) {
    $remainder++;
    say "$remainder: $i";
    next if $i eq 'x';
    $inc = lcm($prev, $inc);
    while ($result % $i != ($i - ($remainder % $i))) {
        $result += $inc;
    }
    $prev = $i;
}

$remainder = -1;
for my $i (@intervals) {
    $remainder++;
    next if $i eq 'x';
    say $remainder;
    say ($remainder % $i);
    say $result % $i;
}

say $result;

sub gcd {
	my ($x, $y) = @_;
	while ($x) { ($x, $y) = ($y % $x, $x) }
	$y
}

sub lcm {
	my ($x, $y) = @_;
	($x && $y) and $x / gcd($x, $y) * $y or 0
}
