#!perl

use Test::More;

use Devel::Cover::Report::Clover;

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
);

plan tests => scalar @test;

$_->() foreach @test;

