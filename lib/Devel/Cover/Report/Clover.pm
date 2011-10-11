package Devel::Cover::Report::Clover;

use strict;
use warnings;

our $VERSION = "0.64";

use Devel::Cover::DB 0.64;

# Entry point which C<cover> uses
sub report {
    my ($pkg, $db, $options) = @_;
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
