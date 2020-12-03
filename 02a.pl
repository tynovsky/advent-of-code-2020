#!/usr/bin/env perl

use strict;
use warnings;

my $valid = 0;
while (my $line = <<>>) {
    chomp $line;
    my ($min, $max, $letter, $password) = $line =~ /(\d+)-(\d+) (.): (.*)/;
    my $letter_count = () = $password =~ /$letter/g;
    $valid++ if $min <= $letter_count && $letter_count <= $max;
}
print "$valid\n";
