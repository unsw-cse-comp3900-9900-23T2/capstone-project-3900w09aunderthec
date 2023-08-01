import gensim
import sys
import re
import math

stopwords = set(['i', 'me', 'my', 'myself', 'we', 'our', 'ours', 'ourselves', 'you', 'your', 'yours', 'yourself', 'yourselves', 'he', 'him', 'his', 'himself', 'she', 'her', 'hers', 'herself', 'it', 'its', 'itself', 'they', 'them', 'their', 'theirs', 'themselves', 'what', 'which', 'who', 'whom', 'this', 'that', 'these', 'those', 'am', 'is', 'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had', 'having', 'do', 'does', 'did', 'doing', 'a', 'an', 'the', 'and', 'but', 'if', 'or', 'because', 'as', 'until', 'while', 'of', 'at', 'by', 'for', 'with', 'about', 'against', 'between', 'into', 'through', 'during', 'before', 'after', 'above', 'below', 'to', 'from', 'up', 'down', 'in', 'out', 'on', 'off', 'over', 'under', 'again', 'further', 'then', 'once', 'here', 'there', 'when', 'where', 'why', 'how', 'all', 'any', 'both', 'each', 'few', 'more', 'most', 'other', 'some', 'such', 'no', 'nor', 'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very', 's', 't', 'can', 'will', 'just', 'don', 'should', 'now'])
kvecs = gensim.models.keyedvectors.KeyedVectors.load('PythonScripts/T50KeyedVectors')

def prep(text):
    text = text.lower()
    text = re.sub(r"[^a-z]", ' ', text) # Remove nonalphabetic symbols
    text = re.sub(r" +", ' ', text) # Excess whitespace removal
    wordList = text.split(' ')

    for word in wordList:
        if (word in stopwords or word not in kvecs):
            wordList.remove(word)

    return wordList

if __name__ == "__main__":
    event1Str = sys.stdin.readline().strip()
    event2Str = sys.stdin.readline().strip()

    # wmdistance evaluates the dissimilarity between the texts via optimal transport between their embedding 
    # spaces, while the enclosing function appropriately maps and scales its output to a desirable distribution
    sys.stdout.write(str(math.tanh(0.15/(kvecs.wmdistance(prep(event1Str), prep(event2Str))**6+0.01))))
