use Module::Build;
my $build = Module::Build->new(
    module_name => 'Devel::Cover::Report::Clover',
    create_makefile_pl => 'traditional',
    create_readme => 'README',
    licence => 'perl',
    requires => {
        'Devel::Cover' => '0.64'
    },
    build_requires => {
        'Test::More' => '0',
    },
);

$build->create_build_script;
