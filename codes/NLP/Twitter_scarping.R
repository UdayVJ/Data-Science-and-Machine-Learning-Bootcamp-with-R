# Natural Language Processing
# # 
# install.packages('tm')
# install.packages('twitteR')
# install.packages('wordcloud')
# install.packages('RColorBrewer')
# install.packages('e1017')
# install.packages('curl')


install.packages(c("devtools", "rjson", "bit64", "httr"))

library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)
#Connect to twitter 

##authentication
setup_twitter_oauth(ckey, skey,token,sectoken)
##returning tweets
soccer.tweets <- searchTwitter("Modi",n=1000,lang="en")
### Grabing Text from tweets
soccer.text <- sapply(soccer.tweets,function(x) x$getText())


#####cleam=n the data
soccer.text <- iconv(soccer.text, 'UTF-8', 'ASCII') # remove emoticons
soccer.corpus <- Corpus(VectorSource(soccer.text)) # create a corpus

# Create a Document Term Matrix
# We'll apply some transformations using the TermDocumentMatrix Function

term.doc.matrix <- TermDocumentMatrix(soccer.corpus,
      control = list(removePunctuation = TRUE,stopwords = c("Modi","http", stopwords("english")),
      removeNumbers = TRUE,tolower = TRUE))

# converting object into matrix
term.doc.matrix <- as.matrix(term.doc.matrix)

# getting word count
word.freqs <- sort(rowSums(term.doc.matrix), decreasing=TRUE) 
dm <- data.frame(word=names(word.freqs), freq=word.freqs)

# Creating wordcloud

wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))