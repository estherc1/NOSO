shinyServer(
  function(input, output){
    output$incidence <- renderValueBox({
      valueBox(
        cancdata %>%
          filter(year%in%c(input$year[1]:input$year[2]),site%in%input$site,race%in%input$race, age %in% input$age) %>%
          summarise(sum(count, na.rm = TRUE)/1000000), "Number of Incidence (millions)", icon = icon("list"),
        color = "purple"
      )
    })
    
    output$population <- renderValueBox({
      valueBox(
        cancdata %>%
          filter(year %in% c(input$year[1]:input$year[2]),site %in% input$site, race %in% input$race, age %in% input$age) %>%
          summarise(sum(population, na.rm = TRUE)/1000000), "Total Population (millions)", icon = icon("address-book"),
        color = "blue"
      )
    })
    
    output$rate <- renderValueBox({
      valueBox(
        cancdata %>%
          filter(year %in% c(input$year[1]:input$year[2]),site %in% input$site, race %in% input$race, age %in% input$age) %>%
          summarise(paste(round(sum(count, na.rm = TRUE)/sum(population, na.rm = TRUE)*100000,2))), 
        "Incidence Rate per 100,000", icon = icon("bolt"),
        color = "yellow"
      )
    })
    
    output$stats_plot <- renderPlot({
      ggplot(cancdata %>% filter(year %in% c(input$year[1]:input$year[2]),site %in% input$site, race %in% input$race, age %in% input$age) %>%
               select(event_type), 
             aes(x="", y=event_type, fill=event_type)) + geom_bar(width = 1, stat = "identity")+
              coord_polar("y", start=0) + ylab("")  + xlab("") +  ggtitle("Incidence vs. Mortality")
    })
    
    output$stats_table <- renderTable({
      cancdata %>% filter(year %in% c(input$year[1]:input$year[2]),site %in% input$site, race %in% input$race, age %in% input$age) %>%
        group_by(year, site, race, age) %>%
        summarise(Cancer_Occurence=sum(count,na.rm = TRUE),
                  Total_Population = sum(population,na.rm = TRUE),
                  Rate=round(Cancer_Occurence/Total_Population*100000,2)) %>% arrange(desc(Rate))
    })
    
    output$tline_plot <- renderPlot({
      ggplot(cancdata %>% filter(year %in% c(input$year[1]:input$year[2]),site %in% input$site, race %in% input$race, age %in% input$age) %>%
               group_by(year, sex) %>% 
               summarise(Incidence_Rate = round(sum(count,na.rm = TRUE)/sum(population,na.rm = TRUE)*100000,2)) %>% arrange(year), 
             aes(x=year, y=Incidence_Rate, group=sex)) + 
        geom_line(aes(color=sex)) + 
        geom_point(aes(color=sex)) +
        xlab("") + ylab("Incidence per 100,000")
    })
    
    output$age_plot <- renderPlot({
      ggplot(cancdata %>% filter(year %in% c(input$year[1]:input$year[2]),site %in% input$site, race %in% input$race, age %in% input$age) %>%
               group_by(age, sex) %>% 
               summarise(Incidence_Rate = round(sum(count,na.rm = TRUE)/sum(population,na.rm = TRUE)*100000,2)), 
             aes(x=age, y=Incidence_Rate, group=sex)) + 
        geom_line(aes(color=sex)) + 
        geom_point(aes(color=sex)) +
        xlab("") + ylab("Incidence per 100,000")
    })
})