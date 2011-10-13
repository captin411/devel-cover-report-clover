#!perl

use Test::More;
use Devel::Cover::Report::Clover::Builder;
use FindBin;
use lib ($FindBin::Bin);
use testcover;

my $MULTI_FILE_DB = testcover::run('multi_file');

my @test = (
    sub {
        my $t = "report - end to end";

        my $proj_name = "Multi File";

        my $b = BUILDER( { name => $proj_name, db => $MULTI_FILE_DB } );

        my $report = $b->report();

        #diag(Dumper($report)); use Data::Dumper;
        my $expect = {};

        ok(1);

        #is_deeply( $report, $expect, $t );

    },
    sub {
        my $t = "report_xml - end to end";

        my $proj_name = "Multi File";

        my $b = BUILDER( { name => $proj_name, db => $MULTI_FILE_DB } );

        $b->generate( testcover::test_path('multi_file') . '/clover.xml' );

        #diag(Dumper($report)); use Data::Dumper;
        my $expect = {};

        ok(1);

        #is_deeply( $report, $expect, $t );

    },

);

plan tests => scalar @test;

$_->() foreach @test;

sub BUILDER {
    return Devel::Cover::Report::Clover::Builder->new(shift);
}

