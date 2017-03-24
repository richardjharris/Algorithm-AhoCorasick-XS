use Test::More 0.96;
use Test::NoLeaks;
use Algorithm::AhoCorasick::XS;

test_noleaks (
    code => sub { my $matcher = Algorithm::AhoCorasick::XS->new(["a", "b", "ab", "abc", "cd", "ef", "af"]);
              undef $matcher;
            },
    track_memory => 1,
    passes => 10_000,
    warmup_passes => 1,
    tolerate_hits => 0,
);

my $matcher = Algorithm::AhoCorasick::XS->new(["a", "b", "ab", "abc", "cd", "ef", "af"]);

test_noleaks (
    code => sub { my @stuff = $matcher->matches("abefffghj");
              @stuff = ();
            },
    track_memory => 1,
    passes => 10_000,
    tolerate_hits => 0,
);

done_testing;
