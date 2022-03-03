use strict; use warnings; use diagnostics;
package TestInlineSetup;

use File::Spec;
use File::Temp 0.19;
use constant IS_WIN32 => $^O eq 'MSWin32' ;

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
    $DIR = File::Temp->newdir();
}

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
          my $ret; #on Win32, DLLs are ref counted by OS, the DLL may be
          do { # boot()ed from multiple psuedoforks, and have multiple refs
            $ret = DynaLoader::dl_unload_file($DynaLoader::dl_librefs[$i]);
          } while (IS_WIN32 && $ret); # so loop while refcount exhausted to force demapping
        }
      }
    }
  }
}

1;
