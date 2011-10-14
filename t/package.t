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
        my $s       = $package->summarize();

        my $expected = {
            'statement' => {
                'covered'    => 10,
                'error'      => 2,
                'percentage' => '83.3333333333333',
                'total'      => 12
            },
            'subroutine' => {
                'covered'    => 4,
                'error'      => 1,
                'percentage' => 80,
                'total'      => 5
            },
            'total' => {
                'covered'    => 14,
                'error'      => 3,
                'percentage' => '82.3529411764706',
                'total'      => 17
            }
        };

        is_deeply( $s, $expected, $t );
    },
);

plan tests => scalar @test;

$_->() foreach @test;

sub BUILDER {
    return Devel::Cover::Report::Clover::Builder->new(shift);
}

