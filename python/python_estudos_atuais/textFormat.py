import pandas as pd
import nltk
#nltk.download('punkt_tab')
import spacy

reviews = pd.read_json("Digital_Music_5.json", lines = True)
review_text = reviews["reviewText"]
#######################################################################################################
#print(review_text)
#print(review_text.sample())
#######################################################################################################
review_text_sample = review_text.sample()
review_test_sample_str = str(review_text_sample)
#print(review_test_sample_str)
#######################################################################################################
#print(type(review_test_sample_str))
#######################################################################################################
sentences = nltk.sent_tokenize(review_test_sample_str)
#print(sentences)
#######################################################################################################
words = nltk.word_tokenize(review_test_sample_str)
#print(words)
#######################################################################################################
nlp = spacy.load("en_core_web_sm")
doc = nlp(review_test_sample_str)
#print(type(doc))
#######################################################################################################
for token in doc:
    print(token.text, token.pos_)