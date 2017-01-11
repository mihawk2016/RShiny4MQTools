library(shiny)
library(shinydashboard)


#### HEADER ####

dashboard.header <- dashboardHeader(title = 'MetaQuote Tools')

#### SIDEBAR ####

dashboard.sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Upload', tabName = 'Upload', icon = icon('upload')),
    menuItem('Output', tabName = 'Output', icon = icon('download')),
    menuItem("Widgets", icon = icon("th"), tabName = "widgets",
             badgeLabel = "new", badgeColor = "green")
  )
)

#### BODY ####

#### UPLOAD ####

upload <- fileInput(
  inputId = 'file.upload',
  label = 'Upload files',
  multiple = T,
  width = '50%'
)


#### + BODY: TABBOX: ANALYSIS ####

tabbox.report.account <- tabPanel('Account')
tabbox.report.symbol <- tabPanel('Symbol')
tabbox.report.tickets <- tabPanel('Tickets')

tabbox.report <- tabBox(
  width = 12,
  tabbox.report.account,
  tabbox.report.symbol,
  tabbox.report.tickets
)

dashboard.body <- dashboardBody(
  # Boxes need to be put in a row (or column)
  upload,
  hr(),
  fluidRow(
    tabbox.report
  ),
  tabItems(
    tabItem(tabName = "Upload",
            h2("Dashboard tab content")
    ),
    
    tabItem(tabName = "widgets",
            h2("Widgets tab content")
    )
  ),
  fluidRow(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    box(
      title = "Controls",
      sliderInput("slider", "Number of observations:", 1, 100, 50)
    ),
    tabBox(
      side = "right", height = "250px",
      selected = "Tab3",shiny::icon("gear"),
      tabPanel("Tab1", "Tab content 1"),
      tabPanel("Tab2", "Tab content 2"),
      tabPanel("Tab3", "Note that when side=right, the tab order is reversed.")
    )
  )
)

#### PAGE ####

dashboardPage(
  dashboard.header,
  dashboard.sidebar,
  dashboard.body
)
