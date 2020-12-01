# Server.r
shinyServer(
  function(input, output) {
  
  output$plot1 <- renderPlotly({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    plot_radar(input$GenreList, name_list_radar_left)})
  
  output$plot2 <- renderPlotly({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    plot_radar(input$GenreList, name_list_radar_right)})
  
  output$plot3 <- renderImage({ 
    
    outfile <- tempfile(fileext='.gif')
    
    #validate(need(length(input$GenreList) > 0, "please select"))
    
    p <- animate(plot_animation(input$GenreList), renderer = gifski_renderer())
    
    anim_save("outfile.gif", animation = p)
    
    list(src = "outfile.gif",
         contentType = 'image/gif'
         # width = 400,
         # height = 300,
         # alt = "This is alternate text"
    )},deleteFile = TRUE)
  
  output$plot4 <- renderPlotly({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    plot_radar(input$GenreList, name_list_radar_right)})
  
  }
)