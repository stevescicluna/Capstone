# predictWord.R
# Stupid Backoff algorithm for predictive text app
# 11 July 2019

# Back Off Algorithm
# Predict the next term of the user input sentence

Predict <- function(text) { 
        if (nchar(text) == 0) 
                return("")
        
        predWord <- ""
        
        # Take the last three words of the search term
        
        truncateText3 <- function(text, wordCount = 3) {
                truncText3 <- paste(
                        tail(unlist(strsplit(text, " ")), wordCount), collapse = " ")
                return(truncText3)
        }
        
        # Take the last two words of the search term 
        
        truncateText2 <- function(text, wordCount = 2) {
                truncText2 <- paste(tail(unlist(strsplit(text, " ")), wordCount), collapse = " ")
                return(truncText2)
        }
        
        # Take the last word of the search term
        
        truncateText1 <- function(text, wordCount = 1) {
                truncText1 <- paste(tail(unlist(strsplit(text, " ")), wordCount), collapse = " ")
                return(truncText1)
        }
        
        
        # For prediction of the next word, quadgram data is first used.
        # The first three words of the quadgram are the last three words entered by the user.
        
        predWord <- head(quadgrams[grep(truncateText3(text), quadgrams[,1]),],3)$fourth
        
        ifelse((nchar(predWord)>0), return(predWord), 
               predWord <- head(trigrams[grep(truncateText2(text), trigrams[,1]),],3)$third)
        
        ifelse((nchar(predWord)>0), return(predWord),
               predWord <- head(bigrams[grep(truncateText1(text), bigrams[,1]),],3)$second)
        
        ifelse((nchar(predWord)>0), return(predWord),
               predWord <- "N/A")
        
        return(predWord)
}
