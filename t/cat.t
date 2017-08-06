use strict;
use warnings;
use Test::More 0.96;

use Algorithm::AhoCorasick::XS;

my $matcher = Algorithm::AhoCorasick::XS->new(['sofa', 'fax', 'cat', 'attribute']);
my @a = $matcher->matches('a sofa is not a cattribute');
is_deeply( \@a, ['sofa', 'cat', 'attribute'] );
done_testing;
