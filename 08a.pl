#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my @program = <<>>;
print Dumper \@program;

my $i = 0;
my %seen;
my $acc = 0;

while (1) {
    last if $seen{$i}++;
    my $instruction = $program[$i];
    chomp $instruction;
    my ($op, $arg) = split / /, $instruction;
    if ($op eq 'nop') { ++$i; next }
    if ($op eq 'acc') { $acc += $arg; ++$i; next }
    if ($op eq 'jmp') { $i += $arg; next }
    die 'unknown op';
}

print "$acc\n"
