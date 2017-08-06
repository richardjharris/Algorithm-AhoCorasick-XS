#include "Matcher.hpp"
#include "Trie.hpp"
#include <queue>

using std::vector;

namespace AhoCorasick {
    Matcher::Matcher(const vector<string> & keywords)
    : words(keywords) {
        build();
    }

    vector<string> Matcher::first_match(const string& input) const {
        vector<match> matches = search(input, true);
        return matches.empty() ? vector<string>({}) : vector<string>({ matches[0].keyword });
    }

    vector<string> Matcher::matches(const string& input) const {
        vector<match> matches = search(input, false);
        vector<string> s;
        for (match m: matches) {
            s.push_back(m.keyword);
        }
        return s;
    }

    vector<match> Matcher::match_details(const string& input) const {
        return search(input, false);
    }

    Matcher::~Matcher() {
        delete root;
    }

    // root is a tree, provided we ignore a) references back to the root
    //   and b) the fail pointer
    void Matcher::cleanup(Trie *node) {
        delete root;
        for (unsigned int i = 0; i < 256; i++) {
            Trie *child = node->children[i];
            if (child != root && child != nullptr) {
                cleanup(child);
            }
            //if (node->next) {
            //    cleanup(node->next);
            //}
        }
        delete node;
    }

    void Matcher::build() {
        root = new Trie();
        int i = 0;

        // 1. Build the keyword tree
        for (string& word : words) {
            Trie *node = root->add_word(word);
            node->out.push_back(i);
            i++;
        }

        // 2. Complete goto function for root
        //    Set g(root,a) = root for any a that isn't defined
        for (unsigned int i = 0; i < 256; i++) {
            if (root->children[i] == nullptr) {
                root->children[i] = root;
            }
        }

        // 3. Compute fail and output for all nodes, in breadth-first order
        std::queue<Trie *> queue;
        for (unsigned int i = 0; i < 256; i++) {
            Trie *q = root->children[i];
            if (q != root) {
                q->fail = root;
                queue.push(q);
            }
        }

        while (queue.size()) {
            Trie *r = queue.front();
            queue.pop();
            for (unsigned int i = 0; i < 256; i++) {
                Trie *u = r->children[i];
                if (u != nullptr) {
                    queue.push(u);
                    Trie *v = r->fail;
                    while (v->children[i] == nullptr) {
                        v = v->fail;
                    }
                    u->fail = v->children[i];

                    u->out.insert( u->out.end(), u->fail->out.begin(), u->fail->out.end() );
                }
            }
        }
    }

    vector<match> Matcher::search(const string& text, bool stopAfterOne) const {
        Trie *q = root;
        vector <match> matches;
        size_t position = 0;
        for (const unsigned char ch : text) {
            // If it doesn't match, follow the fail links
            while (q->children[ch] == nullptr) {
                // Follow fails.
                // If nothing else, this will succeed once q = root, as fail is defined
                // for all characters.
                q = q->fail;
            }
            // We matched, so follow the goto link (may be root)
            q = q->children[ch];
            for (int matchOffset : q->out) {
                matches.push_back( {
                    words[matchOffset],
                    position - words[matchOffset].size() + 1,
                    position,
                } );
                if (stopAfterOne) {
                    return matches;
                }
            }
            position++;
        }

        return matches;
    }
}
