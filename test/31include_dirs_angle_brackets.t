use warnings;
use Config;
BEGIN { use Cwd; $cwd = getcwd; };

use Test::More tests => 1;

#print 'in XXinclude_dirs_angle_brackets.t, have $cwd = ', q{'}, $cwd, q{'}, "\n";

use Inline C => Config => 
#    BUILD_NOISY => 1,
    FORCE_BUILD => 1,
    INC => "-I$cwd/t/test_header/";

use Inline C => <<'EOC';

#include <iquote_test.h>

int foo() { 
#if defined(DESIRED_HEADER)
  return 1;
#endif
  return 0;
}

EOC

my $ret = foo();

if(($Config{osname} eq 'MSWin32') && ($Config{cc} =~ /\b(?:cl|icl)/)) {

    TODO: {
           local $TODO = " handle lack of '-iquote' and '-I-' options in MS compilers\n";

           is($ret, 1, 'load correct header file');
    };
}

else {
    is($ret, 1, 'load correct header file');
}