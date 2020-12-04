#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my $valid = 0;
my $input = {};
while (1) {
    my $line = <<>>;
    if (!$line || $line =~ /^$/) {
        $valid += validate($input);
        $input = {} 
    }
    last if ! defined $line;

    chomp $line;
    $input = { %$input, map { split /:/, $_ } (split / /, $line) };
}
print "$valid\n";

sub validate {
    my $input = shift;
    my @required = qw(byr iyr eyr hgt hcl ecl pid);
    for my $r (@required) {
        return 0 if !defined($input->{$r})
    }
    return 1
}
