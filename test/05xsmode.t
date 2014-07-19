BEGIN {
  if (exists $ENV{PERL_INSTALL_ROOT}) {
    warn "\nIgnoring \$ENV{PERL_INSTALL_ROOT} in $0\n";
    delete $ENV{PERL_INSTALL_ROOT};
  }
};
use File::Spec;
use strict;
use Test;
use diagnostics;
use File::Basename;
use lib dirname(__FILE__);
use TestInlineSetup;
use Inline Config => DIRECTORY => $TestInlineSetup::DIR;

BEGIN {
    plan(
        tests => 1,
        todo => [],
        onfail => sub {},
    );
}

use Inline C => DATA =>
           ENABLE => XSMODE =>
           NAME => 'xsmode';

# test 1
ok(add(5, 10) == 15);

__END__

__C__

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

MODULE = xsmode      PACKAGE = main

int
add (x, y)
        int     x
        int     y
    CODE:
        RETVAL = x + y;
    OUTPUT:
        RETVAL
