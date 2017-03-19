
package.list <- search()
if ('package:RMitekeLab' %in% package.list) {
  detach('package:RMitekeLab', unload = TRUE)
}
library(shiny)
library(RMitekeLab)

library(ggplot2)
library(knitr)
library(htmltools)
# library(fPortfolio)
library(fMultivar)
source('../MQ_Analystic/CLASS.mq_analystic.R')
source('../MQ_Analystic/output.report.R')
options(shiny.maxRequestSize=15*1024^2)


#### SHINY-SERVER >> ####

#### + SHINY-SERVER >> INPUT ####
shiny.input <- function(input, output, analystic) {
  analystic$add.files(input$input.upload)
  mismatch.files <- analystic$get('mismatch')
  if (length(mismatch.files)) {
    output$input.unsupport.table <- renderDataTable({
      datatable(as.matrix(mismatch.files), selection = 'none', colnames = NULL)
    })
  }
  reports <- analystic$get.report()
  if (length(reports)) {
    output$input.support.table <- renderDataTable({
      datatable(analystic$get.report(member = 'INFOS') %>%
                  do.call(rbind, .)
                %>% extract(j = TIME := time.numeric.to.posixct(TIME) %>% as.character), selection = 'multiple')
    })
  }
}

#### + SHINY-SERVER >> CLEAR ####
shiny.clear <- function(input, output, analystic) {
  analystic$clear.files()
  output$input.unsupport.table <- renderDataTable({
    NULL
  })
  output$input.support.table <- renderDataTable({
    NULL
  })
  # hide('input.upload')
}

#### + SHINY-SERVER >> OUTPUT.CSV ####
# output.csv <- function(input, output) {
#   
# }

#### SHINY-SERVER << ####
shinyServer(function(input, output, session) {

  analystic <- MQ_ANALYSTIC$new()

  selected.reports <- reactive({
    input$input.support.table_rows_selected
  })
  
  observeEvent(input$input.upload, shiny.input(input, output, analystic))
  observeEvent(input$input.clear, shiny.clear(input, output, analystic))
  
  
  output$output.csv.button <- downloadHandler(
    filename = function() {
      input$input.support.table_rows_selected %>%
        analystic$get.report('INFOS', .) %>%
        rbindlist(use.names=TRUE, fill=TRUE) %>%
        output.file.name('TICKETS') %>%
        paste0('.csv')
    },
    content = function(file) {
      analystic$output.tickets(
        index = input$input.support.table_rows_selected,
        groups = input$output.csv.groups,
        columns = input$output.csv.columns,
        file = file
      ) ## ToDo: filename ####
    }
  )
  
  output$output.report.button <- downloadHandler(
    filename = function() {
      input$input.support.table_rows_selected %>%
        analystic$get.report('INFOS', .) %>%
        rbindlist(use.names=TRUE, fill=TRUE) %>%
        output.file.name('TICKETS') %>%
        paste0('.html')
    },
    content = function(file) {
      analystic$output.report(
        index = input$input.support.table_rows_selected,
        file = file
      ) ## ToDo: filename ####
    }
  )
  
  # output$analystic.tickets.table <- renderDataTable({
  #   ## ToDo ####
  #   old.selected <- analystic$get.selected.index()
  #   selected <- selected.reports()
  #   if (!identical(old.selected, selected)) {
  #     if (is.null(selected)) {
  #       render <- NULL
  #     } else {
  #       analystic$set.selected.index(selected)
  #       report <- analystic$set.analyzing.report()
  #       supported.Report <- analystic$init.others(report)
  #       tickets <- supported.Report$get.tickets.member('supported')
  #       tickets <- format(tickets, nsmall = 2)
  #       tickets[is.na(tickets)] <- ''
  #       render <- datatable(tickets, selection = 'single')
  #     }
  #   } else {
  #     render <- datatable(as.matrix(c(1,2,3)), selection = 'single', colnames = NULL)
  #   }
  #   render
  # })
  
  
})
