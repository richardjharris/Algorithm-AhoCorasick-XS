use strict;
use warnings;
use Test::More 0.96;

use Algorithm::AhoCorasick::XS;

subtest prefix => sub {
    my @words = (qw(
        w wo wor word p py pyt pyth pytho python
    ), "\0", "\0\0", "\0\0\0");
    my $matcher = Algorithm::AhoCorasick::XS->new(\@words);
    for my $word (@words) {
        ok( scalar $matcher->matches($word), "matches $word" );
    }
    is_deeply( [$matcher->matches('word')], [qw(w wo wor word)] );

    is_deeply( [$matcher->matches('wa')], ['w'] );
    is_deeply( [$matcher->matches('apple')], ['p', 'p'] );
    is_deeply( [$matcher->matches('pyTon')], ['p', 'py'] );
    is_deeply( [$matcher->unique_matches("\0\0\0\0")], ["\0", "\0\0", "\0\0\0"] );

    ok (!$matcher->matches('ard'));
};

subtest prefix_fail => sub {
    my $matcher = Algorithm::AhoCorasick::XS->new([qw(
        cat
        cata
        atari
        atarimae
    )]);
    my @a = $matcher->matches('ccatarimaec');
    is_deeply( \@a, ['cat', 'cata', 'atari', 'atarimae'] );

    @a = $matcher->matches('aatarimae');
    is_deeply( \@a, ['atari', 'atarimae'] );

    @a = $matcher->matches('cacatari');
    is_deeply( \@a, ['cat', 'cata', 'atari'] );
};

done_testing;
