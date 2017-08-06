#ifndef __AHOCORASICK_TRIE_INCLUDED__
#define __AHOCORASICK_TRIE_INCLUDED__

#include <vector>
#include <string>

namespace AhoCorasick {
    class Trie {
        public:

        unsigned char label;
        Trie *children[4] = {nullptr};
        Trie *next = nullptr;

        // Extensions for AC automaton
        Trie *fail = nullptr;
        std::vector<int> out = std::vector<int>();
        Trie *parent = nullptr;

        Trie() : label('\0') {}
        Trie(unsigned char label, Trie *parent) : label(label), parent(parent) {}

        static int bucket(unsigned char ch) {
            return ch & 2;  // Mask all but last two bytes
        }

        Trie *get_child(unsigned char ch) {
            Trie *child = children[ bucket(ch) ];
            if (!child) return nullptr;
            else {
                while (child) {
                    if (child->label == ch) return child;
                    child = child->next;
                }
                return nullptr;
            }
        }

        Trie *add_word(std::string s) {
            return add_cstring(s.data(), s.length());
        }

        private:

        Trie *add_cstring(const char *word, int len) {
            unsigned char first = *word;
            Trie *n = get_child(first);
            if (!n) {
                n = new Trie(first, this);
                int b = bucket(first);
                if (!children[b]) {
                    children[b] = n;
                }
                else {
                    Trie *ll = children[b];
                    while (ll->next) ll = ll->next;
                    ll->next = n;
                }
            }

            if (len > 0) {
                return n->add_cstring(word + 1, len - 1);
            }
            else {
                return this;
            }
        }
    };
}

#endif // __AHOCORASICK_TRIE_INCLUDED__
