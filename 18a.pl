#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;

# my $expression = '2 * 3 + (4 * 5)';
# my $expression = ' 5 + (8 * 3 + 9 + 3 * 4 * 3)';

# my @tokens = ($expression =~ /(?:\d+|[()*+])/g);
# say evaluate_expression(\@tokens);
# exit 0;

my $sum = 0;
while (<>) {
    chomp;
    my @tokens = ($_ =~ /(?:\d+|[()*+])/g);
    $sum += evaluate_expression(\@tokens);
}
say $sum;

sub evaluate_expression($tokens) {
    my $result;
    my $op;
    while (my $t = shift @$tokens) {
        if ($t =~ /\d+/) {
            if (not defined $result) {
                $result = $t;
                next
            }
            if ($op eq '*') {
                $result *= $t;
                next
            }
            if ($op eq '+') {
                $result += $t;
                next
            }
        }
        if ($t =~ /[+*]/) {
            $op = $t;
            next
        }
        if ($t eq '(') {
            my $level = 1;
            my @subexpr;
            while (my $s = shift @$tokens) {
                $level++ if $s eq '(';
                $level-- if $s eq ')';
                last if $level == 0;
                push @subexpr, $s;
            }
            my $value = evaluate_expression(\@subexpr);
            if (not defined $result) {
                $result = $value;
                next
            }
            if ($op eq '*') {
                $result *= $value;
                next
            }
            if ($op eq '+') {
                $result += $value;
                next
            }
        }
        die "unexpected token $t";
    }
    return $result
}
