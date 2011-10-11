use Module::Build;
my $build = Module::Build->new(
    module_name        => 'Devel::Cover::Report::Clover',
    create_makefile_pl => 'traditional',
    create_readme      => 'README',
    licence            => 'perl',
    requires           => {
        'Devel::Cover' => '0.64',
        'Template'     => 0,
    },
    build_requires => { 'Test::More'         => '0', },
    template_files => { 'template/clover.tt' => 'lib/Devel/Cover/Report/Clover/clover.tt' }
);
$build->add_build_element('template');
$build->create_build_script;
