#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;
use List::Util qw(sum);


# my @cups = split //, '389125467';
my @cups = split //, '942387615';

for my $round (1 .. 100) {
    say join ' ', @cups;
    my $current = shift @cups;
    say "current $current";
    my @pick_up = (shift @cups, shift @cups, shift @cups);
    say "pick up ", join ' ', @pick_up;
    my $destination = get_destination($current, @cups);
    push @cups, $current;
    say "destination $destination";
    while (my $cup = shift @cups) {
        push @cups, $cup;
        last if $cup == $destination;
    }
    push @cups, @pick_up;
    while (my $cup = shift @cups) {
        push @cups, $cup;
        last if $cup == $current
    }
    say join ' ', @cups;
}

while (my $cup = shift @cups) {
    last if $cup == 1;
    push @cups, $cup;
}

say @cups;


sub get_destination($current, @cups) {
    while (1) {
        $current--;
        $current = 9 if $current == 0;
        return $current if grep {$_ == $current} @cups
    }
}
