#!/usr/bin/env perl

use strict;
use warnings;

my $valid = 0;
while (my $line = <<>>) {
    chomp $line;
    my ($pos1, $pos2, $letter, $password) = $line =~ /(\d+)-(\d+) (.):(.*)/;
    my @password = split //, $password;
    my $appeared = ($password[$pos1] eq $letter) + ($password[$pos2] eq $letter);
    $valid++ if $appeared == 1
}
print "$valid\n";
