BEGIN {
  if (exists $ENV{PERL_INSTALL_ROOT}) {
    warn "\nIgnoring \$ENV{PERL_INSTALL_ROOT} in $0\n";
    delete $ENV{PERL_INSTALL_ROOT};
  }
};

use File::Spec;
use strict;
use diagnostics;
use File::Basename;
use lib dirname(__FILE__);
use TestInlineSetup;
use Inline Config => DIRECTORY => $TestInlineSetup::DIR;
use Config;

print "1..1\n";

my $testdir;
BEGIN {
    $testdir = -d 'test' ? 'test' : 't';
}

use Inline C => Config =>
    #BUILD_NOISY => 1,
    #CLEAN_AFTER_BUILD => 0,
    FORCE_BUILD => 1,
    PRE_HEAD => "$testdir/prehead.in";

use Inline C => <<'EOC';

int foo() {
    return EXTRA_DEFINE;
}

EOC

my $def = foo();

if($def == 1234) {
  print "ok 1\n";
}
else {
  warn "\n Expected: 1234\n Got: $def\n";
  print "not ok 1\n";
}
