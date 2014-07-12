use strict; use warnings;
package Inline::C::ParsePegex;

use Pegex::Parser;
use Inline::C::ParsePegex::Grammar;
use Inline::C::ParsePegex::AST;

sub register {
    {
        extends => [qw(C)],
        overrides => [qw(get_parser)],
    }
}

sub get_parser {
    Inline::C::_parser_test("Inline::C::ParsePegex::get_parser called\n")
        if $_[0]->{CONFIG}{_TESTING};
    bless {}, 'Inline::C::ParsePegex'
}

sub code {
    my($self,$code) = @_;

    $main::data = $self->{data} =
    Pegex::Parser->new(
        grammar => Inline::C::ParsePegex::Grammar->new,
        receiver => Inline::C::ParsePegex::AST->new,
        # debug => 1,
    )->parse($code);

    return 1;
}

1;
