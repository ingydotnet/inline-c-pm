use lib 'lib';

BEGIN { system "rm _Inline* -fr" }

use Inline C => <<'END', USING => 'ParsePegex';
SV* JAxH(char* x) {
    return newSVpvf ("Just Another %s Hacker",x);
}
END

print JAxH('Inline'), "\n";

use IO::All;
use YAML::XS;

io('got')->print(Dump($main::data));
system('diff -u test/devel/expect got');

