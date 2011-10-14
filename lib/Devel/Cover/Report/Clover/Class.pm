package Devel::Cover::Report::Clover::Class;
use strict;
use warnings;
use base qw(Devel::Cover::Report::Clover::Reportable);
__PACKAGE__->mk_accessors(qw( name package file_fragment ));

sub full_name {
    my ($self) = @_;

    return join '::', grep {$_} ( $self->package, $self->name );
}

sub report {
    my ($self) = @_;

    my $name = $self->name() || '';
    ( my $name_dotted = $name ) =~ s/\W+/./g;

    my $data = {
        name        => $name,
        name_dotted => $name_dotted,
        metrics     => $self->metrics(),
    };
    return $data;
}

sub metrics {
    my ($self) = @_;

    my $s = $self->summarize();

    my $conditionals         = $s->{branch}->{total}   || 0;
    my $conditionals_covered = $s->{branch}->{covered} || 0;
    if ( $self->builder->include_condition_criteria ) {
        $conditionals         += $s->{condition}->{total}   || 0;
        $conditionals_covered += $s->{condition}->{covered} || 0;
    }

    my $metrics = {
        elements          => $s->{total}->{total}       || 0,
        coveredelements   => $s->{total}->{covered}     || 0,
        statements        => $s->{statement}->{total}   || 0,
        coveredstatements => $s->{statement}->{covered} || 0,
        complexity        => 0,
        loc               => $self->loc(),
        ncloc             => $self->ncloc(),
        conditionals      => $conditionals,
        coveredconditionals => $conditionals_covered,
        methods             => $s->{subroutine}->{total} || 0,
        coveredmethods      => $s->{subroutine}->{covered} || 0,
    };

    return $metrics;
}

sub loc {
    my ($self) = @_;
    return $self->file_fragment->loc();
}

sub ncloc {
    my ($self) = @_;
    return $self->file_fragment->ncloc();
}

sub summarize {
    my ($self) = @_;
    return $self->file_fragment->summarize();
}

1;

