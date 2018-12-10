library(DT)
library(shiny)
library(shinydashboard)

ui <- dashboardPage( skin="black",
  dashboardHeader(title="Cancer Study by Esther Chang",
                  titleWidth = 450),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "intro", icon = icon("list-alt")),
      menuItem("Overall Summary", tabName = "stats", icon = icon("magic")),
      menuItem("Cancer Timeline", tabName = "tline", icon = icon("cog")),
      menuItem("Cancer By Age", tabName = "age", icon = icon("industry"))
    ),
    
    fluidRow(
      sliderInput(inputId = "year", label = "Year", min = 1999, max = 2012, value = c(2000,2002)),
      selectInput(inputId = "site", label = "Cancer Site (multiselect)", choices = unique(cancdata$site), multiple = TRUE, selected = "Lung and Bronchus"),
      selectInput(inputId = "age", label = "Age Group (multiselect)", choices = levels(cancdata$age),  multiple = TRUE, selected = c("65-69", "70-74","75-79","80-84","85+")),
      selectInput(inputId = "race", label = "Race (multiselect)", choices = unique(cancdata$race),  multiple = TRUE, selected = c("White", "Black"))
    )
    
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = 'intro',
              fluidPage(
                img(src='USCS.png', align = "left", width = 300)
              ),
              h1("Annual Report to the Nation 2017: Incidence Summary"),
              h4("Cancer has a major impact on society in the United States and across the world. 
                 Cancer statistics describe what happens in large groups of people and provide 
                 a picture in time of the burden of cancer on society. 
                 Statistics tell us things such as how many people are diagnosed with and 
                 die from cancer each years and  differences among groups defined by age, 
                 sex and racial/ethnic group."),
              
              fluidRow(
                box(
                  title = "Top 10 Cancers by Rates of New Cancer Cases", solidHeader = TRUE, status = "primary",
                  img(src='t10n.png', align = "center", width=560)
                ),
                box(
                  title = "Top 10 Cancers by Rates of Cancer Deaths", solidHeader = TRUE, status = "primary",
                  img(src='t10d.png', align = "center", width=560)
                  )
                ),
              
              fluidRow(
                box(
                  title = "Cancer Incidence Rate by Age", solidHeader = TRUE, status = "primary",
                  img(src='age.png', align = "center", width=560)
                ),
                box(
                  title = "Timeline of Cancer Incidence Rate", solidHeader = TRUE, status = "primary",
                  img(src='timeline.png', align = "center", width=560)
                )
              )
              ),
      
      tabItem(tabName = 'stats', h2("Overall Summary"), 
              fluidPage(
                fluidRow(
                  column(12, align="center",
                         valueBoxOutput("population"),
                         valueBoxOutput("incidence"),
                         valueBoxOutput("rate")
                  )
                ),
                fluidRow(
                  column(12, align="center",
                         plotOutput("stats_plot", width = 400),
                         tableOutput("stats_table")
                  )
                )
              )
              ),
      tabItem(tabName = 'tline', h2("Cancer Timeline"),
              plotOutput("tline_plot")
              ),
      tabItem(tabName = 'age', h2("Cancer by Age"), 
              plotOutput("age_plot")
              )
    )
  )
)