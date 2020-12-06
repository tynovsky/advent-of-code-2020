#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my $total_count = 0;
my $input = {};
while (1) {
    my $line = <<>>;
    if (!$line || $line =~ /^$/) {
        $total_count += keys %$input;
        $input = {} 
    }
    last if ! defined $line;

    chomp $line;
    $input->{$_}++ for (split //, $line);
}
print "$total_count\n";
