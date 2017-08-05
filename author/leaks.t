use strict;
use warnings;
use Test::LeakTrace;
use Algorithm::AhoCorasick::XS;

my $matcher;

leaktrace{
    $matcher = Algorithm::AhoCorasick::XS->new(['a', 'b', 'c']);
    my @a = $matcher->matches("abc");
    print join(",", @a), "\n";
    undef $matcher;
} -verbose;

