#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;
use List::Util qw(sum);


my %flips;
while (my $line = <>) {
    my %counts;

    for my $dir (qw(se sw ne nw e w)) {
        $counts{$dir} = () = $line =~ /$dir/g;
        $line =~ s/$dir//g;
    }

    my $x = 2 * $counts{e} + sum(@counts{qw(ne se)})
          - 2 * $counts{w} - sum(@counts{qw(nw sw)});
    my $y = sum(@counts{qw(ne nw)}) - sum(@counts{qw(se sw)});
    
    $flips{"$x:$y"} = ! $flips{"$x:$y"};
}

say $_ for keys %flips;

say scalar (grep { $_ } values %flips);
