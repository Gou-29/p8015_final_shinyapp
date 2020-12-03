# Server.r
shinyServer(
  function(input, output) {

###Plots:
    
    
  output$plot1 <- renderPlotly({ 
    
    validate(need(length(input$GenreList) > 0, "Please select"))
    
    plot_radar(input$GenreList, name_list_radar_left)})
  
  output$plot2 <- renderPlotly({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    plot_radar(input$GenreList, name_list_radar_right)})
  
  output$plot3 <- renderImage({ 
    
    outfile <- tempfile(fileext='.gif')
    
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
  
  output$wordcloud2 <- renderWordcloud2({
    wordcloud2(plot_wordcloud(input$GenreList), backgroundColor = "white")
  })

### Valuebox:   
    
  output$A <- renderValueBox({
    valueBox(paste0("# 1: ", 
                    "$", Circulation_df(input$GenreList)[1,3] %>% as.character()), 
             str_glue(Circulation_df(input$GenreList)[1,2] %>% as.character()," | ",
                   Circulation_df(input$GenreList)[1,1] %>% as.character())
             , icon = icon("fire"), color = "red")
  })
  output$B <- renderValueBox({
    valueBox(paste0("# 2: ", 
                    "$", Circulation_df(input$GenreList)[2,3] %>% as.character()), 
             str_glue(Circulation_df(input$GenreList)[2,2] %>% as.character()," | ",
                      Circulation_df(input$GenreList)[2,1] %>% as.character())
             , icon = icon("fire"), color = "yellow")
  })
  output$C <- renderValueBox({
    valueBox(paste0("# 3: ", 
                    "$", Circulation_df(input$GenreList)[3,3] %>% as.character()), 
             str_glue(Circulation_df(input$GenreList)[3,2] %>% as.character()," | ",
                      Circulation_df(input$GenreList)[3,1] %>% as.character())
             , icon = icon("fire"), color = "blue")
  })
  

  
### Dfs:
  
  output$test_df <- DT::renderDataTable(Radar_df(input$GenreList))
  
  output$test_df_2 <- DT::renderDataTable(Circulation_df(input$GenreList))
  
  }
)


