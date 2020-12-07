#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my %contain;
my %can_be_in;
while (my $line = <<>>) {
    chomp $line;
    my ($bag_color, $contained) = $line =~ /(.*?) bags contain (.*) bags?\./;
    $contain{$bag_color} = {};
    next if $contained =~ /no other/;
    my @contained = split / bags?, /, $contained;
    for my $c (@contained) {
        my ($count, $color) = $c =~ /(\d+) (.*)/;
        $contain{$bag_color}->{$color} = $count;
        $can_be_in{$color}->{$bag_color} //= 0;
        $can_be_in{$color}->{$bag_color} += $count;
    }
}

my @stack = ('shiny gold');
my %seen = ();
while (my $color = shift @stack) {
    next if $seen{$color};
    $seen{$color} = 1;
    push @stack, keys %{$can_be_in{$color}};
}

print scalar(keys %seen) - 1, "\n";
