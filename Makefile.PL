use ExtUtils::MakeMaker;
use Config;
use File::Spec::Functions qw(catfile catdir);

my $phpdir = shift @ARGV || ($^O eq 'MSWin32' ? 'C:\\php' : '/usr/local');

print "using phpdir $phpdir\n";

my $phpconfig = catfile $phpdir, 'bin', 'php-config';

my @lddlflags = ($Config{lddlflags});
my $php_lddlflags = `$phpconfig --ldflags`;
chomp $php_lddlflags;
push @lddlflags, $php_lddlflags;

my $inc = "-I" . catdir ($phpdir, 'include') . " ".`$phpconfig --includes`;
push @lddlflags , "-L" . catdir $phpdir, "lib";
my $php_embedlib_path = "-L" . catdir $phpdir, "lib";
push @lddlflags , $php_embedlib_path;
my @libs = ("$php_embedlib_path -lphp5");

my @ofiles = ('PHP.o', 'phpinterp.o', 'phpfuncs.o');

WriteMakefile(
    CCFLAGS      => '-g',
    OBJECT       => join(' ', @ofiles),
    NAME         => 'PHP::Interpreter',
    LIBS         => join(' ', @libs),
    LDDLFLAGS    => join(' ', @lddlflags),
    INC          => $inc,
    VERSION_FROM => 'lib/PHP/Interpreter.pm',
    PREREQ_PM    => {
        # Just required for testing.
        Test::More => 0,
        IO::File   => 0
      },
);
