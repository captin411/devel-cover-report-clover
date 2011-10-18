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

    my $conditionals         = $s->{branch}->{total}   || 0;
    my $conditionals_covered = $s->{branch}->{covered} || 0;
    if ( $self->builder->include_condition_criteria ) {
        $conditionals         += $s->{condition}->{total}   || 0;
        $conditionals_covered += $s->{condition}->{covered} || 0;
    }

    my $statements         = $s->{statement}->{total}   || 0;
    my $statements_covered = $s->{statement}->{covered} || 0;

    my $subroutines         = $s->{subroutine}->{total}   || 0;
    my $subroutines_covered = $s->{subroutine}->{covered} || 0;

    my $total         = $conditionals + $statements + $subroutines;
    my $total_covered = $conditionals_covered + $statements_covered + $subroutines_covered;

    my $metrics = {
        packages => scalar @{ $self->packages },
        files    => scalar @{ $self->files },
        classes  => scalar @{ $self->classes() },

        elements            => $total,
        coveredelements     => $total_covered,
        statements          => $statements,
        coveredstatements   => $statements_covered,
        complexity          => 0,
        loc                 => $self->loc(),
        ncloc               => $self->ncloc(),
        conditionals        => $conditionals,
        coveredconditionals => $conditionals_covered,
        methods             => $subroutines,
        coveredmethods      => $subroutines_covered
    };

    return $metrics;
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

    my %s = %{ $self->builder->db->summary('Total') };

    my @criteria = $self->builder->accept_criteria();

    my %filtered;
    foreach my $c (@criteria) {
        next unless exists $s{$c};
        $filtered{$c} = $s{$c};
    }
    return \%filtered;
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

