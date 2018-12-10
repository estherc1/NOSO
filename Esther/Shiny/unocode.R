rm(list=ls())
setwd("/Users/hee-wonchang/Desktop/NOSO/Esther/Shiny")
library(DT)
library(shiny)
library(shinydashboard)
library(dplyr)
library(googleVis)
library(ggplot2)
library(RColorBrewer)
library(plotly)
library(lubridate)
library(prophet)

unom <- read.csv("mdata.csv")[,-1]
colnames(unom) <- c("ID","Product_Description","Date","Out_Qty","In_Qty","Warehouse_Qty","Unit_Price")
unom <- unom[complete.cases(unom),]

unoq <- read.csv("qdata.csv")[,-1]
colnames(unoq) <- c("ID","Product_Description","Date","Out_Qty","In_Qty","Warehouse_Qty","Unit_Price")
unoq <- unoq[complete.cases(unoq),]

sale <- read.csv("sale_by_week.csv")[,-1]

#EDA: DTA1B2073BRN-PJA
unoq  %>% filter(ID=="DTA4E2531BL") %>% summarise(ITR = sum(Out_Qty)/mean(Warehouse_Qty), 
                                                       ITR_d = 365/ITR)
unom  %>% filter(ID=="DTA1B2073BRN-PJA") %>% summarise(ITR = sum(Out_Qty)/mean(Warehouse_Qty), 
                                                       ITR_d = 365/ITR)

unoq  %>% filter(ID=="DTA4E2531BL") %>% select(Warehouse_Qty) %>% tail(1)
unom  %>% filter(ID=="DTA4E2531BL") %>% select(Warehouse_Qty) %>% tail(1)

sample = sale  %>% filter(Style_Color=="DTA4E2531BL")   

prophetts <- function(sample, input_radio){
  m = prophet(sample, changepoint.prior.scale = 0.02)
  future = make_future_dataframe(m, periods=52, freq = 'weeks')
  forecast = predict(m, future)
  if(input_radio==1){forecastts = forecast%>%select(., ds,trend) %>% mutate(Time = format(as.Date(ds), "%Y-%m"))%>%
  group_by(Time) %>% summarise(Quantity = sum(trend))}
  else{forecastts = forecast%>%select(., ds,trend) %>% mutate(Time = as.yearqtr(ds, format = "%Y-%m-%d"))%>%
    group_by(Time) %>% summarise(Quantity = sum(trend))}
  return(forecastts)
  }

forecast %>% mutate(Time = format(as.Date(ds), "%Y-%m"))%>%
  group_by(Time) %>% summarise(Quantity = sum(trend))

prophetts(sample,2)

#plot demo
eda1 <- unoq  %>% filter(ID=="DTA1B2073BRN-PJA")%>%
  gather(key="Inv_Traffic", value="Qty", c('Out_Qty','In_Qty','Warehouse_Qty'))

ggplot(eda1, 
         aes(x=Date, y=Qty, group=Inv_Traffic)) + geom_line(aes(color=Inv_Traffic)) + 
         geom_point(aes(color=Inv_Traffic)) + xlab("") + ylab("Quantity") + 
         ggtitle("Inventory Flow Analysis") 

eda2 <- unoq  %>% filter(ID=="DTA1B2073BRN-PJA")

p <- plot_ly(unoq  %>% filter(ID=="DTA1B2073BRN-PJA"), x = ~Date, y = ~In_Qty, name = 'In Qty', type = 'scatter', mode = 'lines+markers') %>%
  add_trace(y = ~Out_Qty, name = 'Out Qty', mode = 'lines+markers') %>%
  add_trace(y = ~Warehouse_Qty, name = 'Warehouse Qty', mode = 'lines+markers')%>%
  layout(title = "Inventory Flow Analysis",xaxis = list(title = "Quarter"),yaxis = list (title = "Quantity"))

datatable(unoq  %>% filter(ID=="DTA1B2073BRN-PJA") %>% select(-c(Unit_Price,ID)))



