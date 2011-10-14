package testcover;
use FindBin;
use Devel::Cover::DB;

sub run {
    my $name = shift;

    my $path     = test_path($name);
    my $cover_db = cover_db_path($name);

    local $ENV{HARNESS_PERL_SWITCHES} = "-MDevel::Cover=-db,$cover_db";

    system("cover -delete $cover_db 2>/dev/null 1>/dev/null");
    system("prove $path/*.t 2>/dev/null 1>/dev/null");
    system("cover $cover_db 2>/dev/null 1>/dev/null");

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
