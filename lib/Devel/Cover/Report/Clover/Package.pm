package Devel::Cover::Report::Clover::Package;
use strict;
use warnings;
use Devel::Cover::Criterion;
use base qw(Devel::Cover::Report::Clover::Reportable);
__PACKAGE__->mk_accessors(qw(classes));

sub report {
    my ($self) = @_;

    my $name = $self->name() || '';
    ( my $name_dotted = $name ) =~ s/\W+/./g;

    my $data = {
        name        => $name,
        name_dotted => $name_dotted,
        metrics     => $self->metrics(),
        files       => [ map { $_->report } @{ $self->files } ],
    };
    return $data;
}

sub files {
    my ($self) = @_;

    my %frag_classes;
    foreach my $c ( @{ $self->classes } ) {
        my $n = $c->file_fragment->name;
        push @{ $frag_classes{$n} }, $c;
    }

    my @ret;
    foreach my $name ( keys %frag_classes ) {
        my $classes = $frag_classes{$name};
        my $file    = Devel::Cover::Report::Clover::PackageFile->new(
            {   name    => $name,
                classes => [@$classes]
            }
        );
        push @ret, $file;
    }

    return \@ret;

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
        files   => scalar @{ $self->files },
        classes => scalar @{ $self->classes() },

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

sub summarize {
    my ($self) = @_;
    my $classes = $self->classes();

    my $summary = {};

    foreach my $class (@$classes) {
        my $cs = $class->summarize();
        foreach my $criteria ( keys %$cs ) {
            my $cr = $cs->{$criteria};
            foreach my $data ( keys %$cr ) {
                $summary->{$criteria}->{$data} += $cs->{$criteria}->{$data};
            }
            Devel::Cover::Criterion->calculate_percentage( $self, $summary->{$criteria} );
        }
    }

    Devel::Cover::Criterion->calculate_percentage( $self, $summary->{total} );

    return $summary;

}

sub loc {
    my ($self) = @_;
    my $classes = $self->classes();

    my $loc = 0;
    foreach (@$classes) {
        $loc += $_->loc();
    }
    return $loc;
}

sub ncloc {
    my ($self) = @_;
    my $classes = $self->classes();

    my $ncloc = 0;
    foreach (@$classes) {
        $ncloc += $_->ncloc();
    }
    return $ncloc;
}

1;

package Devel::Cover::Report::Clover::PackageFile;
use strict;
use warnings;
use Devel::Cover::Criterion;
use base qw(Devel::Cover::Report::Clover::Reportable);
__PACKAGE__->mk_accessors(qw(classes));

sub report {
    my ($self) = @_;
    my $data = {
        name    => $self->name(),
        metrics => $self->metrics(),
        classes => [ map { $_->report } @{ $self->classes } ],
    };
    return $data;
}

sub metrics {
    my ($self) = @_;

    my $s = $self->summarize();

    my $metrics = {
        classes => scalar @{ $self->classes },

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

sub summarize {
    my ($self) = @_;
    my $classes = $self->classes;

    my $summary = {};

    foreach my $class (@$classes) {
        my $cs = $class->summarize();
        foreach my $criteria ( keys %$cs ) {
            my $cr = $cs->{$criteria};
            foreach my $data ( keys %$cr ) {
                $summary->{$criteria}->{$data} += $cs->{$criteria}->{$data};
            }
            Devel::Cover::Criterion->calculate_percentage( $self, $summary->{$criteria} );
        }
    }

    Devel::Cover::Criterion->calculate_percentage( $self, $summary->{total} );

    return $summary;

}

sub loc {
    my ($self) = @_;
    my $classes = $self->classes();

    my $loc = 0;
    foreach (@$classes) {
        $loc += $_->loc();
    }
    return $loc;
}

sub ncloc {
    my ($self) = @_;
    my $classes = $self->classes();

    my $ncloc = 0;
    foreach (@$classes) {
        $ncloc += $_->ncloc();
    }
    return $ncloc;
}

1;
1;
