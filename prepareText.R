# prepareText.R
# cleans input text entered into predictive text app so it can be read
# 11 July 2019

prepareText <- function(text, wordCount = 350000) {

# Remove George Carlin's seven words you can't say on tv or the radio       
        removeProfanity <- function(text) {
                        load("profanitywords.RData")
                        text <- removeWords(text, profanitywords)
        
# Remove quasi-profanity, e.g. f***, a$$ etc.
                        text <- removePattern(text, "\\b[a-z]+[#$%&()*+/:<=>@[\\^_`|~-]+")
                        return(text)
                        }

# Replace common contractions e.g. "can't" into "cannot", "you're" into "you are" etc.
        convertText <- function (text) {
                text <- ConvertTo(text, "\\bcan't\\b", "cannot")
                text <- ConvertTo(text, "\\bwon't\\b", "will not")
                text <- ConvertTo(text, "\\bshan't\\b", "shall not")
                text <- ConvertTo(text, "\\bain't\\b", "am not")
                text <- ConvertTo(text, "n't\\b", " not")
                text <- ConvertTo(text, "\\blet's\\b", "let us")
                text <- ConvertTo(text, "\\bc'mon\\b", "come on")
                text <- ConvertTo(text, "'n\\b", " and")
                text <- ConvertTo(text, "\\bi'm\\b", "i am")
                text <- ConvertTo(text, "'re\\b", " are")
                text <- ConvertTo(text, "'s\\b", " is")
                text <- ConvertTo(text, "'d\\b", " would")
                text <- ConvertTo(text, "'ll\\b", " will")
                text <- ConvertTo(text, "'ve\\b", " have")
                text <- ConvertTo(text, "\\bb\\b", "be")
                text <- ConvertTo(text, "\\bc\\b", "see")
                text <- ConvertTo(text, "\\bm\\b", "am")
                text <- ConvertTo(text, "\\bn\\b", "and")
                text <- ConvertTo(text, "\\bo\\b", "oh")
                text <- ConvertTo(text, "\\br\\b", "are")
                text <- ConvertTo(text, "\\bu\\b", "you")
                text <- ConvertTo(text, "\\by\\b", "why")
                text <- ConvertTo(text, "\\b1\\b", "one")
                text <- ConvertTo(text, "\\b2\\b", "to")
                text <- ConvertTo(text, "\\b4\\b", "for")
                text <- ConvertTo(text, "\\b8\\b", "ate")
                text <- ConvertTo(text, "\\b2b\\b", "to be")
                text <- ConvertTo(text, "\\b2day\\b", "today")
                text <- ConvertTo(text, "\\b2moro\\b", "tomorrow")
                text <- ConvertTo(text, "\\b2morow\\b", "tomorrow")
                text <- ConvertTo(text, "\\b2nite\\b", "tonight")
                text <- ConvertTo(text, "\\bl8r\\b", "later")
                text <- ConvertTo(text, "\\b4vr\\b", "forever")
                text <- ConvertTo(text, "\\b4eva\\b", "forever")
                text <- ConvertTo(text, "\\b4ever\\b", "forever")
                text <- ConvertTo(text, "\\bb4\\b", "before")
                text <- ConvertTo(text, "\\bcu\\b", "see you")
                text <- ConvertTo(text, "\\bcuz\\b", "because")
                text <- ConvertTo(text, "\\btnx\\b", "thanks")
                text <- ConvertTo(text, "\\btks\\b", "thanks")
                text <- ConvertTo(text, "\\bthks\\b", "thanks")
                text <- ConvertTo(text, "\\bthanx\\b", "thanks")
                text <- ConvertTo(text, "\\bu2\\b", "you too")
                text <- ConvertTo(text, "\\bur\\b", "your")
                text <- ConvertTo(text, "\\bgr8\\b", "great")
                return(text)
                }
        
# Remove punctuation and special characters
        cleanText <- function(text) {
                text <- removePunctuation(text, preserve_intra_word_dashes = TRUE)
                text <- removePattern(text, "#\\w+")
                text <- removePattern(text, "\\brt\\b")
                text <- removePattern(text, "( \\S+\\@\\S+\\..{1,3}(\\s)? )")
                text <- removePattern(text, "@\\w+")
                text <- removePattern(text, "http[^[:space:]]*")
                text <- ConvertTo(text, "/|@|\\|", " ")
                text <- removePattern(text, "[^a-z0-9 ]")
                return(text)
                }
        
# Remove non-graphical characters
        text <- removePattern(text, "[^[:graph:] ]")
        
# Truncate text to the last wordCount words
        text <- truncateText(text, wordCount)
        
# Convert to lowercase
        text <- tolower(text)
        
# Convert contractions
        text <- convertText(text)
        
# Truncate text to the last wordCount words
        text <- truncateText(text, wordCount)
        
# Remove profanity
        text <- removeProfanity(text)
        
# Clean
        text <- cleanText(text)
        
# Remove numbers
        text <- removePattern(text, "[^a-z ]")
        
# Strip out extra whitespace
        text <- str_trim(stripWhitespace(text), side = 'both')

# Return blank space if nothing is entered                
        if (length(text) == 0)
                return("")
        else
                return(text)
        }