use strict;
use warnings;
use Test::More 0.96;

use String::Random;

use Algorithm::AhoCorasick::XS;

my $gen = String::Random->new;

subtest 'Character does not exist in input' => sub {
    my $matcher = Algorithm::AhoCorasick::XS->new(['x']);
    for my $i (1..10000) {
        my $str = $gen->randregex('\w+');
        $str =~ s/x//g;
        my @matches = $matcher->matches($str);
        is_deeply( \@matches, [] ) or diag("x\n$str");
    }
};

subtest 'Word exists in input' => sub {
    for my $i (1..10000) {
        my $needle = $gen->randregex('\w+');
        my $haystack = join '', map { $gen->randregex('\w+') } (1..10);

        my $insert_pos = int(rand(length $haystack)) - 1;

        substr($haystack, $insert_pos) = $needle;
        my $matcher = Algorithm::AhoCorasick::XS->new([$needle]);
        my $match = $matcher->first_match($haystack);
        is( $match, $needle ) or diag("$needle\n$haystack");
    }
};

done_testing;
