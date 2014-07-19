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

plan(tests => 1,
     todo => [],
     onfail => sub {},
    );

use Inline C => Config =>
    USING => 'ParseRegExp';

use Inline C => <<'EOC';

void foo() {
     printf( "Hello World\n" );
}

void foo2() {
     Inline_Stack_Vars;
     int i;

     Inline_Stack_Reset;

     if(0) printf( "Hello World again\n" ); /* tests balanced quotes bugfix */

     for(i = 24; i < 30; ++ i) Inline_Stack_Push(sv_2mortal(newSViv(i)));

     Inline_Stack_Done;
     Inline_Stack_Return(6);
}

EOC

my @z = foo2();

ok(scalar(@z) == 6);

