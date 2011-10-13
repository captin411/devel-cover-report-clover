#!perl
use FindBin qw($Bin);
use Test::More tests => 1;
use lib $Bin;
use Empty;

ok(1,'Empty.t');
