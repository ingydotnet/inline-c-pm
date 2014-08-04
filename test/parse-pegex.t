use Test::More;

use lib -e 't' ? 't' : 'test';
use TestInlineC;

test <<'...', 'Function definition';

int add(int x, int y) {
    return x + y;
}

...

# test <<'...', 'Function declaration (type-only param)';
# int add ( int, int );
# ...
# 
# test <<'...', 'Function declaration (named param)';
# int foo ( int a );
# ...
# 
# test <<'...', 'Comment hides function';
# int foo ( int a );
# /* int bar ( int a ); */
# ...
# 
# test <<'...', 'Various comments';
# // int foo ( int a );
# /* int bar ( int a ); */
# // comment */ not ended
# // comment /* not started
# /*
# // */ int foo ( int a );
# ...

done_testing;
