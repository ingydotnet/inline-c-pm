use strict; use warnings;
use lib -e 't' ? 't' : 'test';
use TestInlineSetup;
use Test::More;
use Config;
use Inline Config => DIRECTORY => $TestInlineSetup::DIR;

if($^O =~ /MSWin32/i) {
  plan skip_all => 'fork() not implemented' if $Config{useithreads} ne 'define';
  plan skip_all => 'Hangs on WinXP'
    if eval { require Win32; Win32::GetOSName() =~ /^WinXP/ };
}

my $pid = fork;
eval { Inline->bind(C => 'int add(int x, int y) { return x + y; }'); };
exit 0 unless $pid;

wait;
is($?, 0, 'child exited status 0');

TODO: {
  local $TODO;
  $TODO = "Generally fails on MS Windows" if $^O =~ /MSWin32/i;
  is $@, '', 'bind was successful';
  my $x = eval { add(7,3) };
  is $@, '', 'bound func no die()';
  is $x, 10, 'bound func gave right result';
}

done_testing;
