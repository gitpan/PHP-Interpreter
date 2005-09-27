use PHP::Interpreter;
use Data::Dumper;

my $p = PHP::Interpreter->new;

my $php = <<'EOPHP';
function print_object($obj)
{
      echo "PERL ARRAY: " . $obj->parray[1] ."\n";
      echo "PERL HASH: " . $obj->phash["foo"] ."\n";
}
function property_access($obj, $prop)
{
#  $obj->add_in_php = 10;
  return $obj->$prop;
}

function method_call($obj, $meth)
{

  return $obj->$meth() * 10;
}

function props_as_array($obj)
{
  $rv = array();
  foreach($obj as $k => $v) {
    $rv[$k] = $v;
  }
  return $rv;
}

function segfault_me($obj) {
    echo $obj->test . "\n";
    echo "Read OK .. writing to the propery segfaults:\n";
    $obj->test = 2;

}

EOPHP

$p->eval($php);

my $foo = new Foo();
$foo->{bar} = 'apsomdmaposbar';
$foo->{baz} = 'baz';

print $p->get_class($foo);
print  $p->property_access($foo, 'bar');
print $p->method_call($foo, 'get');

print "\n";
$p->print_object($foo);

print Dumper $p->props_as_array($foo);

$p->segfault_me($foo);

package Foo;

sub new {
  my $self = shift;
  my $class = ref($self) || $self;
  bless {test => 1, parray => [1,2,3,4], phash => {foo => time}}, $class;
}

sub get {
  my ($self) = @_;
  return 10;
}

1;
