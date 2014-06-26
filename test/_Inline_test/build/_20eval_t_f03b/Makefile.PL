use ExtUtils::MakeMaker;
my %options = %{
{
  'VERSION' => '0.00',
  'TYPEMAPS' => [
    '/home/ingy/local/opt/plenv/versions/5.18.1/lib/perl5/5.18.1/ExtUtils/typemap',
    '/home/ingy/src/inline-pm/C/t/typemap'
  ],
  'NAME' => '_20eval_t_f03b',
  'CC' => 'missing_compiler',
  'INC' => '-I"/home/ingy/src/inline-pm/C/t"'
}
};
WriteMakefile(%options);

# Remove the Makefile dependency. Causes problems on a few systems.
sub MY::makefile { '' }
