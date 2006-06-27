# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Devel-Gladiator.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 1;
BEGIN { use_ok('Devel::Gladiator') };
use strict;
#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

use Devel::Peek;
my %hash;
for (1..10) {
        $hash{$_}++;
}

my $foo = "blah";

my $array = Devel::Gladiator::walk_arena();
foreach my $value (@$array) {
        next unless $value == \$foo;
#        next unless(ref($value) eq 'SCALAR');
#        Dump($value);
#        print $value . "\n";
}
Dump($array,1);
$array = undef;

#Dump($foo);