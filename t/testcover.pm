package testcover;
use FindBin;
use File::Glob qw(bsd_glob);
use Devel::Cover::DB;

sub run {
    my $name = shift;

    my $path     = test_path($name);
    my $cover_db = cover_db_path($name);

    my $prove_cmd = `which prove`;
    chomp($prove_cmd);

    my $cover_cmd = `which cover`;
    chomp($cover_cmd);

    local $ENV{HARNESS_PERL_SWITCHES} = "'-MDevel::Cover=-db,$cover_db'";
    run_cmd( $prove_cmd, bsd_glob("$path/*.t") );
    run_cmd( $cover_cmd, $cover_db );

    my $db = Devel::Cover::DB->new( db => $cover_db );
    return $db;

}

sub run_cmd {
    my @parts = @_;
    my $str = sprintf( "'%s'", join "','", @parts );
    {
        local *STDOUT;
        open( STDOUT, '>', '/dev/null' );
        system(@parts) == 0 or die "system($str) failed: $?";
    }
    return;
}

sub cover_db_path {
    my $name = shift;
    my $path = test_path($name) . "/cover_db";
}

sub test_path {
    my $name = shift;
    return "$FindBin::Bin/../cover_db_test/$name";
}

sub test_file {
    my $name = shift;
    return test_path($name) . "/{$name}.pm";
}

1;
