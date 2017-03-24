use Test::More 0.96;
use strict;
use warnings;

use Algorithm::AhoCorasick::XS;

my $matcher = Algorithm::AhoCorasick::XS->new(['a', 'fai']);
my @a = $matcher->matches('fa');
is_deeply( \@a, ['a'] );

done_testing;
