package Devel::Cover::Report::Clover;

use strict;
use warnings;

our $VERSION = "0.10";

use Devel::Cover::DB;
use Template;
use File::Basename qw(dirname fileparse);
use Getopt::Long;
use File::Spec;

# Entry point which C<cover> uses
sub report {
    my ( $pkg, $db, $options ) = @_;

    my $tt = Template->new(
        {   INCLUDE_PATH => tt_include_path(),
            DEBUG        => 0,
        }
    );

    my $vars = template_variables( $db, $options );

    printf( "Writing clover output file to '%s'...\n", output_file($options) )
        unless $options->{silent};

    $tt->process( template(), $vars, output_file($options) ) || die $tt->error();

}

#extend the options for the C<cover> command line
sub get_options {
    my ( $self, $opt ) = @_;
    $opt->{option}{outputfile}  = "clover.xml";
    $opt->{option}{projectname} = "Devel::Cover::Report::Clover";
    die "Invalid command line options"
        unless GetOptions(
        $opt->{option},
        qw(
            outputfile=s
            projectname=s
            )
        );
}

sub map_db_summary {
    my ( $summary, $file ) = @_;

    # for loc/nloc might want to keep tabs on
    # http://markmail.org/thread/b5sy3xgwacrbgjwg
    my $items = {
        elements             => $summary->{total}->{total}        || 0,
        elements_covered     => $summary->{total}->{covered}      || 0,
        statements           => $summary->{statement}->{total}    || 0,
        statements_covered   => $summary->{statement}->{covered}  || 0,
        conditionals         => $summary->{branch}->{total}       || 0,
        conditionals_covered => $summary->{branch}->{covered}     || 0,
        methods              => $summary->{subroutine}->{total}   || 0,
        methods_covered      => $summary->{subroutine}->{covered} || 0,

        complexity => 0,    # TODO: Perl::Metrics::Simple
        loc        => 0,    # TODO: Perl::Metrics::Simple?
        ncloc      => 0,    # TODO: Perl::Metrics::Simple?
        classes    => 0,    # TODO: whats this used for?
    };

    if ($file) {

        my $abs_path = File::Spec->rel2abs($file);
        my ($short_name) = fileparse($abs_path);

        $items->{abs_path}   = $abs_path;
        $items->{short_name} = $short_name;

    }

    return $items;
}

sub template_variables {
    my ( $db, $options ) = @_;

    my $v = {
        project_name => $options->{option}{projectname},
        version      => $VERSION,
        generated    => time(),
        total        => map_db_summary( $db->summary('Total') ),
    };

    my @items = $db->cover->items;
    foreach my $file (@items) {
        $v->{files}->{$file} = map_db_summary( $db->summary($file), $file );
    }

    return $v;
}

sub output_file {
    my ($options) = @_;

    return sprintf( '%s/%s', $options->{outputdir}, $options->{option}{outputfile} );

}

sub template {
    return 'clover.tt';
}

sub tt_file {
    return sprintf( "%s/%s", tt_include_path(), template() );
}

sub tt_include_path {
    return sprintf( '%s/Clover', dirname(__FILE__) );
}

1;

__END__

=head1 NAME

Devel::Cover::Report::Clover - Backend for Clover reporting of coverage statistics

=head1 SYNOPSIS

 cover -report clover

=head1 DESCRIPTION

This module generates a Clover compatible coverage xml file which can be used
in a variety of continuous integration software offerings.

It is designed to be called from the C<cover> program distributed with
L<Devel::Cover>.

=head1 OPTIONS

Options are specified by adding the appropriate flags to the C<cover> program.
This report format supports the following:

=over 4

=item outputfile

This will be the file name that you would like to write this report out to.
It defaults to F<clover.xml>.

=item projectname

This is simply a cosmetic item.  When the xml is generated, it has a project
name which will show up in your continuous integration system once it is
parsed.  This can be any string you want and it defaults to
'Devel::Cover::Report::Clover'.

=back

=item outputfile

Specifies the filename of the main output file.  The default is
F<coverage.html>.  Specify F<index.html> if you just want to publish the whole
directory.


=head1 SEE ALSO

 L<Devel::Cover>
 L<http://www.atlassian.com/software/clover/>

=head1 BUGS

L<https://github.com/captin411/Devel-Cover-Report-Clover/issues>

=head1 AUTHOR

David Bartle <captindave@gmail.com>

=head1 LICENSE

Copyright 2011, David Bartle (captindave@gmail.com) 

This software is free.  It is licensed under the same terms as Perl itself.

The latest version of this software should be available on github.com
https://github.com/captin411/Devel-Cover-Report-Clover

=cut
