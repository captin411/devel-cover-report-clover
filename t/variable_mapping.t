#!perl

use Test::More;

use Devel::Cover::Report::Clover;

my $MOCK_LOADED = 0;
eval {
    require Test::MockObject;
    $MOCK_LOADED = 1;
};

my @test = (
    sub {
        my $t = "map_db_summary - nothing undef";

        my $summary = {
            'total' => {
                'total'   => 1,
                'covered' => 2,
            },
            'statement' => {
                'total'   => 3,
                'covered' => 4,
            },
            'branch' => {
                'total'   => 5,
                'covered' => 6,
            },
            'subroutine' => {
                'total'   => 7,
                'covered' => 8,
            }
        };

        my $expect = {
            'elements'             => 1,
            'elements_covered'     => 2,
            'statements'           => 3,
            'statements_covered'   => 4,
            'conditionals'         => 5,
            'conditionals_covered' => 6,
            'methods'              => 7,
            'methods_covered'      => 8,
            'complexity'           => 0,
            'loc'                  => 0,
            'ncloc'                => 0,
            'classes'              => 0,
        };

        my $ret = Devel::Cover::Report::Clover::map_db_summary($summary);

        is_deeply( $ret, $expect, $t );

    },
    sub {
        my $t = "map_db_summary - everything undef";

        my $summary = undef;

        my $expect = {
            'elements'             => 0,
            'elements_covered'     => 0,
            'statements'           => 0,
            'statements_covered'   => 0,
            'conditionals'         => 0,
            'conditionals_covered' => 0,
            'methods'              => 0,
            'methods_covered'      => 0,
            'complexity'           => 0,
            'loc'                  => 0,
            'ncloc'                => 0,
            'classes'              => 0,
        };

        my $ret = Devel::Cover::Report::Clover::map_db_summary($summary);

        is_deeply( $ret, $expect, $t );

    },

    sub {
        my $t = "map_db_summary - stats plus optional filename";

        my $summary = {
            'total' => {
                'total'   => 1,
                'covered' => 2,
            },
            'statement' => {
                'total'   => 3,
                'covered' => 4,
            },
            'branch' => {
                'total'   => 5,
                'covered' => 6,
            },
            'subroutine' => {
                'total'   => 7,
                'covered' => 8,
            }
        };

        my $file = "t/my_fake_file.pm";

        my $expect = {
            'elements'             => 1,
            'elements_covered'     => 2,
            'statements'           => 3,
            'statements_covered'   => 4,
            'conditionals'         => 5,
            'conditionals_covered' => 6,
            'methods'              => 7,
            'methods_covered'      => 8,
            'complexity'           => 0,
            'loc'                  => 0,
            'ncloc'                => 0,
            'classes'              => 0,
            'abs_path'             => File::Spec->rel2abs($file),
            'short_name'           => 'my_fake_file.pm',
        };

        my $ret = Devel::Cover::Report::Clover::map_db_summary( $summary, $file );

        is_deeply( $ret, $expect, $t );

    },
);

plan tests => scalar @test;

$_->() foreach @test;

