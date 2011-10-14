package testcover;
use FindBin;
use Devel::Cover::DB;

sub run {
    my $name = shift;

    my $path     = test_path($name);
    my $cover_db = cover_db_path($name);

    my $harness_switches = "-MDevel::Cover=-db,$cover_db";

    local $ENV{HARNESS_PERL_SWITCHES} = $harness_switches;

    my $cover_delete = "cover -delete $cover_db 2>/dev/null 1>/dev/null";
    system($cover_delete) == 0 or die "system $cover_delete failed: $?";

    my $prove_cmd = "prove $path/*.t 2>/dev/null 1>/dev/null";
    system($prove_cmd) == 0 or die "system $prove_cmd failed: $?";

    my $cover_cmd = "cover $cover_db 2>/dev/null 1>/dev/null";
    system($cover_cmd) == 0 or die "system $cover_cmd failed: $?";

    my $db = Devel::Cover::DB->new( db => $cover_db );
    return $db;

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
