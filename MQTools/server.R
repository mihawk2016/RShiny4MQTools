library(shiny)

#### SHINY-SERVER { ####



#### SHINY-SERVER } ####

shinyServer(function(input, output) {
  ntext <- eventReactive(input$file.clear, {
    restoreInput('file.upload', NULL)
  })
  output$file.upload <- ntext
  
})
