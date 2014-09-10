use strict; use warnings;
use lib (-e 't' ? 't' : 'test'), 'inc', 'pkg/inc';
use TestML;
use TestInlineCBridge;

TestML->new(
    testml => do { local $/; <DATA> },
    bridge => 'TestInlineCBridge',
)->run;

__DATA__
%TestML 0.1.0

Title = 'Rigorous function definition and declaration tests not yet passing.'

Diff = 1

Label = "(RecDescent) $BlockLabel"
*code.parse_recdescent.dump == *want
Label = "(RegExp) $BlockLabel"
*code.parse_regexp.dump == *want
Label = "(Pegex) $BlockLabel"
*code.parse_pegex.dump == *want

=== Basic def
--- code
void foo(int a, int b) {
    a + b;
}
--- want
foo:
  arg_names:
  - a
  - b
  arg_types:
  - int
  - int
  return_type: void

=== Basic decl
--- code
void foo(int a, int b);
--- want
foo:
  arg_names:
  - a
  - b
  arg_types:
  - int
  - int
  return_type: void

=== Basic decl, no identifiers
--- TODO
--- code
void foo(int,int);
--- want
foo:
  arg_names:
  - arg1
  - arg2
  arg_types:
  - int
  - int
  return_type: void

=== char* param
--- code
void foo(char* ch) {
}
--- want
foo:
  arg_names:
  - ch
  arg_types:
  - char *
  return_type: void

=== char* param decl
--- code
void foo(char* ch);
--- want
foo:
  arg_names:
  - ch
  arg_types:
  - char *
  return_type: void

=== char * decl
--- code
void foo(char *);
--- want
foo:
  arg_names:
  - arg1
  arg_types:
  - char *
  return_type: void

=== char *param
--- code
void foo(char *ch) {
}
--- want
foo:
  arg_names:
  - ch
  arg_types:
  - char *
  return_type: void

=== char** param
--- code
void foo( char** ch ) {
}
--- want
foo:
  arg_names:
  - ch
  arg_types:
  - char **
  return_type: void

=== char* rv, char* param
--- code
char* foo(char* ch) {
  return ch;
}
--- want
foo:
  arg_names:
  - ch
  arg_types:
  - char *
  return_type: char *

=== const char*
--- TODO
--- code
const char* foo(const char* ch) {
  return ch;
}
--- want
foo:
  arg_names:
  - ch
  arg_types:
  - const char *
  return_type: const char *

=== char* const param
--- TODO
--- code
char* const foo(char * const ch ) {
  return ch;
}
--- want
foo:
  arg_names:
  - ch
  arg_types:
  - char *
  return_type: char *

=== const char* const param
--- code
const char* const foo(const char* const ch) {
  return ch;
}
--- want
foo:
  arg_names:
  - ch
  arg_types:
  - char *
  return_type: char *

=== const char* const no-id decl
--- code
const char * const foo( const char * const);
--- want
foo:
  arg_names:
  - arg1
  arg_types:
  - char *
  return_type: char *

=== long int
--- code
long int foo( long int a ) {
  return a + a;
}
--- want
foo:
  arg_names:
  - a
  arg_types:
  - long int
  return_type: long int

=== long long
--- code
long long foo ( long long a ) {
  return a + a;
}
--- want
foo:
  arg_names:
  - a
  arg_types:
  - long long
  return_type: long long

=== long long int
--- code
long long int foo ( long long int a ) {
  return a + a;
}
--- want
foo:
  arg_names:
  - a
  arg_types:
  - long long int
  return_type: long long int

=== unsigned long long int
--- code
unsigned long long int foo ( unsigned long long int abc ) {
  return abc + abc;
}
--- want
foo:
  arg_names:
  - abc
  arg_types:
  - unsigned long long int
  return_type: unsigned long long int

=== unsigned long long int decl no-id
--- code
unsigned long long int foo( unsigned long long int );
--- want
foo:
  arg_names:
  - arg1
  arg_types:
  - unsigned long long int
  return_type: unsigned long long int

=== unsigned long long decl no-id
--- code
unsigned long long foo(unsigned long long);
--- want
foo:
  arg_names:
  - arg1
  arg_types:
  - unsigned long long
  return_type: unsigned long long

=== unsigned int
--- code
unsigned int _foo ( unsigned int abcd ) {
  return abcd + abcd;
}
--- want
_foo:
  arg_names:
  - abcd
  arg_types:
  - unsigned int
  return_type: unsigned int

=== unsigned long
--- code
unsigned long _bar1( unsigned long abcd ) {
  return abcd + abcd;
}
--- want
_bar1:
  arg_names:
  - abcd
  arg_types:
  - unsigned long
  return_type: unsigned long

=== unsigned
--- code
unsigned baz2(unsigned abcd) {
  return abcd+abcd;
}
--- want
baz2:
  arg_names:
  - abcd
  arg_types:
  - unsigned
  return_type: unsigned

=== unsigned decl no-id
--- code
unsigned baz2(unsigned);
--- want
baz2:
  arg_names:
  - arg1
  arg_types:
  - unsigned
  return_type: unsigned

=== Issue/27
--- code
void _dump_ptr(long d1, long d2, int use_long_output) {
    printf("hello, world! %d %d %d\n", d1, d2, use_long_output);
}
--- want
_dump_ptr:
  arg_names:
  - d1
  - d2
  - use_long_output
  arg_types:
  - long
  - long
  - int
  return_type: void

