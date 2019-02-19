use warnings;
use Config;
BEGIN { use Cwd; $cwd = getcwd; };

#print 'in XXinclude_dirs_angle_brackets.t, have $cwd = ', q{'}, $cwd, q{'}, "\n";

use Inline C => Config => 
#    BUILD_NOISY => 1,
    FORCE_BUILD => 1,
    INC => "-I$cwd/test/test_header/";

use Inline C => <<'EOC';

#include <iquote_test.h>

int foo() { 
#if defined(DESIRED_HEADER)
  return 1;
#elif defined(NON_DESIRED_HEADER)
  return 0;
#else
  return -1;
#endif
}
EOC

print "1..1\n";

my $ret = foo();

#print 'in XXinclude_dirs_angle_brackets.t, have $ret = ', q{'}, $ret, q{'}, "\n";

if ($ret == 1) { print "ok 1\n"; } 
else { 
    if (($Config{osname} eq 'MSWin32') && ($Config{cc} =~ /\b(?:cl|icl)/) && ($ret == 0)) {
        warn "\nMS compiler loads the wrong header, as expected\n";
        print "not ok 1  # TODO somehow work around lack of '-iquote' and '-I-' options in MS compilers\n";
    }
    else {
        warn "foo() unexpectedly returned $ret\n";
        print "not ok 1\n";
    }
}
