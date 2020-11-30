# Server.R

# Functions:

selectdata <- function(Year, Tibble){
  value_vector <- 
    Tibble %>% 
    filter(year == Year) %>% 
    pull(value)
  return(value_vector)
}


plot_the_fig <- function(years){
  
  output <- plot_ly(
    type = 'scatterpolar',
    mode = "closest",
    fill = "none")
  
  for (i in 1:length(years)){
    output <- 
      output %>% 
      add_trace(
        r = selectdata(years[i],data),
        theta = month.name,
        showlegend = T,
        mode =  "toself",
        name = years[i]) 
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