# Server.r
shinyServer(
  function(input, output) {
  
  output$plot1 <- renderPlotly({ 
    
    validate(need(length(input$GenreList) > 0, "Please select"))
    
    plot_radar(input$GenreList, name_list_radar_left)})
  
  output$plot2 <- renderPlotly({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    plot_radar(input$GenreList, name_list_radar_right)})
  
  output$plot3 <- renderImage({ 
    
    outfile <- tempfile(fileext='.gif')
    
    #validate(need(length(input$GenreList) > 0, "please select"))
    
    p <- animate(plot_animation_month(input$GenreList), 
                 renderer = gifski_renderer(),
                 nframes = 60, fps=10, duration=5)
    
    anim_save("outfile1.gif", animation = p)
    
    list(src = "outfile1.gif",
         contentType = 'image/gif',
         width = 450,
         height = 400
         # alt = "This is alternate text"
    )},deleteFile = TRUE)
  
  output$plot4 <- renderImage({ 
    
    outfile <- tempfile(fileext='.gif')
    
    #validate(need(length(input$GenreList) > 0, "please select"))
    
    p <- animate(plot_animation_year(input$GenreList), 
                 renderer = gifski_renderer(),
                 nframes = 60, fps=10, duration=5)
    
    anim_save("outfile2.gif", animation = p)
    
    list(src = "outfile2.gif",
         contentType = 'image/gif',
         width = 450,
         height = 400
         # alt = "This is alternate text"
    )},deleteFile = TRUE)
  
  output$plot5 <- renderPlot({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    plot_circulate(input$GenreList)})
  
  output$plot6 <- renderPlotly({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    plot_animation_2(input$GenreList)})
  
  output$A <- renderValueBox({
    valueBox(paste0(5, "kcal"), 
             "Calories", icon = icon("fire"), color = "yellow")
  })
  output$B <- renderValueBox({
    valueBox(paste0(5, "kcal"), 
             "Calories", icon = icon("fire"), color = "yellow")
  })
  output$C <- renderValueBox({
    valueBox(paste0(5, "kcal"), 
             "Calories", icon = icon("fire"), color = "yellow")
  })
  
  output$wordcloud2 <- renderWordcloud2({
    wordcloud2(plot_wordcloud(input$GenreList), backgroundColor = "white")
  })
  
  
  output$test_df <- DT::renderDataTable(out_df(input$GenreList))
  
  }
)


