#!perl
use Module::Build;
use lib 't';
use testcover;

if ( !testcover::cover_cmd() ) {
    warn("no 'cover' command found so this can not be tested. Ensure Devel::Cover is installed");
    exit 0 if $ENV{AUTOMATED_TESTING};
}
my $build = Module::Build->new(
    module_name        => 'Devel::Cover::Report::Clover',
    create_makefile_pl => 'traditional',
    create_readme      => 'README',
    license            => 'perl',
    no_index           => { 'directory' => [ 'cover_db_test', 't', ], },
    requires           => {
        'Class::Accessor' => 0,
        'Devel::Cover'    => 0,
        'HTML::Parser'    => 0,    # For HTML::Entities
        'Template'        => 0,
    },
    recommends     => { 'Test::MockTime' => 0, },
    build_requires => {
        'TAP::Harness'     => '0',
        'Test::Exception'  => '0',
        'Test::More'       => '0',
        'Test::MockObject' => '0',
    },
);
$build->add_build_element('tt');
$build->create_build_script;
