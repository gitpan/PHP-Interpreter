#!/opt/ecelerity/3rdParty/bin/perl -w
use strict;
use Test::More tests => 4;
 
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
