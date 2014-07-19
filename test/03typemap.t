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

my $testdir;
BEGIN {
    $testdir = -d 'test' ? 'test' : 't';
}

use Inline C => DATA =>
           TYPEMAPS => File::Spec->catfile(File::Spec->curdir(), $testdir, 'typemap');

# test 1
ok(int((add_em_up(1.2, 3.4) + 0.001) * 10) == 46);

__END__

__C__

float add_em_up(float x, float y) {
    return x + y;
}
