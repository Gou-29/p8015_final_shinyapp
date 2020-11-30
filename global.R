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


#The data

radarplot_data <- read_csv("shiny_radar.csv")
name_list_radar_right <- c("movie_title","genres",
                           "director_facebook_likes","actor_3_facebook_likes",
                           "actor_2_facebook_likes","actor_1_facebook_likes",
                           "movie_facebook_likes")
name_list_radar_left <- c("movie_title","genres","num_critic_for_reviews",
                          "duration","director_facebook_likes","actor_3_facebook_likes",
                          "actor_2_facebook_likes","actor_1_facebook_likes"
                          ,"num_voted_users", "facenumber_in_poster","num_user_for_reviews","budget"
                          ,"imdb_score","aspect_ratio","movie_facebook_likes")

#Functions for plot:
selectdata <- function(Genres, Varlist, Tibble){
  value_vector <- 
    Tibble %>% 
    filter(genres == Genres) %>% 
    filter(variable %in% Varlist) %>% 
    pull(value)
  return(value_vector)
}

add_closed_trace <- function(p, r, theta, ...) 
{
  plotly::add_trace(p, r = c(r, r[1]), theta = c(theta, theta[1]), ...)
}

plot_radar <- function(Genreslist, plot_Varlist){
  
  output <- plot_ly(
    type = 'scatterpolar',
    mode = "closest")#,
  #fill = "toself")
  
  for (i in 1:length(Genreslist)) {
    output <- 
      output %>% 
      add_closed_trace(
        r = selectdata(Genreslist[i],plot_Varlist,radarplot_data),
        theta = plot_Varlist[3:length(plot_Varlist)],
        showlegend = T,
        mode =  "toself",
        name = Genreslist[i]) 
  }
  
  return(output)
}
