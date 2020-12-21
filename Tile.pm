package Tile;

use Moo;
use strictures 2;
use namespace::clean;
use Types::Standard qw(Str Int Num Maybe ArrayRef HashRef);
use feature qw(signatures say);
no warnings qw(experimental::signatures);

has id            => ( is => 'ro',   isa => Int);
has raw           => ( is => 'ro',   isa => ArrayRef);
has edges         => ( is => 'lazy', isa => ArrayRef);
has contains_edge => ( is => 'lazy', isa => HashRef);
has orientations  => ( is => 'lazy', isa => ArrayRef);

sub _build_edges($self) {
    my @edges;
    $edges[0] = $self->raw->[0];
    $edges[1] = '';
    $edges[2] = reverse $self->raw->[-1];
    $edges[3] = '';
    for my $line (@{$self->raw}) {
        my @line = split //, $line;
        $edges[1] .= $line[-1];
        $edges[3] .= $line[0];
    }
    $edges[3] = reverse $edges[3];

    return \@edges
}

sub _build_contains_edge($self) {
    my %contains;
    for my $e (@{$self->edges}) {
        $contains{$e} = 1;
        $contains{reverse $e} = 1;
    }
    return \%contains;
}

sub _build_orientations($self) {
    my @e = @{$self->edges};

    my @orientations;
    for my $i (0 .. 3) {
        push @orientations, [@e];
        push @orientations, flip_horizontally(\@e);
        push @orientations, flip_vertically(\@e);
        push @orientations, flip_both(\@e);
        #rotate
        push @e, shift @e;
    }
    return \@orientations;
}

sub flip_horizontally($edges) {
    my @e;
    $e[0] = reverse($edges->[0]);
    $e[1] = reverse($edges->[3]);
    $e[2] = reverse($edges->[2]);
    $e[3] = reverse($edges->[1]);
    return \@e
}

sub flip_vertically($edges) {
    my @e;
    $e[0] = reverse($edges->[2]);
    $e[1] = reverse($edges->[1]);
    $e[2] = reverse($edges->[0]);
    $e[3] = reverse($edges->[3]);
    return \@e
}

sub flip_both($edges) {
    return flip_horizontally(flip_vertically($edges))
}

1;
