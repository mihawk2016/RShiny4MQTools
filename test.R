<<<<<<< HEAD
# if (interactive()) {
  
  ui <- fluidPage(
    actionButton("update", "Update other buttons"),
    br(),
    actionButton("goButton", "Go"),
    br(),
    actionButton("goButton2", "Go 2", icon = icon("area-chart")),
    br(),
    actionButton("goButton3", "Go 3")
  )
  
  server <- function(input, output, session) {
    observe({
      req(input$update)
      # input$update
      
      # Updates goButton's label and icon
      updateActionButton(session, "goButton",
                         label = "New label",
                         icon = icon("calendar"))
      
      # Leaves goButton2's label unchaged and
      # removes its icon
      updateActionButton(session, "goButton2",
                         icon = character(0))
      
      # Leaves goButton3's icon, if it exists,
      # unchaged and changes its label
      updateActionButton(session, "goButton3",
                         label = "New label 3")
    })
  }
  
  shinyApp(ui, server)
# }
  
=======
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = 'MetaQuote Tools'),
  dashboardSidebar(sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Widgets", icon = icon("th"), tabName = "widgets",
             badgeLabel = "new", badgeColor = "green")
  )),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    tabItems(
      tabItem(tabName = "dashboard",
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
      )
    )
  )
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

shinyApp(ui, server)
>>>>>>> a1ae3fff12fd4cd2671e5816485c05525c01e142
