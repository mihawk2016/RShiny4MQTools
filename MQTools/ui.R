library(shiny)
library(shinydashboard)

#### PAGE { ####

#### + HEADER ####

dashboard.header <- dashboardHeader(title = 'MetaQuote Tools')

#### + SIDEBAR ####

dashboard.sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Upload', tabName = 'Upload', icon = icon('upload')),
    menuItem('Output', tabName = 'Output', icon = icon('download')),
    menuItem("Widgets", icon = icon("th"), tabName = "widgets",
             badgeLabel = "new", badgeColor = "green")
  )
)

#### + BODY { ####

#### ++ FILE UPLOADER { ####

#### +++ UPLOAD ####

file.uploader.upload <- fileInput(
  inputId = 'file.upload',
  label = NULL,
  multiple = T,
  width = '100%'
)

#### +++ CLEAR ####

file.uploader.clear <- actionButton(
  inputId = 'file.clear',
  label = 'Clear',
  icon = shiny::icon('refresh'),
  width = '100%'
)

#### ++ FILE UPLOADER } ####

file.uploader <- box(
  collapsible = T,
  title = 'INPUT',
  column(
    width = 12,
    file.uploader.upload,
    file.uploader.clear,
    hr()
    
  )
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

<<<<<<< HEAD
#### + BODY } ####

dashboard.body <- dashboardBody(
  # Boxes need to be put in a row (or column)
  file.uploader,
  file.uploader,
=======
dashboard.body <- dashboardBody(
  # Boxes need to be put in a row (or column)
  upload,
>>>>>>> a1ae3fff12fd4cd2671e5816485c05525c01e142
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

<<<<<<< HEAD
#### PAGE } ####

dashboardPage(
  dashboard.header,
  dashboard.sidebar,
  dashboard.body
)
