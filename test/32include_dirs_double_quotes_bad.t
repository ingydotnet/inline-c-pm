use strict;
use warnings;
use diagnostics;
use FindBin '$Bin';
use lib $Bin;
use TestInlineSetup;
use Config;
use Inline Config => DIRECTORY => $TestInlineSetup::DIR;

print "1..1\n";

my $eval_string = q{
use Inline C => Config =>
    #BUILD_NOISY => 1,
    FORCE_BUILD => 1,
    CCFLAGS     => $Config{ccflags};

# DEV NOTE: do not actually test CPPFLAGS effect on Inline::Filters here,
# only test the ability to pass CPPFLAGS argument through Inline::C;
# see t/Preprocess_cppflags.t in Inline::Filters for real tests
use Inline C => <<'END' => CPPFLAGS => ' -DPREPROCESSOR_DEFINE';
#include "stdio.h"
int foo() { return 4321; }
END
};

#print 'BEFORE eval(), have $eval_string = ', "\n", '[[[ BEGIN $eval_string ]]]', "\n", $eval_string, "\n", '[[[ END $eval_string ]]]', "\n";

eval $eval_string;

#print 'AFTER eval(), have $@ = ', "\n", '[[[ BEGIN $@ ]]]', "\n", $@, "\n", '[[[ END $@ ]]]', "\n";

# GCC error messages, not found w/ other compilers
#my $expected_error_0 = 'PURPOSEFUL COMPILERERROR FOUND!';
#my $expected_error_1 = 'A problem was encountered while attempting to compile and install your Inline';
#my $expected_error_2 = 'C code. The command that failed was:';
##my $expected_error_3 = '"make" with error code 2';                  # when BUILD_NOISY is  enabled
#my $expected_error_3 = '"make > out.make 2>&1" with error code 2';  # when BUILD_NOISY is disabled

# generic error messaages, should work w/ any compiler
my $expected_error_0 = 'error';
my $expected_error_1 = 'COMPILERERROR';

if (($@ =~ m/$expected_error_0/) and
    ($@ =~ m/$expected_error_1/)) {
    print "ok 1\n";
}
else {
    warn "\nExpected:\n[[[ BEGIN EXPECTED ERRORS ]]]\n$expected_error_0\n$expected_error_1\n[[[ END EXPECTED ERRORS ]]]\n";
    warn "\nGot:\n[[[ BEGIN RECEIVED ERRORS ]]]\n$@\n[[[ END RECEIVED ERRORS ]]]\n";
    print "not ok 1\n";
}

#my $foo_retval = foo();  # does not work due to PURPOSEFUL COMPILER ERROR in non-standard "stdio.h" file

#if ( $foo_retval == 4321 ) {
#    print "ok 1\n";
#}
#else {
#    warn "\n Expected: 4321\n Got: $foo_retval\n";
#    print "not ok 1\n";
#}
