#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;

# load rules
my $rules = [];
while (<>) {
    last if /^$/;
    chomp;
    my ($i, $rule) = split /: /;
    $rules->[$i] = $rule;
}
# $rules->[0] = "8 11";
# $rules->[8] = "42 | 42 8";
# $rules->[11] = "42 31 | 42 11 31";

resolve($rules->[0], $rules, 0);

say scalar(@{$rules->[42]});
say scalar(@{$rules->[31]});


my $x = join '|', map "(?:$_)", @{$rules->[42]};
my $y = join '|', map "(?:$_)", @{$rules->[31]};
$x = "(?:$x)";
$y = "(?:$y)";

say $x;
say $y;

my @re;

for my $i (1 .. 10) {
    push @re, "^${x}+${x}{$i}${y}{$i}\$";
}

my $valid_count = 0;
while (<>) {
    chomp;
    for my $re (@re) {
        if (/$re/) {
            say;
            $valid_count++;
            last
        }
    }
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
