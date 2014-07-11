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
my $want = <<'...';
---
done:
  JAxH: 1
function:
  JAxH:
    arg_names:
    - x
    arg_types:
    - char *
    return_type: SV *
functions:
- JAxH
...

if ($got eq $want) {
    pass 'parse worked';
}
else {
    fail 'parse failed. (see diff)';
    io('want')->print($want);
    io('got')->print($got);
    system('diff -u want got');
    system('rm want got');
}
