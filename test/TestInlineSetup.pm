use strict; use warnings;
package TestInlineSetup;

use diagnostics;
use File::Path;

sub import {
    my ($package, $option) = @_;
    $option ||= '';
}

our $DIR;
BEGIN {
    ($_, $DIR) = caller(2);
    $DIR =~ s/.*?(\w+)\.t$/$1/ or die;
    $DIR = "_Inline_$DIR";
    rmtree($DIR) if -d $DIR;
    mkdir($DIR) or die;
}

END {
    rmtree($DIR);
}

1;
