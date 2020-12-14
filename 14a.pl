#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;
use List::Util qw(sum);


say bin2dec([0,1,0,1]);
say Dumper dec2bin(10);

my %values;
my $mask;
while (my $line = <>) {
    if ($line =~ /mask/) {
        chomp $line;
        $mask = load_mask($line);
        next;
    }
    my ($index, $value) = $line =~ /mem\[(\d+)\] = (\d+)/;
    my $b = dec2bin($value);
    for my $m (keys %$mask) {
        $b->[$m] = $mask->{$m}
    }
    $_ //= 0 for @$b;
    $value = bin2dec($b);
    $values{$index} = $value;
}

say sum(values %values);

sub load_mask($line) {
    my %mask;
    $line =~ s/mask = //;
    my $exp = 0;
    for my $i (reverse split //, $line) {
        if ($i eq 'X') { $exp++; next }
        $mask{$exp++} = $i;
    }
    return \%mask;
}

sub dec2bin($dec) {
    my @bin;
    while ($dec > 0) {
        push @bin, ($dec % 2);
        $dec = int($dec / 2);
    }
    return \@bin
}

sub bin2dec($bin) {
    my @bin = @$bin;
    my $dec = 0;
    for my $i (0 .. $#bin) {
        $dec += 2**$i * $bin[$i]
    }
    return $dec
}
