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
	walk_arena arena_ref_counts arena_table
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.01';
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

=pod

=head1 NAME

Devel::Gladiator - Walk Perl's arena

=head1 SYNOPSIS

	use Devel::Gladiator qw(walk_arena arena_ref_counts arena_table);

    my $all = walk_arena();

	foreach my $sv ( @$all ) {
		warn "live object: $sv\n";
	}

	warn arena_table(); # prints counts keyed by class

=head1 DESCRIPTION

L<Devel::Gladiator> iterate's Perl's internal memory structures and can be used
to enumerate all the currently live SVs.

This can be used to hunt leaks and to profile memory usage.

=head1 EXPORTS

=over 4

=item walk_arena

Returns an array reference containing all the live SVs.

=item arena_ref_counts

Returns a hash keyed by class and reftype of all the live SVs.

This is a convenient way to find out how many objects of a given class exist at
a certain point.

=item arena_table

Formats a string table based on C<arena_ref_counts> suitable for printing.

=back

=head1 COPYRIGHT AND LICENCE

Put the correct copyright and licence information here.

Copyright (C) 2006 by Artur Bergman

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.

=cute
