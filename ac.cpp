#ifndef AHO_CORASICK_HPP
#define AHO_CORASICK_HPP

#include <string>
#include <vector>
#include <queue>
#include <memory>

using std::string;
using std::vector;

namespace Algorithm {
  // Number of characters in the input alphabet
  static constexpr int MAXCHARS = 256;

  struct trie {
    unsigned char label;
    trie *children[MAXCHARS] = {nullptr};
    // Extensions for AC automaton
    trie *fail = nullptr;
    vector<int> out;

    trie() : label('\0') {}
    trie(unsigned char label) : label(label) {}
  };

  class AhoCorasick {
    vector<string> words;
    trie *root;

    public:
      AhoCorasick(const vector<string> & keywords)
      : words(keywords) {
        build();
      }

      vector<string> first_match(const string& input) const {
        return search(input, true);
      }

      vector<string> matches(const string& input) const {
        return search(input, false);
      }

    private:
      void build();
      vector<string> search(const string& text, bool stopAfterOne) const;
  };

  void AhoCorasick::build() {
    root = new trie();
    int i = 0;

    // 1. Build the keyword tree
    for (string& word : words) {
        trie *node = root;
        // Follow the path labelled by root
        for (char& c : word) {
            unsigned char ch = c;

            if (!node->children[ch]) {
                node->children[ch] = new trie(ch);
            }
            node = node->children[ch];
        }
        node->out.push_back(i);
        i++;
    }

    // 2. Complete goto function for root
    //    Set g(root,a) = root for any a that isn't defined
    for (unsigned int i = 0; i < MAXCHARS; i++) {
        if (root->children[i] == nullptr) {
            root->children[i] = root;
        }
    }

    // 3. Compute fail and output for all nodes, in breadth-first order
    std::queue<trie *> queue;
    for (unsigned int i = 0; i < MAXCHARS; i++) {
        trie *q = root->children[i];
        if (q != root) {
            q->fail = root;
            queue.push(q);
        }
    }

    while (queue.size()) {
        trie *r = queue.front();
        queue.pop();
        for (unsigned int i = 0; i < MAXCHARS; i++) {
            trie *u = r->children[i];
            if (u != nullptr) {
                queue.push(u);
                trie *v = r->fail;
                while (v->children[i] == nullptr) {
                    v = v->fail;
                }
                u->fail = v->children[i];
                u->out.insert( u->out.end(), u->fail->out.begin(), u->fail->out.end() );
            }
        }
    }
  }

  vector<string> AhoCorasick::search(const string& text, bool stopAfterOne) const {
    trie *q = root;
    vector <string> matches;
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
            matches.push_back( words[matchOffset] ); 
            if (stopAfterOne) {
                return matches;
            }
        }
    }

    return matches;
  }
}

#endif

#include <iostream>

int main () {
  vector<string> keywords = { "he", "she", "hers", "his" };
  string text = "ahishers";

  auto ac = Algorithm::AhoCorasick(keywords);
  for ( string match : ac.matches(text) ) {
    std::cout << "Matched " << match << std::endl;
  }

  std::cout << std::endl;

  keywords = { "a", "fai" };
  text = "fa";
  ac = Algorithm::AhoCorasick(keywords);
  for ( string match : ac.matches(text) ) {
    std::cout << "Matched " << match << std::endl;
  }

  std::cout << std::endl;

  keywords = { "a", "ab", "bab", "bc", "bca", "c", "caa" };
  text = "abccab";
  ac = Algorithm::AhoCorasick(keywords);
  for ( string match : ac.matches(text) ) {
    std::cout << "Matched " << match << std::endl;
  }
}
