# Global.r

#Library

library(shiny)
library(shinydashboard)
library(shinythemes)
library(plotly)
library(tidyverse)
library(shinycssloaders)
library(tidyverse)
library(wordcloud2)
library(gganimate)
library(gifski)

#The data for plot

radarplot_data <- read_csv("shiny_radar.csv")
animation_plot <- read_csv("shiny_animation.csv")

name_list_radar_right <- c("movie_title","genres",
                           "director_facebook_likes","actor_3_facebook_likes",
                           "actor_2_facebook_likes","actor_1_facebook_likes",
                           "movie_facebook_likes")

name_list_radar_left <- c("movie_title","genres","num_critic_for_reviews",
                          "duration","num_voted_users", "facenumber_in_poster","num_user_for_reviews","budget"
                          ,"imdb_score","aspect_ratio")

#Functions for plot:

## 1. Radar
selectdata <- function(Genres, Varlist, Tibble){
  value_vector <- 
    Tibble %>% 
    filter(genres == Genres) %>% 
    filter(variable %in% Varlist) %>% 
    pull(value)
  return(value_vector)
}

add_closed_trace <- function(p, r, theta, ...){
  plotly::add_trace(p, r = c(r, r[1]), theta = c(theta, theta[1]), ...)
}

plot_radar <- function(Genreslist_Radar, plot_Varlist){
  
  output <- plot_ly(
    type = 'scatterpolar',
    mode = "closest")#,
  #fill = "toself")
  
  for (i in 1:length(Genreslist_Radar)) {
    output <- 
      output %>% 
      add_closed_trace(
        r = selectdata(Genreslist_Radar[i],plot_Varlist,radarplot_data),
        theta = plot_Varlist[3:length(plot_Varlist)],
        showlegend = T,
        mode =  "toself",
        name = Genreslist_Radar[i]) 
  }
  
  return(output)
}

## 2. Animation plot

plot_animation <- function(Genreslist_Animation){
  p <- 
    animation_plot %>%  
    drop_na(month) %>% 
    filter(genres %in% Genreslist_Animation) %>% 
    group_by(genres, month) %>%
    summarize(mean_gross = mean(gross)) %>%
    ggplot(aes(x = as.factor(month), y = mean_gross, group = genres)) + 
    geom_line(aes(color = genres), size = 1) + 
    geom_point(aes(color = genres), size = 2) + 
    labs(title = "Trends of mean_gross by genres over months",
         x = "Month", 
         y = "Mean Gross") +
    theme(axis.text.x = element_text(angle = 45))
  p<- p + transition_reveal(month)
  return(p)
}

