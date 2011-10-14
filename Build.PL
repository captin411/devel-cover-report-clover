#!perl
use Module::Build;
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
        'Test::More'       => '0',
        'Test::MockObject' => '0',
    },
    template_files => { 'template/clover.tt' => 'lib/Devel/Cover/Report/Clover/clover.tt' }
);
$build->add_build_element('template');
$build->create_build_script;
