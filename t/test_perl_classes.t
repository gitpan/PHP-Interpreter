#!/opt/ecelerity/3rdParty/bin/perl -w
use strict;
use Test::More tests => 10;
use Test::Builder;
use IO::File;

BEGIN {
    use_ok 'PHP::Interpreter' or die;
}

ok my $php = PHP::Interpreter->new, "Create new PHP interpreter";

## Try using a pure Perl class.
ok $php->eval(q/
    $perl = Perl::getInstance();
    $test = $perl->new('Test::Builder');
    return $test->ok(1, "This test should run from PHP!");
/), "The test should have passed and returned a true value";

# Try using an XS module.
sub file {  __FILE__ }
ok my $ret = $php->eval(q^
    $perl = Perl::getInstance();
    $file = $perl->call('file');
    $fh = $perl->new("IO::File", "<$file");
    if ($fh) {
	return $fh->getline();
    } else {
        throw new Exception("Couldn't open $file");
    }
^), "We should get a value back from the file";
like $ret, qr/^#\!.*perl\s+-w$/, "We should have a shebang line";

# Make sure that call() works on class methods, too.
ok $ret = $php->eval(q^
    $perl = Perl::getInstance();
    $file = $perl->call('file');
    $fh = $perl->call("IO::File::new", "IO::File", "<$file");
    if ($fh) {
	return $fh->getline();
    } else {
        throw new Exception("Couldn't open $file");
    }
^), "We should get a value back from the file";
like $ret, qr/^#\!.*perl\s+-w$/, "We should have a shebang line";


# Make sure that eval() works on class methods, too.
ok $ret = $php->eval(q^
    $perl = Perl::getInstance();
    $file = $perl->call('file');
    $fh = $perl->eval("return IO::File->new(\"<$file\");");
    if ($fh) {
	return $fh->getline();
    } else {
        throw new Exception("Couldn't open $file");
    }
^), "We should get a value back from the file";
like $ret, qr/^#\!.*perl\s+-w$/, "We should have a shebang line";
