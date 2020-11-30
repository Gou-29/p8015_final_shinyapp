# Server.R

# Functions:

selectdata <- function(Genres, Tibble){
  value_vector <- 
    Tibble %>% 
    filter(genres == Genres) %>% 
    pull(value)
  return(value_vector)
}

add_closed_trace <- function(p, r, theta, ...) 
{
  plotly::add_trace(p, r = c(r, r[1]), theta = c(theta, theta[1]), ...)
}

plot_the_fig <- function(Genreslist){
  
  output <- plot_ly(
    type = 'scatterpolar',
    mode = "closest")#,
  #fill = "toself")
  
  for (i in 1:length(Genreslist)){
    output <- 
      output %>% 
      add_closed_trace(
        r = selectdata(Genreslist[i],radarplot_data),
        theta = name_list_radar[3:15],
        showlegend = T,
        mode =  "toself",
        name = Genreslist[i]) 
  }
  
  return(output)
}




shinyServer(
  function(input, output) {
    
    output$plot <- renderPlotly({ 
      
      validate(need(length(input$year)>0, "please select"))
      
      plot_the_fig(input$year)})

  }
)