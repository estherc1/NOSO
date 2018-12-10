library(DT)
library(shiny)
library(shinydashboard)
library(dplyr)
library(googleVis)
library(ggplot2)
library(RColorBrewer)
library(plotly)
library(lubridate)


unom <- read.csv("mdata.csv")[,-1]
colnames(unom) <- c("ID","Product_Description","Date","Out_Qty","In_Qty","Warehouse_Qty","Unit_Price")
unom <- unom[complete.cases(unom),]

unoq <- read.csv("qdata.csv")[,-1]
colnames(unoq) <- c("ID","Product_Description","Date","Out_Qty","In_Qty","Warehouse_Qty","Unit_Price")
unoq <- unoq[complete.cases(unoq),]

sale <- read.csv("sale_by_week.csv")[,-1]
prophetts <- function(sample, input_radio){
  m = prophet(sample, changepoint.prior.scale = 0.02)
  future = make_future_dataframe(m, periods=52, freq = 'weeks')
  forecast = predict(m, future)
  if(input_radio==1){forecastts = forecast%>%select(., ds,trend) %>% mutate(Date = format(as.Date(ds), "%Y-%m"))%>%
    group_by(Date) %>% summarise(Quantity = sum(trend))}
  else{forecastts = forecast%>%select(., ds,trend) %>% mutate(Date = as.yearqtr(ds, format = "%Y-%m-%d"))%>%
    group_by(Date) %>% summarise(Quantity = sum(trend))}
  return(forecastts)
}
