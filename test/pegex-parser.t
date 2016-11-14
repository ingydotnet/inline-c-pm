use Test::More;
plan skip_all => '$ENV{PERL_INLINE_DEVELOPER_TEST} not set'
  unless defined $ENV{PERL_INLINE_DEVELOPER_TEST};
plan tests => 2;

use IO::All;
use YAML::XS;

#even if test is skipped, BEGIN and END blocks are executed and print warnings in case rm is not available
BEGIN { if (defined $ENV{PERL_INLINE_DEVELOPER_TEST}) { system "rm _Inline* -fr" } }
END { if (defined $ENV{PERL_INLINE_DEVELOPER_TEST}) { local $?; system "rm _Inline* -fr" } }

use Inline C => <<'END', USING => '::Parser::Pegex';
SV* JAxH(char* x) {
    return newSVpvf ("Just Another %s Hacker",x);
}
END

is JAxH('Inline'), "Just Another Inline Hacker", 'initial Inline code parsed';

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

is $got, $want, 'parse worked';

# left in comments per ingy wish
# io('want')->print($want);
# io('got')->print($got);
# system('diff -u want got');
# system('rm want got');
