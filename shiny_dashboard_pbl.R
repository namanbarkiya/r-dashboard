library(shiny)
library(shinydashboard)
library(ggplot2)

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "My Shiny Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Upload CSV", tabName = "upload", icon = icon("upload")),
      menuItem("Content Table", tabName = "content_table", icon = icon("table")),
      menuItem("Plot", tabName = "plot", icon = icon("chart-bar"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              # Upload CSV content 
              fluidRow(
                column(
                  width = 12,
                  h1("Welcome to the group project !"),
                  h3("Group Members:"),
                  p("Sajal Agarwal (2) "),
                  p("Naman Barkiya (7)"),
                  p("Aditya Bengeri (8)"),
                  p("Yojana Chaurasia (14)"),
                  p("Aquib Khan (28)"),
                  p("Rutuj Mestry (40)")
                )
              )
      ),
      tabItem(tabName = "upload",
              # Upload CSV content 
              fluidRow(
                box(
                  title = "Upload CSV File",
                  solidHeader = TRUE,
                  status = "primary",
                  width = 12,
                  fileInput("file1", "Choose CSV File", accept = c(".csv")),
                  checkboxInput("header", "Header", TRUE),
                  actionButton("upload", "Upload CSV")
                )
              )
      ),
      tabItem(tabName = "content_table",
              # Upload CSV content 
              fluidRow(
                box(
                  title = "CSV Contents",
                  solidHeader = TRUE,
                  status = "primary",
                  width = 12,
                  tableOutput("contents")
                )
              )
      ),
      tabItem(tabName = "plot",
              # Dashboard content 
              fluidRow(
                column(4, uiOutput("x_dropdown")),
                column(4, uiOutput("y_dropdown")),
                box(
                  title = "Plot",
                  solidHeader = TRUE,
                  status = "primary",
                  width = 12,
                  plotOutput("plot")
                )
              )
      )
    )
  )
)

# Define server
server <- function (input, output, session) {
  # Upload CSV
  data <- reactive({
    req(input$file1)
    infile <- input$file1
    df <- read.csv(infile$datapath, header = input$header)
    return(df)
  })
  
  # Show CSV contents
  output$contents <- renderTable({
    data()
  })
  
  # Create X axis selection dropdown
  output$x_dropdown <- renderUI({
    selectInput("x_axis", "Select X Axis", choices = colnames(data()))
  })
  
  # Create Y axis selection dropdown
  output$y_dropdown <- renderUI({
    selectInput("y_axis", "Select Y Axis", choices = colnames(data()))
  })
  
  # Show CSV plot
  output$plot <- renderPlot({
    df <- data()
    ggplot(df, aes(x = !!sym(input$x_axis), y = !!sym(input$y_axis))) +
      geom_bar(stat = "identity")
  })
}

# Run the app
shinyApp(ui = ui, server = server)
