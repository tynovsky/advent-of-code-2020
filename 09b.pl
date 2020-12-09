#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(sum min max);

my $invalid = 542529149;

my @context;
while (my $n = <<>>) {
    push @context, $n;
    shift @context while sum(@context) > $invalid;
    last if $invalid == sum(@context);
}

print join('+', @context), "\n";
print ' == ', sum(@context), "\n";
print "soucet min a max ";
print min(@context) + max(@context), "\n";

