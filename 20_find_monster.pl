#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(say);
use lib '.';
use Tile;

my $rows = [ map {chomp; $_ } <<>> ];

my $monster = <<MONSTER;
..................#..
#....##....##....###.
.#..#..#..#..#..#...
MONSTER

my $monster1 = qr/..................\#../;
my $monster2 = qr/\#....\#\#....\#\#....\#\#\#./;
my $monster3 = qr/.\#..\#..\#..\#..\#..\#.../;

my $marked_monster1 = '..................O..';
my $marked_monster2 = 'O....OO....OO....OOO.';
my $marked_monster3 = '.O..O..O..O..O..O...';

my @rotations = map {join "\n", @$_} (
    $rows,
    Tile::flip_content_horizontally($rows),
    Tile::flip_content_vertically($rows),
    Tile::flip_content_both($rows),

    Tile::rotate_content($rows),
    Tile::flip_content_horizontally(Tile::rotate_content($rows)),
    Tile::flip_content_vertically(Tile::rotate_content($rows)),
    Tile::flip_content_both(Tile::rotate_content($rows)),
);


my $hashes = () = $rotations[0] =~ /\#/gxms;
my $hashes_in_monster = () = $monster =~ /\#/gxms;
my $i = 0;
my $monsters = 0;
for my $img (@rotations) {
    print "Rotation ", ++$i, "\t";
    my $monsters = 0;
    my $chars = scalar(@$rows) - 20;
    # $monsters++ while $img =~ /$monster1 .{$chars} $monster2 .{$chars} $monster3/gxms;
    while ($img =~ s/$monster1 (.{$chars}) $monster2 (.{$chars}) $monster3/${marked_monster1}${1}${marked_monster2}${2}$marked_monster3/xms) {
        $monsters++; 
    }
    my $replaced_hashes = () = $img =~ /O/g;
    print "Replaced hashes: $replaced_hashes\t";
    print "Monsters: $monsters\t";
    print "Result: ", $hashes - $hashes_in_monster*$monsters, "\t";
    say "Result2: ", $hashes - $replaced_hashes;
    say $img if $monsters > 0;
}


