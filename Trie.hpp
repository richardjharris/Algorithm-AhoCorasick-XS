#ifndef __AHOCORASICK_TRIE_INCLUDED__
#define __AHOCORASICK_TRIE_INCLUDED__

#include <vector>

namespace AhoCorasick {
    class Trie {
        public:

        unsigned char label;
        Trie *children[256] = {nullptr};

        // Extensions for AC automaton
        Trie *fail = nullptr;
        std::vector<int> out = std::vector<int>();

        Trie() : label('\0') {}
        Trie(unsigned char label) : label(label) {}
    };
}

#endif // __AHOCORASICK_TRIE_INCLUDED__
