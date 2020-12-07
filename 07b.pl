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

print contains_count('shiny gold', \%contain);

sub contains_count {
    my ($color, $contain) = @_;
    my $count = 0;
    for my $c (keys %{ $contain->{$color} }) {
        $count += $contain->{$color}{$c} * (1 + contains_count($c, $contain));
    }
    return $count;
}
