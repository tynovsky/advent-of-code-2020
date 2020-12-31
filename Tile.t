#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use lib '.';
use Tile;

my $content = ['abc', 'def', 'ghi'];

is_deeply(Tile::flip_content_horizontally($content), ['cba', 'fed', 'ihg']);
is_deeply(Tile::flip_content_vertically($content), ['ghi', 'def', 'abc']);
is_deeply(Tile::flip_content_both($content), ['ihg', 'fed', 'cba']);
is_deeply(Tile::rotate_content($content), ['cfi', 'beh', 'adg']);

my $t = Tile->new(raw => $content, id => 1);
is_deeply($t->strip_edges(), ['e']);


done_testing;
