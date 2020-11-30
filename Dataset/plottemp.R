# plot template
data <- 
  matrix(data = AirPassengers, 
         nrow = 12, 
         ncol = 12,
         byrow = T, 
         dimnames = list(NULL,month.abb)) %>% 
  as_tibble() %>% 
  mutate(year = 1949:1960) %>% 
  pivot_longer(Jan:Dec,
               names_to = "month",
               values_to = "value")



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

plot_the_fig(c(1949,1953,1954,1958:1960))
