#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;
use List::Util qw(sum);


# my @p1 = (qw(9 2 6 3 1));
# my @p2 = (qw(5 8 4 7 10));

my @p1 = (qw(23 32 46 47 27 35 1 16 37 50 15 11 14 31 4 38 21 39 26 22 3 2 8 45 19));

my @p2 = (qw(13 20 12 28 9 10 30 25 18 36 48 41 29 24 49 33 44 40 6 34 7 43 42 17 5));

my $i = 1;
while (@p1 > 0 && @p2 > 0) {
    say "Round ", $i++;
    my $card1 = shift @p1;
    my $card2 = shift @p2;
    if ($card1 > $card2) {
        push @p1, $card1, $card2;
    }
    elsif ($card2 > $card1) {
        push @p2, $card2, $card1;
    }
    else {
        die "$card1 == $card2";
    }
}

say (@p1, @p2);

my $score = 0;
$i = 1;
for my $card (reverse (@p1, @p2)) {
    $score += $card * $i++;
}

say $score;

