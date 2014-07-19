use File::Spec;
use strict;
use diagnostics;
use Config;
use File::Basename;
use lib dirname(__FILE__);
use TestInlineSetup;
use Inline Config => DIRECTORY => $TestInlineSetup::DIR;

print "1..1\n";

use Inline C => Config =>
    #BUILD_NOISY => 1,
    USING => 'ParseRegExp',
    PREFIX => 'MY_PRE_';

use Inline C => << 'EOC';

int bar() {
    return 42;
}

int MY_PRE_foo(void) {
    int x = bar();
    return x;
}

EOC

if(42 == foo()) {print "ok 1\n"}
else {print "not ok 1\n"}
