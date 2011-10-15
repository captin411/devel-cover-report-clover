package testcover;
use Config;
use Devel::Cover::DB;
use File::Glob qw(bsd_glob);
use FindBin;
use List::Util qw(first);
use TAP::Harness;

sub run {
    my $name = shift;

    my $path     = test_path($name);
    my $cover_db = cover_db_path($name);

    my $harness = TAP::Harness->new(
        {   verbosity => -3,
            lib       => [$path],
            switches  => "-MDevel::Cover=-db,$cover_db"
        }
    );
    my @tests = bsd_glob("$path/*.t");
    $harness->runtests(@tests);

    my $cover_cmd = cover_cmd();

    if ( !$cover_cmd ) {
        die('Missing "cover" command');
    }

    my $path_to_perl = $Config{perlpath};
    run_cmd( $path_to_perl, $cover_cmd, $cover_db );

    my $db = Devel::Cover::DB->new( db => $cover_db );
    return $db;

}

sub p_which {
    my $command = shift;

    return first {-f}
    map {"$_/$command"} @Config{qw/installscript installsitebin installvendorbin installbin/};

}

sub run_cmd {
    my @parts = @_;
    my $str = sprintf( "'%s'", join "','", @parts );
    {
        local *STDOUT = STDOUT;
        open( STDOUT, '>', '/dev/null' );
        system(@parts) == 0 or die "system($str) failed: $? \n";
    }
    return;
}

sub cover_cmd {
    my $which = `which cover`;
    chomp($which);
    my $p_which = p_which('cover');

    return first {$_} ( $p_which, $which );
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
