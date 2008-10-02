#!/usr/bin/perl

# this module runs if padwalker is installed
# it tests getting data through padwalker that is has found on the arena

use Test::More;
use Devel::Peek;
use Data::Dumper;
my $has_padwalker = eval "use PadWalker qw(peek_sub closed_over); 1";

if($has_padwalker) {
    plan tests => 6;
} else {
    plan skip_all => "No PadWalker installed";
}

use_ok("Devel::Gladiator");


{
    my $outer = "outer";
    my %bar;
    $bar{baz} = "baz";
    sub blah {
        my $foo = "foo";
        my $bar = "bar";
        $bar{foz} = "foz";

        return bless sub { $foo . $bar . $outer . $bar{baz}} , "Dummy";
    }


}

my $sub1 = blah();

{
    my $array = Devel::Gladiator::walk_arena();
    foreach my $value (@$array) {
        next unless ref ($value) eq 'Dummy';
        my $peek_sub = peek_sub($value);

        is(${$peek_sub->{'$foo'}}, "foo");
        is(${$peek_sub->{'$outer'}}, "outer"); # used to be testing for 'undef', but it's a closure var, should be refcnt = 2 (one in Dummy, one in sub blah)
        is(${$peek_sub->{'$bar'}}, "bar");
        is($peek_sub->{'%bar'}->{baz}, "baz");
        is($peek_sub->{'%bar'}->{foz}, "foz");


        last;
    }
    $array = undef;
}

1;
