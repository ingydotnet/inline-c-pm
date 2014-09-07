use Test::More;

use lib -e 't' ? 't' : 'test';
use TestInlineC;

test <<'...', 'Basic';
void foo(int a, int b) {
    a + b;
}
...

TODO: {
local $TODO = 'Failing tests for Pegex Parser';
test <<'...', 'Issue/27';
void _dump_ptr(long d1, long d2, int use_long_output) {
    printf("hello, world! %d %d %d\n", d1, d2, use_long_output);
}
...
}

done_testing;
