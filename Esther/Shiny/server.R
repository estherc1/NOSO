shinyServer(
  function(input, output){
    output$itratio <- renderValueBox({
      valueBox(
        if(input$radio==1){unom  %>% 
            filter(ID==input$id) %>% 
            summarise(round(sum(Out_Qty)/mean(Warehouse_Qty)))}
        else{unoq  %>% 
            filter(ID==input$id) %>% 
            summarise(round(sum(Out_Qty)/mean(Warehouse_Qty)))}, 
        "Inventory Turnover Ratio", icon = icon("list"),
        color = "purple"
      )
    })
    
    output$dayssale <- renderValueBox({
      valueBox(
        if(input$radio==1){unom  %>% 
            filter(ID==input$id) %>% 
            summarise(round(365/(sum(Out_Qty)/mean(Warehouse_Qty))))}
        else{unoq  %>% 
            filter(ID==input$id) %>% 
            summarise(round(365/(sum(Out_Qty)/mean(Warehouse_Qty))))}, 
        "Inventory Turnover Days", icon = icon("address-book"),
        color = "blue"
      )
    })
    
    output$warehouse <- renderValueBox({
      valueBox(
        if(input$radio==1){unom  %>% 
                filter(ID==input$id) %>% 
                select(Warehouse_Qty) %>% tail(1)}
        else{unoq  %>% 
            filter(ID==input$id) %>% 
            select(Warehouse_Qty) %>% tail(1)}, 
        "Today's Warehouse Inventory", icon = icon("bolt"),
        color = "yellow"
      )
    })
    
    output$stats_plot <- renderPlotly({
      if(input$radio==1){
        plot_ly(unom  %>% filter(ID==input$id), x = ~Date, y = ~In_Qty, name = 'In Qty', type = 'scatter', mode = 'lines+markers') %>%
          add_trace(y = ~Out_Qty, name = 'Out Qty', mode = 'lines+markers') %>%
          add_trace(y = ~Warehouse_Qty, name = 'Warehouse Qty', mode = 'lines+markers')%>%
          layout(title = "Inventory Flow Analysis",xaxis = list(title = "Month"),yaxis = list (title = "Quantity"))}
      else{plot_ly(unoq  %>% filter(ID==input$id), x = ~Date, y = ~In_Qty, name = 'In Qty', type = 'scatter', mode = 'lines+markers') %>%
          add_trace(y = ~Out_Qty, name = 'Out Qty', mode = 'lines+markers') %>%
          add_trace(y = ~Warehouse_Qty, name = 'Warehouse Qty', mode = 'lines+markers')%>%
          layout(title = "Inventory Flow Analysis",xaxis = list(title = "Quarter"),yaxis = list (title = "Quantity"))}
    })
    
    
    output$tline_plot <- renderPlotly({
      if(input$radio==1){
        plot_ly(prophetts(sale %>% filter(Style_Color==input$id),1), x = ~Date, y = ~Quantity, name = 'Quantity', type = 'scatter', mode = 'lines+markers') %>%
          layout(title = "Quantity Demand Forecast",xaxis = list(title = "Month"),yaxis = list (title = "Quantity"))}
      else{plot_ly(prophetts(sale %>% filter(Style_Color==input$id),2), x = ~Date, y = ~Quantity, name = 'Quantity', type = 'scatter', mode = 'lines+markers') %>%
          layout(title = "Quantity Demand Forecast",xaxis = list(title = "Quarter"),yaxis = list (title = "Quantity"))}
    })
    
})