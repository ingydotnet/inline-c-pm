use strict; use warnings;
package TestInlineC;

BEGIN {
    $ENV{PERL_PEGEX_AUTO_COMPILE} = 'Inline::C::Parser::Pegex::Grammar';
}

use Test::More();
use YAML::XS;
use IO::All;

use Parse::RecDescent;
use Inline::C::Parser::RecDescent;

use Pegex::Parser;
use Inline::C::Parser::Pegex::Grammar;
use Inline::C::Parser::Pegex::AST;

use base 'Exporter';
our @EXPORT = qw(test);

use XXX;

sub test {
    my ($input, $label) = @_;
    my $prd_data = prd_parse($input);
    my $parser = Pegex::Parser->new(
        grammar => Inline::C::Parser::Pegex::Grammar->new,
        receiver => Inline::C::Parser::Pegex::AST->new,
        debug => $ENV{DEBUG} # || 1,
    );
    my $pegex_data = $parser->parse($input);
    my $prd_dump = Dump $prd_data;
    my $pegex_dump = Dump $pegex_data;

    $label = "Pegex matches PRD: $label";
    if ($pegex_dump eq $prd_dump) {
        Test::More::pass $label;
    }
    else {
        Test::More::fail $label;
        io->file('got')->print($pegex_dump);
        io->file('want')->print($prd_dump);
        Test::More::diag(`diff -u want got`);
        unlink('want', 'got');
    }

    ($prd_data, $pegex_data);
}

sub prd_parse {
    my ($input) = @_;
    my $grammar = Inline::C::Parser::RecDescent::grammar();
    my $parser = Parse::RecDescent->new( $grammar );
    $parser->code($input) or die;
    my $data = $parser->{data};
    my $functions = $data->{function};
    for my $name (keys %$functions) {
        for my $arg (@{$functions->{$name}{args}}) {
            delete $arg->{offset};
        }
    }
}

1;
