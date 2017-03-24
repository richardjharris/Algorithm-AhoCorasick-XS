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

=cut
