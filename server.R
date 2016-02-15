
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(reshape2)
library(scales)

shinyServer(function(input, output) {
  
  ## Calculate payment
  pay <- function(principal, interest, duration) {
    
    r <- (interest / 12)/100
    d <- duration * 12
    
    payment <- principal * r / ( 1 - ( 1 + r)^-d)
    res <- list(r=r, payment=payment, principal=principal)
    return(res)
  }
  
  ##Calculate payment after subtracting annual saving
  df <- function(principal, interest, duration, annualSaving, lifespan) {
    payYear <- pay(principal, interest, duration)$payment * 12
    df_data_yr <- data.frame(year = seq(0, lifespan))
    
    df_data_yr$wasted <- 0
    df_data_yr$wasted[(df_data_yr$year) == 0 ] <- annualSaving
    
    df_data_yr$payment <- 0
    df_data_yr$payment[(df_data_yr$year) > 0 & (df_data_yr$year) <= duration] <- payYear
    
    df_data_yr$saved <- 0
  
    if ((annualSaving - payYear)>=0){
      df_data_yr$saved[(df_data_yr$year) > 0 & (df_data_yr$year) <= duration] <- annualSaving - payYear
      df_data_yr$saved[(df_data_yr$year) > duration & (df_data_yr$year) <= lifespan] <- annualSaving
    }
    else{
      df_data_yr$saved[(df_data_yr$year) > duration & (df_data_yr$year) <= lifespan] <- annualSaving
    }
    return(df_data_yr)
  }

  output$payPlot <- renderPlot({

   dat <- df (input$projCosts,
              input$intRate,
              input$leaseTerm,
              input$annualSavings,
              input$equpmentLife) 
   
   redat <- melt(dat, id.vars = "year", variable.name = "type", value.name = "amount")
   
   ggplot(data = redat, mapping = aes(x=year, y=amount, fill=type)) +
     coord_cartesian(xlim = c(0, 10)) +
     scale_x_discrete(breaks = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"))+
     scale_y_continuous(labels = comma)+
     geom_bar(stat="identity") +
     scale_fill_manual(values = c("red", "blue", "green")) 
  
  })
  
  output$savingsSummary  <- renderPrint({
    
    dat <- df (input$projCosts,
               input$intRate,
               input$leaseTerm,
               input$annualSavings,
               input$equpmentLife) 
    
    paymnt <- pay(input$projCosts,
                  input$intRate,
                  input$leaseTerm)
    
    cat("Lifecycle Savings: $")
    cat(sum(dat$saved))
    
    cat("\nMontly Savings: $")
    cat(input$annualSavings/12)
    
    cat("\nMonthly Cashflow: $")
    cat(input$annualSavings/12 - paymnt$payment)
    cat(" (during lease term)")
    
  })
  
  output$paymentsSummary  <- renderPrint({
    
    dat <- df (input$projCosts,
               input$intRate,
               input$leaseTerm,
               input$annualSavings,
               input$equpmentLife) 
    
    paymnt <- pay(input$projCosts,
                  input$intRate,
                  input$leaseTerm)
    
    cat("Lease Term: ")
    cat(input$leaseTerm)
    cat(" years")
    
    cat("\nMontly Payment: $")
    cat(paymnt$payment)
    
    cat("\nDown Payment: 0$")
    
  })
  
  output$payTable <- renderDataTable({
    
    dat <- df (input$projCosts,
               input$intRate,
               input$leaseTerm,
               input$annualSavings,
               input$equpmentLife) 
    
  })

})
