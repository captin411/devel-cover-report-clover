#!perl
use Module::Build;
my $build = Module::Build->new(
    module_name        => 'Devel::Cover::Report::Clover',
    create_makefile_pl => 'traditional',
    create_readme      => 'README',
    license            => 'perl',
    requires           => {
        'Devel::Cover'          => 0,
        'Template'              => 0,
        'Class::Accessor::Fast' => 0,
    },
    build_requires => {
        'Test::More'       => '0',
        'Test::MockObject' => '0',
        'Test::MockTime'   => '0'
    },
    template_files => { 'template/clover.tt' => 'lib/Devel/Cover/Report/Clover/clover.tt' }
);
$build->add_build_element('template');
$build->create_build_script;
