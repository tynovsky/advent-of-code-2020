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
        return 0 if !defined($input->{$r});
        my $val = $input->{$r};
        return 0 if ($r eq 'byr') && ($val < 1920 || $val > 2002);
        return 0 if ($r eq 'iyr') && ($val < 2010 || $val > 2020);
        return 0 if ($r eq 'eyr') && ($val < 2020 || $val > 2030);
        if ($r eq 'hgt') {
            return 0 if $val !~ /(.*)(in|cm)$/;
            return 0 if ($2 eq "cm") && ($1 < 150 || $1 > 193);
            return 0 if ($2 eq "in") && ($1 < 59 || $1 > 76);
        }
        return 0 if ($r eq 'hcl') && $val !~ /^\#[0-9a-f]{6}$/;
        return 0 if ($r eq 'ecl') && $val !~ /^(amb|blu|brn|gry|grn|hzl|oth)$/;
        return 0 if ($r eq 'pid') && $val !~ /^\d{9}$/;
    }
    return 1
}
