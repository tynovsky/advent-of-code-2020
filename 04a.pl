#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;


my $valid = 0;
my $input = {};
while (my $line = <<>>) {
    chomp($line);
    if ($line =~ /^$/) {
        print Dumper($input);
        $valid += validate($input);
        $input = {} 
    }
    my @fields = split / /, $line;
    for my $f (@fields) {
        my ($key, $value) = split /:/, $f;
        $input->{$key} = $value
    }
}
print Dumper($input);
$valid += validate($input);
print "$valid\n";


sub validate {
    my $input = shift;
    my @required = qw(byr iyr eyr hgt hcl ecl pid);
    for my $r (@required) {
        return 0 if !defined($input->{$r})
    }
    return 1
}
