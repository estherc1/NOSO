library(DT)
library(shiny)
library(shinydashboard)
library(tidyverse)

ui <- dashboardPage( skin="yellow",
  dashboardHeader(title="Inventory Management Dashboard",
                  titleWidth = 450),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "intro", icon = icon("list-alt")),
      menuItem("Inventory Analysis", tabName = "inv", icon = icon("magic")),
      menuItem("Demand Forecast", tabName = "dem", icon = icon("cog"))
      ),
    
    fluidRow(
      selectInput(inputId = "radio", label = h5("Time Frequency"),
                   choices = list("Monthly" = 1, "Quarterly" = 2), selected = 1),
      selectInput(inputId = "id", label = h5("ID"), choices = unique(sale$Style_Color), 
                  selected = "DTA4E2531BL")
    )
    
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = 'intro',
              fluidPage(
                img(src='pic.png', align = "left", width = 300)
              ),
              h1("How to use Inventory Management Dashboard"),
              h4("Our data uses the information collected on the inventory of 20,597 products identified by the unique Style Numbers and colors.
                 Dashboard user has an option to choose either monthly or quarterly time frequency."),
              h4("Inventory Analysis tab looks at the inflow and outflow of inventory for selected product. 
                 Inventory Turnover Ratio is an efficiency ratio that shows how effectively inventory is managed by comparing cost of goods sold with average inventory for a period.
                 Inventory Turnover Days calculates the number of days it takes for a business to clear its inventory.
                 Latest inventory of a product is also displayed as Today's Warehouse Inventory."),
              fluidPage(
                img(src='it.png', width = 300)
              ),
              h4("Demand Forecast of inventory quantity uses time series model - Prophet - developed by Facebook.
                 Given a product's history inventory quantities, the model makes prediction of optimal inventory quantity for the next months/quarters.")
              ),
      
      tabItem(tabName = 'inv', h2("Inventory Turnover Analysis"), 
              fluidPage(
                fluidRow(
                  column(12, align="center",
                         valueBoxOutput("itratio"),
                         valueBoxOutput("dayssale"),
                         valueBoxOutput("warehouse")
                  )
                ),
                fluidRow(
                  column(12, align="center",
                         plotlyOutput("stats_plot", width = 1000)
                  )
                )
              )
              ),
      tabItem(tabName = 'dem', h2("Demand Forecast of Inventory Quantity"),
              fluidPage(
                
                fluidRow(
                  column(12, align="center",
                         plotlyOutput("tline_plot", width = 1000)
                  )
                )
              )
              )
    )
  )
)