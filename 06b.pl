#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my $total_count = 0;
my $input = {};
my $person_count = 0;
while (1) {
    my $line = <<>>;
    if (!$line || $line =~ /^$/) {
        $total_count += grep {$input->{$_} == $person_count } keys %$input;
        $input = {};
        $person_count = -1; # 0 minus one empty line...
    }
    last if ! defined $line;

    ++$person_count;
    chomp $line;
    $input->{$_}++ for (split //, $line);
}
print "$total_count\n";
