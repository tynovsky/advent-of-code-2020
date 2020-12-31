#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(signatures say);
no warnings qw(experimental::signatures);
use Data::Dumper;

sub transform_subject_number($subject_number, $loop_size) {
    my $value = 1;
    my $moduler = 20201227;

    for my $i (1 .. $loop_size) {
        $value = ($value * $subject_number) % $moduler;
    }

    return $value
}


sub find_loop_size($subject_number, $public_key) {
    my $value = 1;
    my $moduler = 20201227;
    my $loop_size = 0;

    while (1) {
        $loop_size++;
        $value = ($value * $subject_number) % $moduler;
        last if $value == $public_key;
    }

    return $loop_size
}

my $subject_number = 7;

# my $card_public_key = transform_subject_number($subject_number, $card_loop_size);
# my $door_public_key = transform_subject_number($subject_number, $door_loop_size);

my $door_public_key = 17807724;
my $card_public_key = 5764801;

$door_public_key = 10943862;
$card_public_key = 12721030;

my $card_loop_size = find_loop_size($subject_number, $card_public_key);
my $door_loop_size = find_loop_size($subject_number, $door_public_key);


my $encryption_key_card = transform_subject_number($door_public_key, $card_loop_size);
my $encryption_key_door = transform_subject_number($door_public_key, $card_loop_size);

if ($encryption_key_door != $encryption_key_door) {
    die "encryption keys dont match";
}

say $encryption_key_door;
