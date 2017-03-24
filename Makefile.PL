use v5.8.8;
use ExtUtils::MakeMaker;

$CC = "g++";

WriteMakefile(
    NAME         => "Algorithm::AhoCorasick::XS",
    VERSION_FROM => "lib/Algorithm/AhoCorasick/XS.pm",
    PREREQ_PM    => { 'Test::More' => 0.96 },
    TYPEMAPS     => ['perlobject.map', 'typemap'],
    CC           => $CC,
    LD           => '$(CC)',
    XSOPT        => '-C++',
    CCFLAGS       => '-Wall -std=c++11',
    OBJECT       => '$(O_FILES)',
    #XS           => { 'ac.xs' => 'ac.c' },
    # Force the makefile to be regenerated when the version is changed
    depend       => { '$(FIRST_MAKEFILE)' => '$(VERSION_FROM)' },
    # New keywords since 5.5
    ($] >= 5.005 ? (
      ABSTRACT   => 'Algorithm::AhoCorasick::XS',
      AUTHOR     => 'Richard Harris <richardjharris@gmail.com>',
    ) : ()),
);