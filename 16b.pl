#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;
use List::Util qw(sum all any product);

my %rules;

sub create_rule {
    my ($a, $b, $c, $d) = @_;
    return sub {
        my $x = shift;
        return 1 if $x >= $a && $x <= $b;
        return 1 if $x >= $c && $x <= $d;
        return 0
    }
}

while (<>) {
    last if /^$/;
    my ($name, $a, $b, $c, $d) = $_ =~ /([^:]+): (\d+)-(\d+) or (\d+)-(\d+)/;
    $rules{$name} = create_rule($a, $b, $c, $d);
}

my $heading = <>;
die if $heading !~ /your ticket/;
my $ticket = [map {chomp; $_} split /,/, <>];

<>; $heading = <>;
die if $heading !~ /nearby tickets/;

my @nearby_tickets;
push @nearby_tickets, [map {chomp; $_} split /,/, $_] while <>;

my @valid_tickets = grep {               # valid tickets are those 
    my @ticket_values = @$_; 
    all {                                # whose all values
        my $val = $_; 
        any {$_->($val)} (values %rules) # comply with at least one rule
    } @ticket_values
} @nearby_tickets;

my $ticket_length = scalar(@{ $valid_tickets[0] });
my %matches;
for my $rule (keys %rules) {
    my %match;
    @match{0 .. $ticket_length-1} = (1) x $ticket_length;
    for my $ticket (@valid_tickets) {
        for my $i (0 .. $ticket_length-1) {
            delete $match{$i} if !$rules{$rule}->($ticket->[$i]);
        }
    }
    $matches{$rule} = [ keys %match ];
}

my @keys = sort {@{$matches{$a}} <=> @{$matches{$b}}} keys %matches;

my %index_of;
my %taken;
for my $key (@keys) {
    for my $i (@{$matches{$key}}) {
        if (not $taken{$i}) {
            $index_of{$key} = $i;
            $taken{$i} = 1;
            last
        }
    }
}

my @departure_keys = grep { /^departure/ } keys %matches;
my @indices = @index_of{@departure_keys};

my $result = product @{$ticket}[@indices];
say $result;
