package
Math::Simple;
$VERSION = '1.23';

use base 'Exporter';
@EXPORT_OK = qw(add subtract);
use strict;

use Inline C => 'DATA', # you can change "C" to "Foo"
           VERSION => '1.23',
           NAME => 'Math::Simple';

1;

__DATA__
__Foo__
foo-sub foo-add { $_[0] + $_[1] }
foo-sub foo-subtract { $_[0] - $_[1] }
__C__
int add (int x, int y) {
    return x + y;
}

int subtract (int x, int y) {
    return x - y;
}
