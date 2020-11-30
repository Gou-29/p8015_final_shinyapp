# Server.r
shinyServer(
  function(input, output) {
  
  output$plot1 <- renderPlotly({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    plot_radar(input$GenreList, name_list_radar_left)})
  
  output$plot2 <- renderPlotly({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    plot_radar(input$GenreList, name_list_radar_right)})
  
  output$plot3 <- renderPlotly({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    plot_radar(input$GenreList, name_list_radar_right)})
  
  output$plot4 <- renderPlotly({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    plot_radar(input$GenreList, name_list_radar_right)})
  
  }
)