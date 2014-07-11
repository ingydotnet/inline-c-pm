use strict;
use Test::More tests => 2;
use IO::All;
use YAML::XS;

BEGIN { system "rm _Inline* -fr" }
END { system "rm _Inline* -fr" }

use Inline C => <<'END', USING => 'ParsePegex';
SV* JAxH(char* x) {
    return newSVpvf ("Just Another %s Hacker",x);
}
END

is JAxH('Inline'), "Just Another Inline Hacker";

my $got = Dump($main::data);
my $expect = io('xt/expect')->all;

if ($got eq $expect) {
    pass 'parse worked';
}
else {
    fail 'parse failed. (see diff)';
    io('got')->print($got);
    system('diff -u xt/expect got');
    system('rm got');
}

