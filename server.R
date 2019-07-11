# server.R
# server logic for predictive text app
# 11 July 2019

# Load software package
    library(shiny)

# Define server function
    shinyServer(function(input, output) {

# Insert a short pause after user input
        Sys.sleep(0.1)
# Clean input text
        cleanText <- reactive({
            prepareText(input$impText, 3)
        })
        output$clnText <- renderText({
            paste("...", cleanText())
        })
        
        # Predict next word
#        nextWord <- reactive({
#            predictWord(cleanText())
#        })
#        output$nxtWord <- renderPrint(
#            nextWord()
#        )
#    }
#    )
        
        output$prediction <- renderPrint({
            Predict(cleanText())
        })
        
#        output$text1 <- renderText({
#            paste("...", cleanText());
    }
    )