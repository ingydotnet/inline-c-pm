use strict; use warnings;
package TestInlineSetup;

use diagnostics;
use File::Path;
use File::Spec;

sub import {
    my ($package, $option) = @_;
    $option ||= '';
}

BEGIN {
  if (exists $ENV{PERL_INSTALL_ROOT}) {
    warn "\nIgnoring \$ENV{PERL_INSTALL_ROOT} in $0\n";
    delete $ENV{PERL_INSTALL_ROOT};
  }
  # Suppress "Set up gcc environment ..." warning.
  # (Affects ActivePerl only.)
  $ENV{ACTIVEPERL_CONFIG_SILENT} = 1;
}

our $DIR;
BEGIN {
    ($_, $DIR) = caller(2);
    $DIR =~ s/.*?(\w+)\.t$/$1/ or die;
    $DIR = "_Inline_$DIR.$$";
    rmtree($DIR) if -d $DIR;
    mkdir($DIR) or die "$DIR: $!\n";
}
my $absdir = File::Spec->rel2abs($DIR);

my $startpid = $$;
END {

  if($$ == $startpid) { # only when original process exits

    # On Windows we need to first unload the dll's we're about to clobber.
    # (Based on code found in ExtUtils::ParseXS)
    if ($^O eq 'MSWin32' and defined &DynaLoader::dl_unload_file) {
      my $match = $0;
      $match =~ s/\\/\//g;
      $match = '_' . (split /\//, $match)[-1];
      $match =~ s/\.(t|p)$//;
      for (my $i = 0; $i < @DynaLoader::dl_modules; $i++) {
        if ($DynaLoader::dl_modules[$i] =~
            /$match|\bxsmode\b|\bSoldier_|\bBAR_|\bBAZ_|\bFOO_|\bPROTO[1-4]_|\beval_/
            ) {
          DynaLoader::dl_unload_file($DynaLoader::dl_librefs[$i]);
        }
      }
    }
  rmtree($absdir) if $$ == $startpid;
  }
}

1;
