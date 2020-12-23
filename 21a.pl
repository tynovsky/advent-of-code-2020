#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;
use List::Util qw(sum);

my %all_ingredients;
my %in_one_of;
while (my $line = <>) {
    chomp $line;
    my ($ingredients, $allergens) = $line =~ /(.*) \(contains (.*)\)/;
    my @ingredients = split / /, $ingredients;
    my @allergens = split /, /, $allergens;
    for my $allergen (@allergens) {
        $in_one_of{$allergen} = intersect(
            $in_one_of{$allergen},
            { map {$_ => 1} @ingredients }
        );
    }
    $all_ingredients{$_}++ for @ingredients;
}

while (1) {
    my $hit = 0;
    for my $allergen (keys %in_one_of) {
        my @ingredients = keys %{ $in_one_of{$allergen} };
        my $ingredient = shift @ingredients;
        if (@ingredients == 0) {
            for my $other_alergen (keys %in_one_of) {
                next if $other_alergen eq $allergen;
                if (exists $in_one_of{$other_alergen}->{$ingredient}) {
                    delete $in_one_of{$other_alergen}->{$ingredient} ;
                    $hit = 1
                }
            }
        }
    }
    last if ! $hit;
}

my %clean_ingredients = %all_ingredients;
for my $potentially_allergic (values %in_one_of) {
    for my $ingredient (keys %$potentially_allergic) {
        delete $clean_ingredients{$ingredient}
    }
}

say sum values %clean_ingredients;


sub intersect($a, $b) {
    return {%$b} if ! defined $a;
    return {%$a} if ! defined $b;

    my %result = %$a;
    for my $key (keys %result) {
        delete $result{$key} if ! exists $b->{$key};
    }

    return \%result
}


