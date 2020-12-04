
#plot <- p %>%
# plot_ly(
#    x = ~imdb_score, 
#    y = ~gross, 
#    size = ~budget,
#    color = ~genres,
#colors = brewer.pal(nlevels(pull(df1,genres)),
#"Paired"),
#    frame = ~genres, 
#    text = ~movie_title, 
#    hoverinfo = "text",
#    type = 'scatter',
#    mode = 'markers',
#    fill = ~'',
#    marker = list(sizemode = 'diameter')
#  )


#plot <- plot %>% animation_opts(
#  1000, easing = "elastic", redraw = FALSE
#)

## IMDb_score Draft

#plot_animation_IMDb <- function(Genreslist_Animation){
#  p <- 
#    animation_data %>%  
#    drop_na(year,month,imdb_score) %>%
#    mutate(year = as.numeric(year)) %>% 
#    filter(genres %in% Genreslist_Animation, year > 1980) %>% 
#    group_by(year, genres, imdb_score) %>%
#    summarize(mean_gross = mean(gross)) %>%
#    ggplot(aes(x = imdb_score, y = mean_gross, group = genres)) + 
#    geom_point(aes(color = genres), show.legend = FALSE, alpha = 0.7) +
#    scale_color_viridis_d() +
#    scale_size(range = c(2, 12)) +
#    labs(x = "IMDb Score", y = "Mean Gross")
#  p + transition_time(as.integer(year)) + labs(title = "Year: {frame_time}") + shadow_wake(wake_length = 0.1, alpha = FALSE)
#  return(p)
#}


## IMDb_score  (X not use)

plot_animation_IMDb <- function(Genreslist_Animation){
  p <- 
    animation_data %>%  
    drop_na(year,month,imdb_score) %>%
    mutate(year = as.numeric(year)) %>% 
    filter(genres %in% Genreslist_Animation, year > 1980) %>% 
    group_by(year, genres, imdb_score) %>%
    summarize(mean_gross = mean(gross)) %>%
    ggplot(aes(x = imdb_score, y = mean_gross, group = genres)) + 
    geom_point(aes(color = genres), show.legend = FALSE, alpha = 0.7) +
    scale_color_viridis_d() +
    scale_size(range = c(2, 12)) +
    labs(x = "IMDb Score", y = "Mean Gross")
  p + transition_time(as.integer(year)) + labs(title = "Year: {frame_time}") + shadow_wake(wake_length = 0.1, alpha = FALSE)
  return(p)
}

