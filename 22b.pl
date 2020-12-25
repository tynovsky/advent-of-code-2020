#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;
use List::Util qw(sum);

$SIG{__WARN__} = sub { die @_ };


# my $p1 = [ qw(9 2 6 3 1) ];
# my $p2 = [ qw(5 8 4 7 10) ];

# my $p1 = [qw( 43 19 )];
# my $p2 = [qw( 2 29 14 )];

my $p1 = [qw(23 32 46 47 27 35 1 16 37 50 15 11 14 31 4 38 21 39 26 22 3 2 8 45 19)];
my $p2 = [qw(13 20 12 28 9 10 30 25 18 36 48 41 29 24 49 33 44 40 6 34 7 43 42 17 5)];

my %CACHE;

sub recursive_combat($p1, $p2, $depth) {
    my @p1 = @$p1;
    my @p2 = @$p2;

    my $key = join(',', @p1) . '-' . join (',', @p2);
    # if (exists $CACHE{$key}) {
    #     # say "cache hit";
    #     return $CACHE{$key} 
    # }

    # say "New game";
    # say((" " x $depth), scalar(@p1), " ", scalar(@p2), " ", "key: $key");
    my $i = 1;
    my %seen;
    while (@p1 > 0 && @p2 > 0) {
        # say "\n", ((" " x $depth), "Round $i");
        # say ((" " x $depth), "Player 1:  ", join ',', @p1);
        # say ((" " x $depth), "Player 2:  ", join ',', @p2);

        my $seen_key = join(',', @p1) . '-' . join (',', @p2);
        if ($seen{$seen_key}) {
            $CACHE{$key} = [1, [@p1], [@p2]];
            return [1, [@p1], [@p2]];
        }
        $seen{$seen_key} = 1;

        my $card1 = shift @p1;
        my $card2 = shift @p2;

        if (@p1 >= $card1 && @p2 >= $card2) {
            # say((" " x $depth), "Play subgame to decide who win");
            my $does_p1_win = recursive_combat([@p1[0 .. $card1-1]], [@p2[0 .. $card2-1]], $depth+1)->[0];
            if ($does_p1_win) {
                # say((" " x $depth), "Player 1 won subgame");
                push @p1, $card1, $card2;
                next
            }
            # say((" " x $depth), "Player 2 won subgame");
            push @p2, $card2, $card1;
            next
        }

        if ($card1 > $card2) {
            # say((" " x $depth), "Player 1 wins round");
            push @p1, $card1, $card2;
            next
        }
        # say((" " x $depth), "Player 2 wins round");
        push @p2, $card2, $card1;
    }

    $CACHE{$key} = [@p1 > 0, [@p1], [@p2]];
    return [@p1 > 0, [@p1], [@p2]];
}

my $result = recursive_combat($p1, $p2, 0);
(my $does_p1_win, $p1, $p2) = @$result;
my $score = 0;
my $i = 1;
for my $card (reverse (@$p1, @$p2)) {
    $score += $card * $i++;
}

say $score;

