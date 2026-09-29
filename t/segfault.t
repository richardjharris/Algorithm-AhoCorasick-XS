package Foo;

use strict;
use warnings;

use overload '""' => sub {
    my ($self) = @_;
    join( "", @$self );
};

sub new {
    my $class = shift;
    bless [ @_ ], $class;
}


package main;

use strict;
use warnings;

use Test::More 0.96;

use Algorithm::AhoCorasick::XS;

subtest "CVE-2026-80490 (object)" => sub {

    my $ac = Algorithm::AhoCorasick::XS->new( [ 11, 22 ] );

    my $obj = Foo->new(211);
    is "$obj", "211", "stringified";

    is $ac->first_match( $obj ) => 11;

};

subtest "CVE-2026-80490 (num)" => sub {

    my $ac = Algorithm::AhoCorasick::XS->new( [ 11, 22 ] );
    is $ac->first_match( 211 ) => 11;

};

done_testing;
