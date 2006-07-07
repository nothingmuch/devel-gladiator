package Devel::Gladiator;

use 5.008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration       use Devel::Gladiator ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(

) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(

);

our $VERSION = '0.00_01';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;  # see L<perlmodstyle>

sub arena_ref_counts {
    my $all = Devel::Gladiator::walk_arena();
    my %ct;
    foreach my $it (@$all) {
        $ct{ref $it}++;
        if (ref $it eq "REF") {
            $ct{"REF-" . ref $$it}++;
        }
    }
    $all = undef;
    return \%ct;
}

sub arena_table {
    my $ct = arena_ref_counts();
    my $ret;
    $ret .= "ARENA COUNTS:\n";
    foreach my $k (sort {$ct->{$b} <=> $ct->{$a}} keys %$ct) {
        $ret .= sprintf(" %4d $k\n", $ct->{$k});
    }
    return $ret;
}

require XSLoader;
XSLoader::load('Devel::Gladiator', $XS_VERSION);

# Preloaded methods go here.

1;
__END__
