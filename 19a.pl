#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;
use List::Util qw(sum);

# load rules
my $rules = [];
while (<>) {
    last if /^$/;
    chomp;
    my ($i, $rule) = split /: /;
    $rules->[$i] = $rule;
}
resolve($rules->[0], $rules, 0);

my %valid;
$valid{$_} = 1 for @{$rules->[0]};

my $valid_count = 0;
while (<>) {
    chomp;
    $valid_count++ if $valid{$_};
}

say $valid_count;

sub resolve($rule, $rules, $index = undef) {
    if (ref $rule eq 'ARRAY') {
        return $rule
    }
    if ($rule =~ /^"([^"]+)"$/) {
        my $result = [$1];
        $rules->[$index] = $result if $index;
        return $result 
    }
    my @parts = split / \| /, $rule;
    if (@parts > 1) {
        my @result;
        push @result, @{resolve($_, $rules)} for @parts;
        $rules->[$index] = \@result if $index;
        return \@result;
    }
    my @indices = split / /, $rule;
    my @resolved = map {resolve($rules->[$_], $rules, $_)} @indices;
    my $result = shift @resolved;
    while (my $factor = shift @resolved) {
        $result = cartesian_product($result, $factor);
    }
    if (defined $index) {
        $rules->[$index] = $result;
    }
    return $result
}

sub cartesian_product($xs, $ys) {
    my @result;
    for my $x (@$xs) {
        for my $y (@$ys) {
            push @result, $x.$y;
        }
    }
    return \@result;
}
