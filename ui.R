# ui.R
# user interface for predictive text app
# 11 July 2019

library(shiny)

shinyUI(pageWithSidebar(
    headerPanel("Data Science Capstone Project - Predictive text application"),
        sidebarPanel(
        h3("Enter text here"),
        br(),
        
        strong(""),
        textInput("impText", "Type in the first few words below:", value = "e.g. many thanks for the")
        
    ),
    mainPanel(tabsetPanel(
        tabPanel(
            "Predictions",
            
            h4('The text you entered, cleaned by the application:'),
            verbatimTextOutput("clnText", placeholder = TRUE),
            
            h4('The most likely, second most likely, third most likely next word based on what you entered:'),
            verbatimTextOutput("prediction", placeholder = TRUE)
            
        ),
        
tabPanel(
"About this application",
h4("Steve Scicluna"),
h5("11 July 2019"),
br(),
h4("Introduction"),
p(
"Predictive text technology is in widespread use on smartphones and tablets around the world.
The technology is based on collecting very large amounts of natural language data, such as news
articles, Twitter messages, blog posts etc., and analysing this data for recurring patterns, such as
how often the words 'I love' are followed by 'you', 'dogs', 'pasta', and so on."),
p(
"Very large data sets and the natural tendency of languages to have common figures of speech and
idiomatic phrases enable statistical software to calculate the probabilities with which various
words follow each other. The probabilities are the basis for predicting the next word as a phrase
is progressively entered into a predictive text application."),
p(
"The first step is to analyse the very large amounts of natural language data. ",
a("This RPubs report", href = "http://www.rpubs.com/stevescicluna/503566", target = "_blank"),
" describes the process whereby a sample of almost two million words was analysed to find the most
common words, and two, three, four, and five word expressions."),
br(),
h4("How to use this application"),
p(
"This application was designed to be as simple and intuitive as possible."),
p(
"In the box labelled 'Enter text here', you simply enter one or more words. You don't need to press 
the [ENTER] key.The software will clean and standardise what you enter so it can be used to search 
for the same or similar phrases in the sample data used to calculate the probabilities with with 
various words follow each other. For example, common contractions like 'can't' and 'won't will be 
changed to 'cannot' and 'will not'. Similarly, non-alphabetic characters like numerals and symbols 
like '@' will also be stripped out. Finally, ", a("George Carlin's seven dirty words ", href = "https://www.youtube.com/watch?v=PrD6k8PDr1o", target = "_blank"),
"will be stripped out if you enter them because we want to keep this application nice."),
p(
"Over on the right, you'll see the last three words of what you entered, as cleaned and
standardised by the software, and the most likely, second most likely, and third most likely next word 
based on what you entered."),
br(),
h4("How it works"),
p(
"The application uses the ",a("'Stupid Backoff' approach", href = "https://medium.com/@davidmasse8/predicting-the-next-word-back-off-language-modeling-8db607444ba9", target = "_blank"), ".",
p(
"This is really a thing, and basically works as follows:",
p(
"1. If you enter a phrase of three or more words, the last three words are used to search a dataset of 
16,491 four-word expressions with minimum four occurrences to find the word that most commonly follows 
this three word phrase."),
p(
"2. If that doesn't work, the last two words are used to search a dataset of 15,916 three-word expressions 
with minimum ten occurrences to find the word that most commonly follows this two word phrase."),
p(
"3. If that doesn't work, the last word is used to search a dataset of 16,787 two-word expressions with minimum
twenty occurrences to find the find the word that most commonly follows this two word phrase."),
br(),
h4("The data used by this application"),
p(
"The data used by this application comprised approximately 3.5 million words, or a 5% sample of approximately 70
million words compiled from online news articles, blog posts, and Twitter posts. While the number of expressions
sounds like a lot, it is still a 5% sample of a body of text sourced from a relatively narrow linguistic and
cultural subset of the English-speaking population. Therefore, please don't be surprised if the text you enter does 
not return a result - just try entering another phrase!"),
br(),
h4("Application code and data files"),
p(
"The application code and data fles are saved in ", a("Github", href = "https://github.com/stevescicluna/Capstone", target = "_blank"), ".")
)
)
)
)
)
)
)
