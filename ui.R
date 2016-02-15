
# This is the user-interface definition of the Energy Effeicincy Calculator Shiny web application.
# You can find out more about using the application here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  
  # Application title
  titlePanel("Energy Efficiency Calculator"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      numericInput("projCosts", label = h3("Project Costs"), value = 250000),
      numericInput("annualSavings", label = h3("Annual Savings"), value = 75000),
      numericInput("equpmentLife", label = h3("Equipment Life"), value = 10),
      sliderInput("leaseTerm",
                  label = h3("Lease Term"),
                  min = 1,
                  max = 10,
                  value = 4),
      sliderInput("intRate",
                  label = h3("Interest Rate"),
                  min = 1,
                  max = 8,
                  value = 5,
                  post = "%",
                  step = 0.01)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Results",
                 h4("Saving over 10 years"),
                 plotOutput("payPlot"),
                 h4("Savings Summary"),
                 verbatimTextOutput("savingsSummary"),
                 h4("Payments Summary"),
                 verbatimTextOutput("paymentsSummary"),
                 dataTableOutput("payTable")),
        tabPanel("Help", 
                 h4 ("How to use Energy Efficiency Calculator"),
                 p("1) Enter your estimation for the cost of a given Energy Effeiciency project."),
                 p ("Example: Project Costs = $250 000"),
                 p("2) Enter your estimation for the annual savings that the Energy Efficiency project will deliver."),
                 p ("Example: Annual Savings = $75 000"),
                 p("3) Enter your estimation for the lifespan the Energy Efficiency equipment, during which it will deliver the expected results."),
                 p ("Example: Equipment Life = 10 years"),
                 p("4) Choose a lease term and interest rate in order to check your options to borrow capital for your Energy Efficiency project."),
                 p ("Example: Lease Term = 4 years; Interest Rate = 5%"),
                 p("5) Analyze results with the help of a chart and table"),
                 p("For the given example generated saving for the life of the Energy Efficinecy project is $473 648.5 and it is cash flow positive, taking into account the cost of borrowed capital"),
                 p("Monthly Cashflow = $492.68 (during the lease term)")
                 )
      )
      
    )
  )
))
