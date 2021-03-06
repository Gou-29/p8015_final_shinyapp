# Server.r


shinyServer(
  function(input, output, session) {
    
    
  begin <- reactiveValues(data = 0)
  
  observe({
    if(begin$data == 0){
      showModal(modalDialog(
        title = "Browser zoom settings and plot rendering notes:",
        "For a better experience, please set you zoom of browser to 90%. 
        Note that rendering pictures take time, please wait when changing filters. 
        Also, please do not add lots of filters in a single time to prevent disconnection",
        footer = modalButton("Got it!"),
        easyClose = F
      ))
    }
    })
  
  
  
###Plots: 
    
  output$plot1 <- renderPlotly({ 
    
    validate(need(length(input$GenreList) > 0, "Please select"))
    
    plot_radar(input$GenreList, name_list_radar_left)})
  
  output$plot2 <- renderPlotly({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    plot_radar(input$GenreList, name_list_radar_right)})
  

                               

    
  output$plot3 <- renderImage({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    progress <- shiny::Progress$new(max = 40)
    progress$set(message = "Rendering", value = 0)
    on.exit(progress$close())
    
    updateShinyProgress <- function(detail) {    
      progress$inc(1, detail = detail)
    }
    
    
    outfile <- tempfile(fileext='.gif')
    
    p <- animate(plot_animation_month(input$GenreList), 
                 renderer = gifski_renderer(),
                 nframes = 30, fps = 8, duration=5,
                 update_progress = updateShinyProgress)
    
    anim_save("outfile1.gif", animation = p)
    
    list(src = "outfile1.gif",
         contentType = 'image/gif',
         width = 400,
         height = 400
         # alt = "This is alternate text"
    )
    
  },deleteFile = TRUE) 
  
  
  output$plot4 <- renderImage({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    progress <- shiny::Progress$new(max = 40)
    progress$set(message = "Rendering", value = 0)
    on.exit(progress$close())
    
    updateShinyProgress <- function(detail) {    
      progress$inc(1, detail = detail)
    }
    
    outfile <- tempfile(fileext='.gif')
    
    p <- animate(plot_animation_year(input$GenreList), 
                 renderer = gifski_renderer(),
                 nframes = 30, fps = 8, duration=5,
                 update_progress = updateShinyProgress)
    
    anim_save("outfile2.gif", animation = p)
    
    list(src = "outfile2.gif",
         contentType = 'image/gif',
         width = 400,
         height = 400
         # alt = "This is alternate text"
    )},deleteFile = TRUE) 
  

                               
  
  output$plot5 <- renderPlot({ 
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    plot_circulate(input$GenreList)})
 
  
  
   
  output$plot6 <- renderPlotly({ 
    
    validate(need(length(input$varlist) > 0, "Please select"))
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    progress <- shiny::Progress$new(max = 40)
    progress$set(message = "Rendering", value = 0)
    on.exit(progress$close())
    
    plot_grossplus(input$GenreList, input$varlist[1])
    
    })
  
  output$plot7 <- renderPlotly({ 
    
    validate(need(length(input$varlist) > 0, "Please select"))
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    progress <- shiny::Progress$new(max = 40)
    progress$set(message = "Rendering", value = 0)
    on.exit(progress$close())
    
    plot_grossplus(input$GenreList,input$varlist[2])})
  
  output$plot8 <- renderPlotly({ 
    
    validate(need(length(input$varlist) > 0, "Please select"))
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    progress <- shiny::Progress$new(max = 40)
    progress$set(message = "Rendering", value = 0)
    on.exit(progress$close())
    
    plot_grossplus(input$GenreList,input$varlist[3])})
  
  output$plot9 <- renderPlotly({
    
    validate(need(length(input$varlist) > 0, "Please select"))
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    progress <- shiny::Progress$new(max = 40)
    progress$set(message = "Rendering", value = 0)
    on.exit(progress$close())
    
    plot_grossplus(input$GenreList,input$varlist[4])})
  
  output$wordcloud2 <- renderWordcloud2({
    
    validate(need(length(input$GenreList) > 0, "please select"))
    
    wordcloud2(plot_wordcloud(input$GenreList), backgroundColor = "white")
  })

  
### Valuebox:   
    
  output$A <- renderValueBox({
    valueBox(paste0("Top 1: ", 
                    Valubox_df(input$GenreList)[[3]][1] %>% dollar()), 
             str_glue(Valubox_df(input$GenreList)[[2]][1] %>% as.character()," | ",
                      Valubox_df(input$GenreList)[[1]][1] %>% as.character()," | ",
                      Valubox_df(input$GenreList)[[4]][1] %>% as.character())
             , icon = icon("fire"), color = "red")
  })
  output$B <- renderValueBox({
    valueBox(paste0("Top 2: ", 
                    Valubox_df(input$GenreList)[[3]][2] %>% dollar()), 
             str_glue(Valubox_df(input$GenreList)[[2]][2] %>% as.character()," | ",
                      Valubox_df(input$GenreList)[[1]][2] %>% as.character()," | ",
                      Valubox_df(input$GenreList)[[4]][2] %>% as.character())
             , icon = icon("fire"), color = "yellow")
  })
  output$C <- renderValueBox({
    valueBox(paste0("Top 3: ", 
                    Valubox_df(input$GenreList)[[3]][3] %>% dollar()), 
             str_glue(Valubox_df(input$GenreList)[[2]][3] %>% as.character()," | ",
                      Valubox_df(input$GenreList)[[1]][3] %>% as.character()," | ",
                      Valubox_df(input$GenreList)[[4]][3] %>% as.character())
             , icon = icon("fire"), color = "blue")
  })
  

  
### Dfs:
  
  output$Radar <- DT::renderDataTable(Radar_df(input$GenreList))
  
  output$Circulation <- DT::renderDataTable(Circulation_df(input$GenreList))
  
  output$Wordcloud <- DT::renderDataTable(Word_df(input$GenreList))
  
  output$lm_1 <- DT::renderDataTable(gross_lm_df(input$GenreList,input$varlist[1]),
                                     options = list(pageLength = 8, lengthChange = FALSE))
  
  output$lm_2 <- DT::renderDataTable(gross_lm_df(input$GenreList,input$varlist[2]),
                                     options = list(pageLength = 8, lengthChange = FALSE))
  
  output$lm_3 <- DT::renderDataTable(gross_lm_df(input$GenreList,input$varlist[3]),
                                     options = list(pageLength = 8, lengthChange = FALSE))
  
  output$lm_4 <- DT::renderDataTable(gross_lm_df(input$GenreList,input$varlist[4]),
                                     options = list(pageLength = 8, lengthChange = FALSE))
  
  output$animation_1 <- DT::renderDataTable(animation_month_df(input$GenreList))
  
  output$animation_2 <- DT::renderDataTable(animation_year_df(input$GenreList))
  
  
  
  
### Others
  
  

  
  }
)


