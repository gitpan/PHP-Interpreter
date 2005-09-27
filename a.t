#!/opt/ecelerity/3rdParty/bin/perl -w
use strict;
use Test::More tests => 14;

BEGIN {
    diag "Testing Output Buffering";
    use_ok 'PHP::Interpreter' or die;
}

my $output = '';
my $data;
ok my $p = PHP::Interpreter->new({
    'BRIC' => { 'special' => 'data', },
    'OUTPUT' => \$output
}), "Create new PHP interpreter";
$p->eval(q/print $BRIC['special'];/);
$p->eval(q/print $BRIC['special'];/);
$p->eval(q/print $BRIC['special'];/);
$p->eval(q/print $BRIC['special'];/);
$p->eval(q/print $BRIC['special'];/);
$p->eval(q/print $BRIC['special'];/);
$p->eval(q/print $BRIC['special'];/);

