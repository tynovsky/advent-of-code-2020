#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my @program = <<>>;
@program = map {chomp; [split / /, $_]} @program;

for my $i (0 .. $#program) {
    my $result = 0;
    if ($program[$i]->[0] eq 'jmp') {
        $program[$i]->[0] = 'nop';
        $result = run(\@program);
        $program[$i]->[0] = 'jmp';
    }
    if ($program[$i]->[0] eq 'nop') {
        $program[$i]->[0] = 'jmp';
        $result = run(\@program);
        $program[$i]->[0] = 'nop';
    }
    if ($result) {
        print $result, "\n";
        last
    }
}

sub run {
    my ($program) = @_;
    my $i = 0;
    my %seen;
    my $acc = 0;
    while (1) {
        return 0 if $seen{$i}++;
        return $acc if $i == scalar(@$program);
        my ($op, $arg) = @{ $program[$i] };
        if ($op eq 'nop') { ++$i; next }
        if ($op eq 'acc') { $acc += $arg; ++$i; next }
        if ($op eq 'jmp') { $i += $arg; next }
        die 'unknown op';
    }
}
