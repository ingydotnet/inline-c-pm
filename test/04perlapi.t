use File::Spec;
use strict;
use Test::More;
use diagnostics;
use File::Basename;
use lib dirname(__FILE__);
use TestInlineSetup;
use Inline Config => DIRECTORY => $TestInlineSetup::DIR;

use Inline 'C';

$main::myvar = $main::myvar = "myvalue";
is(lookup('main::myvar'), "myvalue");
done_testing;

__END__
__C__
SV* lookup(char* var) { return perl_get_sv(var, 0); }
