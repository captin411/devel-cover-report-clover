package Devel::Cover::Report::Clover::Reportable;
use strict;
use warnings;
use base qw(Class::Accessor);
__PACKAGE__->mk_accessors(qw(builder name));

sub report {
    die("subclass must implement");
}

sub metrics {
    die("subclass must implement");
}

1;
