#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my @input = sort {$a <=> $b} map { chomp; $_ } <<>>;
my %cache;

print possible_paths(0, \@input);

sub possible_paths {
    my ($prev, $input) = @_;

    my @input = @$input;

    my $key = join(' ', ($prev, @input));
    if (exists $cache{$key}) {
        return $cache{$key}
    }

    return 0 if @input == 0;
    return 0 if $input[0] - $prev > 3;
    return 1 if @input == 1;

    my $p = possible_paths($input[0], [@input[1..$#input]]);

    shift @input;

    return $p if @input == 0;
    return $p if $input[0] - $prev > 3;
    return $p+1 if @input == 1;

    $p += possible_paths($input[0], [@input[1..$#input]]);

    shift @input;

    return $p if @input == 0;
    return $p if $input[0] - $prev > 3;
    return $p+1 if @input == 1;
    $p += possible_paths($input[0], [@input[1..$#input]]);

    $cache{$key} = $p;
    return $p
}
