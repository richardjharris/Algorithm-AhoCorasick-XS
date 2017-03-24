package Algorithm::AhoCorasick::XS;
use strict;
use warnings;
use List::MoreUtils qw(uniq);
require XSLoader;
our $VERSION = '0.01';
XSLoader::load('Algorithm::AhoCorasick::XS', $VERSION);

sub unique_matches {
    my ($self, $input) = @_;
    return uniq $self->matches($input);
}

1;

__END__

=head1 NAME

Algorithm::AhoCorasick::XS - fast Aho-Corasick multiple string matcher

=head1 SYNOPSIS

 my $ac = Algorithm::AhoCorasick::XS->new([qw(he she hers his)]);
 for my $match ($ac->match_details("ahishers")) {
     printf "Word %s appears from %d to %d\n", $match->{word}, $match->{start}, $match->{end}; 
 }
 # Outputs:
 # Word his appears from 1 to 3
 # Word she appears from 3 to 5
 # Word he appears from 4 to 5
 # Word hers appears from 4 to 7

 # I only care about the words matched
 my @words = $ac->matches($input);

 # I only care about the first match, if any
 my $first_match = $ac->first_match($input);

=head1 DESCRIPTION

Implements Aho-Corasick, which given an input string and a set of substrings, will
tell you which of those substrings are present in the input, and where.

Aho-Corasick matches all substrings at once, so no matter how many you have, it
runs in roughly linear time (proportional to the size of the input string + the sum
of sizes of all substrings + the number of matches).

=head1 MOTIVATION

The excellent L<Algorithm::AhoCorasick> is pure Perl, and roughly 100 times slower.
Other modules suffer from bugs (false negatives) when given overlapping substrings,
segfault, or won't tell you precisely which substrings matched.

=head1 FUNCTIONS

=over

=item new ( ARRAYREF_OF_SUBSTRINGS )

Constructs a matcher object given an arrayref of substrings. Builds the internal
automaton.

=item matches ( INPUT )

Given a string, returns a list of the substrings which are present in the input.
There may be duplicates if a substring occurs more than once.

=item unique_matches ( INPUT )

As above but runs C<uniq> on the list for you.

=item first_match ( INPUT )

Returns the first match only (or undef if none). This is efficient - the matcher
will stop once it encounters the first match, and the rest of the string will be
ignored.

=item match_details ( INPUT )

Returns a list of hashrefs, containing the keys C<word>, C<start> and C<end>.
These correspond to an occurence of a substring - the word, start and end offset
within the string.

=back

=cut
