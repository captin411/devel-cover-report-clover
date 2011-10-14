#!perl

use Test::More;
use Devel::Cover::Report::Clover::Builder;

use FindBin;
use lib ($FindBin::Bin);
use testcover;

my $DB = testcover::run('multi_file');

my $b        = BUILDER( { name => 'test', db => $DB } );
my $proj     = $b->project;
my @packages = @{ $proj->packages };
my $package  = $proj->package('');

my @test = (
    sub {
        my $t = "packages - count";
        is( scalar @packages, 2, $t );
    },
    sub {
        my $t       = "package - single item found";
        my $package = $proj->package('');
        ok( $package, $t );
    },
    sub {
        my $t       = "package - single item found with no args";
        my $package = $proj->package();
        ok( $package, $t );
    },
    sub {
        my $t       = "package - undef";
        my $package = $proj->package('adfasf');
        is( $package, undef, $t );
    },
    sub {
        my $t       = "classes - count";
        my $package = $proj->package('');
        my @classes = @{ $package->classes };
        is( scalar @classes, 1, $t );
    },
    sub {
        my $t       = "summarize";
        my $package = $proj->package('MultiFile');
        my $s       = $package->summarize()->{total};

        my $expected = {
            'covered'     => 14,
            'uncoverable' => 0,
            'error'       => 10,
            'percentage'  => '50',
            'total'       => 24
        };

        is( $s->{covered}, $expected->{covered}, "$t - covered value" );
        is( $s->{total},   $expected->{total},   "$t - total value" );

    },
);

plan tests => scalar @test + 1;

$_->() foreach @test;

sub BUILDER {
    return Devel::Cover::Report::Clover::Builder->new(shift);
}

