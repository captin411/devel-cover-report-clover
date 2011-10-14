#!perl

use Test::Exception;
use Test::More;

use Devel::Cover::Report::Clover;
use Devel::Cover::Report::Clover::Reportable;

my $reportable = Devel::Cover::Report::Clover::Reportable->new();

my @test = (
    sub {
        my $t = "output_file - outputdir + outputfile are defined";

        my $dir     = "/dir";
        my $file    = "file.xml";
        my $options = {
            outputdir => $dir,
            option    => { outputfile => $file, }
        };

        my $got    = Devel::Cover::Report::Clover::output_file($options);
        my $expect = "$dir/$file";

        is( $got, $expect, $t );

    },
    sub {
        my $t = "reportable->report - dies";
        throws_ok( sub { $reportable->report() }, '/implement/', $t );
    },
    sub {
        my $t = "reportable->metrics - dies";
        throws_ok( sub { $reportable->metrics() }, '/implement/', $t );
    },
);

plan tests => scalar @test;

$_->() foreach @test;

