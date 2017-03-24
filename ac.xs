#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

#include "ppport.h"

#undef do_open
#undef do_close

#include "ac.hpp"

typedef AhoCorasick::Matcher AhoCorasick__Matcher;
typedef AhoCorasick::match AhoCorasick__match;

using std::vector;
using std::string;

MODULE = Algorithm::AhoCorasick::XS  PACKAGE = Algorithm::AhoCorasick::XS

PROTOTYPES: ENABLE

AhoCorasick::Matcher *
AhoCorasick::Matcher::new(vector<string> keywords)

void
AhoCorasick::Matcher::DESTROY()

vector<string>
AhoCorasick::Matcher::first_match(string input)

vector<string>
AhoCorasick::Matcher::matches(string input)

vector<AhoCorasick::match>
AhoCorasick::Matcher::match_details(string input)
