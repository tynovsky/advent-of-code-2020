#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(say);

my (@nums, %seen);
while (<<>>) {
    chomp;
    tr /[FL]/0/;
    tr /[BR]/1/;
    push @nums, oct("0b".$_);
}

@nums = sort {$a <=> $b} @nums;
my %found = map {$_ => 1} @nums;

say $nums[$#nums];
for ($nums[0] .. $nums[$#nums]) {
    say if not $found{$_} 
}
