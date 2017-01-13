library(shiny)

<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 3e13d758f0005cbac64766b88599b0b2a7c3e279
#### SHINY-SERVER { ####



#### SHINY-SERVER } ####

shinyServer(function(input, output) {
  ntext <- eventReactive(input$file.clear, {
    restoreInput('file.upload', NULL)
  })
  output$file.upload <- ntext
  
<<<<<<< HEAD
})
=======
})
=======
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
})
>>>>>>> a1ae3fff12fd4cd2671e5816485c05525c01e142
>>>>>>> 3e13d758f0005cbac64766b88599b0b2a7c3e279
