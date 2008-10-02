#!/usr/bin/perl

use strict;
use Test::More tests => 6;
use Scalar::Util qw(weaken refaddr);
BEGIN { use_ok('Devel::Gladiator') };
use Devel::Peek;

my $found;
my $foo = "blah";

my $array = Devel::Gladiator::walk_arena();
ok($array, "walk returned");
is(ref $array, "ARRAY", ".. with an array");
$found = undef;
foreach my $value (@$array) {
    next unless refaddr($value) == refaddr(\$foo);
    $found = $value;
}
is($$found, $foo, 'found foo');
$array = undef;

# make a circular reference
my $ptr;
{
    my $foo = ["missing!"];
    my $bar = \$foo;
    $foo->[1] = $bar;
    $ptr = $foo;
    weaken($ptr);
}
ok($ptr, "foo went missing");

$array = Devel::Gladiator::walk_arena();
$found = undef;
foreach my $value (@$array) {
    next unless refaddr($value) == refaddr($ptr);
    $found = $value;
}
is($found->[0], "missing!", "found missing item");
$array = undef;
