import json
import nltk

# Download necessary NLTK data files
nltk.download('brown')
nltk.download('universal_tagset')
nltk.download('averaged_perceptron_tagger_eng')

from nltk.corpus import brown

# Get words from the Brown Corpus, which is a compilation of general English
words = brown.words()

# Calculate word frequencies
word_freq = nltk.FreqDist(word.lower() for word in words)

# Get the most common words (adjust the number as needed, e.g., top 5000)
most_common_words = [word for word, freq in word_freq.most_common(5000)]

# Tag the words with their parts of speech
tagged_words = nltk.pos_tag(most_common_words, tagset='universal')

# Filter for nouns and verbs
common_nouns_verbs = [word for word, pos in tagged_words if pos in ('NOUN', 'VERB')]

# Save the list to a JSON file
with open('common_nouns_verbs.json', 'w') as f:
    json.dump(common_nouns_verbs, f)

print(f"Generated a JSON file with {len(common_nouns_verbs)} common nouns and verbs!")
