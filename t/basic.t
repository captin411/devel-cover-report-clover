#!/usr/bin/perl

use Test::More;

use Devel::Cover::Report::Clover;

my @test = (
    sub {
        my $t = "tt_file - returns valid path";

        my $ret = Devel::Cover::Report::Clover::tt_file();

        ok( -f $ret, $t );
    },
    sub {
        my $t = "tt_include_path - returns valid folder";

        my $ret = Devel::Cover::Report::Clover::tt_include_path();

        ok( -d $ret, $t );
    },
    sub {
        my $t = "template - which template file to use";

        # later on, if there is some other version of the
        # DB that we need to support, selecting a differnt
        # template might do the trick... for now it's hard
        # coded

        my $ret    = Devel::Cover::Report::Clover::template();
        my $expect = 'clover.tt';

        is( $ret, $expect, $t );
    },

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

