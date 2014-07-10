# XXX Remove this and test/00init.t and do it right.
use strict;
use Test;

use File::Path;

rmtree('_Inline');
rmtree('_Inline_test');
rmtree('_Inline_test21');
rmtree('_Inline_test22');

plan(tests => 1);
ok(1);
