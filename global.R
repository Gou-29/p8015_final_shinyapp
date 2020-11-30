# Global. R

library(shiny)
library(shinydashboard)
library(shinythemes)
library(plotly)
library(tidyverse)
library(shinycssloaders)
library(tidyverse)
library(wordcloud2)

radarplot_data <- read_csv("shiny_radar.csv")
name_list_radar <- c("movie_title","genres","num_critic_for_reviews",
                     "duration","director_facebook_likes","actor_3_facebook_likes",
                     "actor_2_facebook_likes","actor_1_facebook_likes"
                     ,"num_voted_users", "facenumber_in_poster","num_user_for_reviews","budget"
                     ,"imdb_score","aspect_ratio","movie_facebook_likes")

