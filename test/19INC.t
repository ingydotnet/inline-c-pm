BEGIN {
  if (exists $ENV{PERL_INSTALL_ROOT}) {
    warn "\nIgnoring \$ENV{PERL_INSTALL_ROOT} in $0\n";
    delete $ENV{PERL_INSTALL_ROOT};
  }
};
use File::Spec;
use strict;
use warnings;
use Cwd;
use File::Basename;
use lib dirname(__FILE__);
use TestInlineSetup;
use Inline Config => DIRECTORY => $TestInlineSetup::DIR;

BEGIN {
  my $testdir = -d 'test' ? 'test' : 't';
  my $cwd = Cwd::getcwd();
  my $incdir1 = $cwd . "/$testdir/foo/";
  my $incdir2 = $cwd . "/$testdir/bar/";
  $main::includes = "-I$incdir1  -I$incdir2";
};

use Inline C => Config =>
 INC => $main::includes;

use Inline C => <<'EOC';

#include <find_me_in_foo.h>
#include <find_me_in_bar.h>

SV * foo() {
  return newSViv(-42);
}

EOC

print "1..1\n";

my $f = foo();
if($f == -42) {print "ok 1\n"}
else {
  warn "\n\$f: $f\n";
  print "not ok 1\n";
}



