use File::Spec;
use strict;
use IPC::Cmd qw/run/;
use Config;
use Test::More;
use diagnostics;
use File::Basename;
use lib dirname(__FILE__);
use TestInlineSetup;
require version;
use File::Path;
use Cwd;
use File::Copy::Recursive qw(rcopy);
use autodie;

my ($example_modules_dir) = grep { -e } map {
  File::Spec->rel2abs(File::Spec->catdir($_, 'modules'))
} qw(eg example);

plan skip_all => "No 'example' or 'eg' directory." unless $example_modules_dir;
plan skip_all => "Not yet ported to MS Windows" if $^O =~ /MSWin32/i;
require Inline;
plan skip_all => "Inline version 0.64+ required for this."
  unless version->parse($Inline::VERSION) >= version->parse(0.64);

my $lib_dir = File::Spec->rel2abs('lib');
my $base_dir = File::Spec->rel2abs($TestInlineSetup::DIR);
my $src_dir = File::Spec->catdir($base_dir, 'src dir');
my $inst_dir = File::Spec->catdir($base_dir, 'instdir');
mkpath $inst_dir;

my $cwd = getcwd;
# loop the list of modules and try to build them.
for my $module (glob "$example_modules_dir/*") {
  rcopy $module, $src_dir or die "rcopy $module $src_dir: $!\n";
  chdir $src_dir;
  my $buffer = '';
  my $cmd = [$^X, "-I$lib_dir", 'Makefile.PL', "INSTALL_BASE=$inst_dir"];
  my @result = run(command => $cmd, verbose => 0, buffer => \$buffer);
  ok($result[0], "$module Makefile creation");
  diag $buffer unless $result[0];
  map { do_make($_) } qw(test install realclean);
  chdir $cwd;
  rmtree $src_dir;
}

sub do_make {
  my $target = shift;
  my $buffer = '';
  my $cmd = [$Config{make}, $target];
  my @result = run(command => $cmd, verbose => 0, buffer => \$buffer);
  ok($result[0], "make $target");
  diag $buffer unless $result[0];
}

done_testing;
