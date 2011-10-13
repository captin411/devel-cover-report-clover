package Devel::Cover::Report::Clover::Project;
use strict;
use warnings;
use base qw(Devel::Cover::Report::Clover::Reportable);

sub report {
    my ($self) = @_;

    my @p_reports = map { $_->report } @{ $self->packages };

    my $data = {
        name     => $self->name(),
        metrics  => $self->metrics(),
        packages => \@p_reports,
    };
    return $data;
}

sub metrics {
    my ($self) = @_;

    my $s = $self->summarize();

    my $metrics = {
        packages => scalar @{ $self->packages },
        files    => scalar @{ $self->files },
        classes  => scalar @{ $self->classes() },

        elements            => $s->{total}->{total}        || 0,
        coveredelements     => $s->{total}->{covered}      || 0,
        statements          => $s->{statement}->{total}    || 0,
        coveredstatements   => $s->{statement}->{covered}  || 0,
        complexity          => 0,
        loc                 => $self->loc(),
        ncloc               => $self->ncloc(),
        conditionals        => $s->{branch}->{total}       || 0,
        coveredconditionals => $s->{branch}->{covered}     || 0,
        methods             => $s->{subroutine}->{total}   || 0,
        coveredmethods      => $s->{subroutine}->{covered} || 0,
    };
}

sub classes {
    my ($self) = @_;
    return $self->builder->file_registry->classes;
}

sub packages {
    my ($self) = @_;
    return $self->builder->file_registry->packages;

}

sub package {
    my ( $self, $name ) = @_;
    $name = '' if !defined $name;
    my @found = grep { $_->name eq $name } @{ $self->packages };
    return undef unless @found;
    return $found[0];
}

sub files {
    my ($self) = @_;
    return $self->builder->file_registry->files;
}

sub summarize {
    my ($self) = @_;
    return $self->builder->db->summary('Total');
}

sub loc {
    my ($self) = @_;
    my $loc = 0;
    foreach my $f ( @{ $self->files } ) {
        $loc += $f->loc();
    }
    return $loc;
}

sub ncloc {
    my ($self) = @_;
    my $ncloc = 0;
    foreach my $f ( @{ $self->files } ) {
        $ncloc += $f->ncloc();
    }
    return $ncloc;
}

1;

