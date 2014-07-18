use strict; use warnings;
package Inline::C::Parser::Pegex;

use Pegex::Parser;
use Inline::C::Parser::Pegex::Grammar;
use Inline::C::Parser::Pegex::AST;

sub register {
    {
        extends => [qw(C)],
        overrides => [qw(get_parser)],
    }
}

sub get_parser {
    Inline::C::_parser_test("Inline::C::Parser::Pegex::get_parser called\n")
        if $_[0]->{CONFIG}{_TESTING};
    bless {}, 'Inline::C::Parser::Pegex'
}

sub code {
    my ($self, $code) = @_;

    $main::data = $self->{data} =
    Pegex::Parser->new(
        grammar => Inline::C::Parser::Pegex::Grammar->new,
        receiver => Inline::C::Parser::Pegex::AST->new,
        # debug => 1,
    )->parse($code);

    return 1;
}

1;
