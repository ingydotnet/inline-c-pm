use File::Spec;
use strict;
use Test::More;
use diagnostics;
use File::Basename;
use lib dirname(__FILE__);
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
