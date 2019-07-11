# global.R
# functions and objects that will need to be visible to both server and ui
# 11 July 2019

# readRDS libraries
        library(tm)
        library(stringr)
        library(readr)

# Supporting functions

# truncateText() used in prepareText.R        

        truncateText <- function(text, wordCount = 3) {
                truncText <- paste(tail(unlist(strsplit(text, " ")), wordCount), collapse = " ")
        return(truncText)
                }

# ConvertTo() used in prepareText.R
                
        ConvertTo <- function(text, pattern1, pattern2) {
                gsub(pattern1, pattern2, text)
        }

# removePattern() used in prepareText.R
        
        removePattern <- function(text, pattern) {
                ConvertTo(text, pattern, "")
        }

# readRDS n-gram frequency tables
        unigrams <- readRDS("unigrams.rds")
        bigrams <- readRDS("bigrams.rds")
        trigrams <-readRDS("trigrams.rds")
        quadgrams <- readRDS("quadgrams.rds")
        
# Access functions in prepareText.R and predictWord.R        
        source('prepareText.R')
        source('predictWord.R')
