package Inline::C::ParsePegex;
use strict;

use Pegex::Grammar;
use Pegex::Compiler;
use Pegex::Parser;

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

    my $pegex_grammar = Pegex::Grammar->new(
        tree => Pegex::Compiler->new->compile($self->grammar)->tree,
    );

    $main::data = $self->{data} =
    Pegex::Parser->new(
        grammar => $pegex_grammar,
        receiver => Inline::C::ParsePegex::AST->new,
        debug => 1,
    )->parse($code);

    return 1;
}

sub grammar {
    <<'...';

code: part+

part:
| comment
  | function_definition
  | function_declaration
  | anything_else

comment:
    /- SLASH SLASH [^ BREAK ]* BREAK / |
    /- SLASH STAR (: [^ STAR ]+ | STAR (! SLASH))* STAR SLASH ([ TAB ]*)? /

function_definition:
    rtype /( identifier )/
    LPAREN arg* % COMMA /- RPAREN - LCURLY -/

function_declaration:
    rtype /( identifier )/
    LPAREN arg_decl* % COMMA /- RPAREN - SEMI -/

rtype: / WS*(: rtype1 | rtype2 ) WS* /

rtype1: / modifier*( type_identifier ) WS*( STAR*) /

rtype2: / modifier+ STAR*/

arg: /(: type WS*( identifier)|( DOT DOT DOT ))/

arg_decl: /( type WS* identifier*| DOT DOT DOT )/

type: / WS*(: type1 | type2 ) WS* /

type1: / modifier*( type_identifier ) WS*( STAR* )/

type2: / modifier* STAR* /

modifier: /(: (:unsigned|long|extern|const)\b WS* )/

identifier: /(: WORD+ )/

type_identifier: /(: WORD+ )/

anything_else: / ANY* EOL /

...
}

package Inline::C::ParsePegex::AST;

use parent 'Pegex::Receiver';

sub initialize {
    my ($self) = @_;
    my $data = {
        functions => [],
        function => {},
        done => {},
    };
    $self->data($data);
}

sub got_function_definition {
    my ($self, $ast) = @_;
    my ($rtype, $name, $args) = @$ast;
    my ($rname, $rstars) = @$rtype;
    my $data = $self->data;
    my $def = $data->{function}{$name} = {};
    push @{$data->{functions}}, $name;
    $def->{return_type} = $rname . ($rstars ? " $rstars" : '');
    $def->{arg_names} = [];
    $def->{arg_types} = [];
    for my $arg (@$args) {
        my ($type, $stars, $name) = @$arg;
        push @{$def->{arg_names}}, $name;
        push @{$def->{arg_types}}, $type . ($stars ? " $stars" : '');
    }
    $data->{done}{$name} = 1;
    return;
}


sub got_arg {
    my ($self, $ast) = @_;
    pop @$ast;
    return $ast;
}

1;

__DATA__

=head1 NAME

Inline::C::ParsePegex - Yet Another Inline::C Parser

=head1 SYNOPSIS

    use Inline C => DATA =>
               USING => ParsePegex;

=head1 DESCRIPTION

This is another version of Inline::C's parser. It is based on Pegex.

=head2 AUTHOR

Ingy döt Net <ingy@ingy.net>

=head1 COPYRIGHT

Copyright (c) 2002. Brian Ingerson.

Copyright (c) 2008, 2010-2012. Sisyphus.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
