# get_clean_data.R
# extract, clean, and structure data for use in predictive text application
# 11 July 2019

# Start timer

        startTime <- proc.time()

# Load required software packages
        
        Sys.setenv(JAVA_HOME="C:/Program Files/Java/jre1.8.0_211/")
        library(caTools)
        library(dplyr)
        library(ggplot2)
        library(ngram)
        library(rJava)
        library(raster)
        library(readr)
        library(RWeka)
        library(stringi)
        library(tidyr)
        library(tm)

# Download and unzip .zip file from Coursera website
        
        url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
        download.file(url, "zipfile.zip")
        unzip("zipfile.zip", files = NULL, list = FALSE, overwrite = TRUE, junkpaths = FALSE, 
              exdir = ".", unzip = "internal", setTimes = FALSE)

# Copy English language .txt files into working directory
        
        file.copy("./final/en_US/en_US.blogs.txt", "./en_US.blogs.txt")
        file.copy("./final/en_US/en_US.news.txt", "./en_US.news.txt")
        file.copy("./final/en_US/en_US.twitter.txt", "./en_US.twitter.txt")

# Delete unused files
        
        unlink("./final", recursive = TRUE)
        unlink("zipfile.zip")

# Read English language .txt files into R raw data files
        
        blogs <- readLines("./en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
        news <- readLines("./en_US.news.txt", encoding = "UTF-8", skipNul = TRUE)
        twitter <- readLines("./en_US.twitter.txt", encoding = "UTF-8", skipNul = TRUE)

# Set sample size
        
        samplesize <- 0.05

# Remove non-English characters
        
        blogs <- iconv(blogs, "latin1", "ASCII", sub = "")
        news <- iconv(news, "latin1", "ASCII", sub = "")
        twitter <- iconv(twitter, "latin1", "ASCII", sub = "")

# Take a sample from each dataset and merge it into a single sample dataset
        
        set.seed(100)
        data_sample <- c(sample(blogs, length(blogs) * samplesize), 
                         sample(news, length(news) * samplesize), 
                         sample(twitter, length(twitter) * samplesize))

# Remove redundant data
        
        rm(blogs)
        rm(news)
        rm(twitter)

# Convert sample dataset into a corpus and then clean
        
        corpus <- VCorpus(VectorSource(data_sample))
        
# Convert all text to lower case
        
        corpus <- tm_map(corpus, tolower)
        
# Remove punctuation marks
        
        corpus <- tm_map(corpus, removePunctuation)
        
# Remove numbers
        
        corpus <- tm_map(corpus, removeNumbers)
        
# Remove excess spaces
        
        corpus <- tm_map(corpus, stripWhitespace)
        
# Convert to plain text
        
        corpus <- tm_map(corpus, PlainTextDocument)
        
# Save corpus file
        
        saveRDS(corpus, file = "corpus.rds")
        
# Remove redundant data
        
        rm(data_sample)
        
# Tokenize corpus into one-word to four-word n-grams
        
        tokenizer1 <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
        tokenizer2 <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
        tokenizer3 <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
        tokenizer4 <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
        
# Create unigram matrix
        
        TDM1 <- TermDocumentMatrix(corpus, control = list(tokenize = tokenizer1))

# Find unigrams that occur 20 or more times
        
        freq1 <- findFreqTerms(TDM1, lowfreq = 20)
        
# Count the number of times each unigram appears and list them in decreasing order
        
        unigrams <- rowSums(as.matrix(TDM1[freq1,]))
        unigrams <- unigrams[order(unigrams, decreasing = TRUE)]
        
# Add column names
        
        unigrams <- data.frame(unigram = names(unigrams), freq = unigrams)
        unigrams$unigram <- as.character(unigrams$unigram)
        
# Count unique words

        unique_words <- nrow(unigrams)

# Create a table of the top 50 unigrams

        top50_freq1 <- as.data.frame(unigrams[1:50,])
        saveRDS(top50_freq1, file = "top50_unigrams.rds")

# Save unigrams file
        
        saveRDS(unigrams, file = "unigrams.rds")
        
# Remove redundant data
        
        rm(TDM1)
        rm(freq1)
        rm(top50_freq1)
        rm(unigrams)
        
# Create bigram matrix
        
        TDM2 <- TermDocumentMatrix(corpus, control = list(tokenize = tokenizer2))

# Find bigrams that occur 20 or more times
        
        freq2 <- findFreqTerms(TDM2, lowfreq = 20)
        
# Count the number of times each bigram appears and list them in decreasing order
        
        bigramFreqDF <- rowSums(as.matrix(TDM2[freq2,]))
        bigramFreqDF <- bigramFreqDF[order(bigramFreqDF, decreasing = TRUE)]
        
# Add column names
        
        bigramFreqDF <- data.frame(words = names(bigramFreqDF), frequency = bigramFreqDF)
        bigramFreqDF$words <- as.character(bigramFreqDF$words)
        
# Split bigrams into individual words
        
        bigramFreqDF_split <- strsplit(as.character(bigramFreqDF$words), split = " ")
        bigramFreqDF_split <- transform(bigramFreqDF, 
                                        first = sapply(bigramFreqDF_split,"[[",1), 
                                        second = sapply(bigramFreqDF_split,"[[",2), 
                                        stringsAsFactors = FALSE)
        bigrams <- data.frame(first = bigramFreqDF_split$first, 
                              second = bigramFreqDF_split$second, 
                              freq = bigramFreqDF_split$frequency, 
                              stringsAsFactors = FALSE)
        bigrams$unigram <- bigrams$first
        bigrams <- dplyr::select(bigrams, unigram, second, freq)
        
# Count unique bigrams
        
        unique_bigrams <- nrow(bigramFreqDF)
        
# Create a table of the top 50 bigrams
        
        top50_freq2 <- as.data.frame(bigramFreqDF[1:50,])
        saveRDS(top50_freq2, file = "top50_bigrams.rds")

# Save bigrams file
        
        saveRDS(bigrams, file = "bigrams.rds")
        
# Remove redundant data
        
        rm(TDM2)
        rm(freq2)
        rm(top50_freq2)
        rm(bigramFreqDF)
        rm(bigramFreqDF_split)

# Create trigram matrix
        
        TDM3 <- TermDocumentMatrix(corpus, control = list(tokenize = tokenizer3))

# Find trigrams that occur 10 or more times
        
        freq3 <- findFreqTerms(TDM3, lowfreq = 10)
        
# Count the number of times each trigram appears and list them in decreasing order
        
        trigramFreqDF <- rowSums(as.matrix(TDM3[freq3,]))
        trigramFreqDF <- trigramFreqDF[order(trigramFreqDF, decreasing = TRUE)]
        
# Add column names
        
        trigramFreqDF <- data.frame(words = names(trigramFreqDF), frequency = trigramFreqDF)
        trigramFreqDF$words <- as.character(trigramFreqDF$words)
        
# Split trigrams into individual words
        
        trigramFreqDF_split <- strsplit(as.character(trigramFreqDF$words), split = " ")
        trigramFreqDF_split <- transform(trigramFreqDF, 
                                         first = sapply(trigramFreqDF_split,"[[",1), 
                                         second = sapply(trigramFreqDF_split,"[[",2), 
                                         third = sapply(trigramFreqDF_split,"[[",3), 
                                         stringsAsFactors = FALSE)
        trigrams <- data.frame(first = trigramFreqDF_split$first, 
                               second = trigramFreqDF_split$second, 
                               third = trigramFreqDF_split$third, 
                               freq = trigramFreqDF_split$frequency, 
                               stringsAsFactors = FALSE)
        trigrams$bigram <- paste(trigrams$first, trigrams$second)
        trigrams <- dplyr::select(trigrams, bigram, third, freq)
        
# Count unique trigrams
        
        unique_trigrams <- nrow(trigramFreqDF)
        
# Create a table of the top 50 trigrams
        
        top50_freq3 <- as.data.frame(trigramFreqDF[1:50,])
        saveRDS(top50_freq3, file = "top50_trigrams.rds")

# Save trigrams file
        
        saveRDS(trigrams, file = "trigrams.rds")
        
# Remove redundant data
        
        rm(TDM3)
        rm(freq3)
        rm(top50_freq3)
        rm(trigramFreqDF)
        rm(trigramFreqDF_split)

# Create quadgram matrix
        
        TDM4 <- TermDocumentMatrix(corpus, control = list(tokenize = tokenizer4))

# Find quadgrams that occur 4 or more times
        
        freq4 <- findFreqTerms(TDM4, lowfreq = 4)
        
# Count the number of times each quadgram appears and list them in decreasing order
        
        quadgramFreqDF <- rowSums(as.matrix(TDM4[freq4,]))
        quadgramFreqDF <- quadgramFreqDF[order(quadgramFreqDF, decreasing = TRUE)]
        
# Add column names
        
        quadgramFreqDF <- data.frame(words = names(quadgramFreqDF), frequency = quadgramFreqDF)
        quadgramFreqDF$words <- as.character(quadgramFreqDF$words)
        
# Split quadgrams into individual words
        
        quadgramFreqDF_split <- strsplit(as.character(quadgramFreqDF$words), split = " ")
        quadgramFreqDF_split <- transform(quadgramFreqDF, 
                                          first = sapply(quadgramFreqDF_split,"[[",1), 
                                          second = sapply(quadgramFreqDF_split,"[[",2), 
                                          third = sapply(quadgramFreqDF_split,"[[",3), 
                                          fourth = sapply(quadgramFreqDF_split,"[[",4), 
                                          stringsAsFactors = FALSE)
        quadgrams <- data.frame(first = quadgramFreqDF_split$first, 
                                second = quadgramFreqDF_split$second, 
                                third = quadgramFreqDF_split$third, 
                                fourth = quadgramFreqDF_split$fourth, 
                                freq = quadgramFreqDF_split$frequency, 
                                stringsAsFactors = FALSE)
        quadgrams$trigram <- paste(quadgrams$first, quadgrams$second, quadgrams$third)
        quadgrams <- dplyr::select(quadgrams, trigram, fourth, freq)
        
# Count unique quadgrams
        
        unique_quadgrams <- nrow(quadgramFreqDF)
        
# Create a table of the top 50 quadgrams
        
        top50_freq4 <- as.data.frame(quadgramFreqDF[1:50,])
        saveRDS(top50_freq4, file = "top50_quadgrams.rds")

# Save quadgrams file
        
        saveRDS(quadgrams, file = "quadgrams.rds")        
                
# Remove redundant data
        
        rm(TDM4)
        rm(freq4)
        rm(top50_freq4)
        rm(quadgramFreqDF)
        rm(quadgramFreqDF_split)
        
# Stop timer
        
        stopTime <- proc.time()
        
# Calculate time taken
        
        print("Elapsed time (minutes)")
        (stopTime - startTime) / 60
