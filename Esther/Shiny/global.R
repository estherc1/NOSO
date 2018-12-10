library(DT)
library(shiny)
library(shinydashboard)
library(dplyr)
library(googleVis)
library(ggplot2)
library(RColorBrewer)

cancdata <- read.csv("cancdata.csv")[,-1]
cancdata$age <- factor(cancdata$age, levels(cancdata$age)[c(1,2,11,3:10,12:19)])
cancdata$count <- as.numeric(cancdata$count)
cancdata$population <- as.numeric(cancdata$population)