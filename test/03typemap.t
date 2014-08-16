use strict; use warnings; use diagnostics;
use lib -e 't' ? 't' : 'test';
use Test::More;
use TestInlineSetup;
use Inline Config => DIRECTORY => $TestInlineSetup::DIR;

my $testdir;
BEGIN { $testdir = -d 'test' ? 'test' : 't'; }

use Inline C => DATA =>
  TYPEMAPS => File::Spec->catfile(File::Spec->curdir(), $testdir, 'typemap');

is(int((add_em_up(1.2, 3.4) + 0.001) * 10), 46);

done_testing;

__END__
__C__
float add_em_up(float x, float y) { return x + y; }
