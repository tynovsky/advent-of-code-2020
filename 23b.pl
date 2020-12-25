#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;

# my @cups_list = split //, '389125467';
my @cups_list = split //, '942387615';
push @cups_list, (10 .. 1_000_000);

my %cups;
my $prev = undef;
for my $c (@cups_list) {
    my $cup = {
        'value' => $c,
    };
    $cups{$c} = $cup;
    $prev->{next} = $cup if $prev;
    $prev = $cup;
}

$cups{$cups_list[-1]}->{next} = $cups{$cups_list[0]};

my $current = $cups{$cups_list[0]};
my @labeling;

for my $round (1 .. 10_000_000) {

    say $round if $round % 1000 == 0;
    # say "current: $current->{value}";
    my $pick_up = $current->{next};
    $current->{next} = $current->{next}{next}{next}{next};

    my $dest = $current->{value};
    while (1) {
        $dest--;
        $dest = scalar(@cups_list) if $dest == 0;
        last if $dest != $pick_up->{value}
             && $dest != $pick_up->{next}{value}
             && $dest != $pick_up->{next}{next}{value}
    }

    # say "dest: $dest";

    my $destination = $cups{$dest};

    $pick_up->{next}{next}{next} = $destination->{next};

    $destination->{next} = $pick_up;
    $current = $current->{next};

    @labeling = ();
    my $c = $cups{1};
    for my $i (1 .. 9) {
        $c = $c->{next};
        # say "$c->{value} -> $c->{next}{value}";
        push @labeling, $c->{value};
    }
    # say @labeling;
}

say((shift @labeling) * (shift @labeling));
