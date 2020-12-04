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
library(viridis)
library(lazyeval)
library(DT)
library(scales)
library(prettyunits)
library(png)

# Global setting for plot:

theme_set(theme_minimal() + theme(legend.position = "bottom"))
options(
  ggplot2.continuous.colour = "viridis",
  ggplot2.continuous.fill = "viridis"
)
scale_colour_discrete = scale_color_viridis_d
scale_fill_discrete = scale_fill_viridis_d

dollar_format(prefix = "$", suffix = "", largest_with_cents = 1e+05, big.mark = ",", negative_parens = FALSE)

#The data for plot

radarplot_data <- read_csv("./Dataset/shiny_radar.csv")
animation_data <- read_csv("./Dataset/shiny_animation.csv")
circulation_data <- read_csv("./Dataset/shiny_circulation.csv")
wordcloud_data = read_csv("./Dataset/shiny_keyword.csv")
plotly_df = read_csv("./Dataset/shiny_plotly.csv")

#The data for dfs

radarplot_df <- read_csv("./Dataset/shiny_radar_df.csv")



#################################
##     Functions for plot:     ##
#################################


## 1. Radar

name_list_radar_right <- c("movie_title","genres",
                           "director_facebook_likes","actor_3_facebook_likes",
                           "actor_2_facebook_likes","actor_1_facebook_likes",
                           "movie_facebook_likes")

name_list_radar_left <- c("movie_title","genres","N","num_critic_for_reviews","gross",
                          "duration","num_voted_users", "facenumber_in_poster","num_user_for_reviews","budget"
                          ,"imdb_score")



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

plot_animation_month <- function(Genreslist_Animation){
  
  if(length(Genreslist_Animation)==0) return()
  
  p <- 
    animation_data %>%  
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

plot_animation_year <- function(Genreslist_Animation){
  
  if(length(Genreslist_Animation)==0) return()
  
  p <- 
    animation_data %>%  
    drop_na(year) %>% 
    filter(genres %in% Genreslist_Animation) %>% 
    group_by(genres, year) %>%
    summarize(mean_gross = mean(gross)) %>% 
    filter(year > 1990) %>% 
    as_tibble() %>% 
    ggplot(aes(x = as.factor(year), y = mean_gross, group = genres)) + 
    geom_line(aes(color = genres), size = 1) + 
    geom_point(aes(color = genres), size = 2) + 
    labs(title = "Trends of mean_gross by genres over years",
         x = "Year", 
         y = "Mean Gross") +
    scale_x_discrete(name ="Year",labels = c("1927" = "", "1928" = "")) +
    theme(axis.text.x = element_text(angle = 45))
  p <- p + transition_reveal(year)
  return(p)
}




## 3. Circular plot

plot_circulate <- function(Genrelist_Circulate)
{
  data <-
    circulation_data %>% 
    filter(genres %in% Genrelist_Circulate) 
  data = data %>% arrange(genres)
  data$id = seq(1, nrow(data))
  
  label_data = data
  number_of_bar = nrow(label_data)
  angle = 90 - 360 * (label_data$id-0.5) /number_of_bar   
  label_data$hjust = ifelse( angle < -90, 1 - 0.15, 0 + 0.15) # Where is the word
  label_data$angle = ifelse( angle < -90, angle+180, angle)
  
  fplot = 
    ggplot(data, aes(x=as.factor(id), y=gross, fill=genres)) +   
    geom_bar(aes(x=as.factor(id), y=gross, fill=genres), stat="identity", alpha=0.5) +
    ylim(-200000000, max(data$gross)) +
    theme_minimal() +
    theme(
      legend.position = c(.85,.85),
      axis.text = element_blank(),
      axis.title = element_blank(),
      panel.grid = element_blank(),
      plot.margin = unit(rep(-1,4), "cm") 
    ) +
    coord_polar() + 
    geom_text(data=label_data, aes(x=id, y=gross, label=movie_title, hjust=hjust), 
              color="black", fontface="bold",alpha=0.6, size = 2.5,
              angle= label_data$angle , inherit.aes = FALSE) 
  
  return(fplot)
}



## 4. Gross vs. IMDb_score (the marker size represents the budget level):

plot_grossplus <- function(Genrelist_Animation_2, selected_var)
{
  if(is.na(selected_var)) return()
  
  p <- 
    plotly_df %>% 
    filter(genres %in% Genrelist_Animation_2, title_year > 1980, imdb_score > 3) %>% 
    mutate(genres = as.factor(genres)) 
  
  #namelist <- names(p)
  
  #var <- namelist[namelist == selected_var]
  
  gg <- ggplot(p, aes_string(x = selected_var, y = 'gross', color = 'genres')) +
    geom_point(aes(frame = genres, ids = movie_title)) +
    theme(legend.position = "none") +
    geom_smooth(aes(frame = genres), method = "lm", se= F)
  ggplotly(gg)
  
  
  return(gg)
  
}

## Wordcloud

plot_wordcloud <- function(Genrelist_Wordcloud)
{

  
  genre_list = wordcloud_data %>% 
    select(genres) %>% 
    mutate(genres = factor(genres)) %>% 
    pull(., genres) %>% 
    levels() %>% 
    as_vector()
  
  imdb_new = wordcloud_data %>% 
    filter(genres %in% Genrelist_Wordcloud) %>% 
    select(-genres)
  
  wordlist =  
    unlist(imdb_new %>% drop_na(plot_keyword) %>% pull(plot_keyword)) %>% 
    as_tibble()
  
  colnames(wordlist) = "word"
  
  `%nin%` = Negate(`%in%`)
  
  wordcloud_df =
    wordlist %>%
    filter(word %nin% genre_list) %>% 
    group_by(word) %>% 
    summarise(freq = n()) %>% 
    arrange(desc(freq))
  
  return(wordcloud_df)
}


#################################
##     Functions for dfs:      ##
#################################

## 1. Radar plot

Radar_df <- function(Genrelist_Radar_df){
  output<-
    radarplot_df %>% 
    filter(genres %in% Genrelist_Radar_df) %>% 
    column_to_rownames("genres") %>%
    t() %>% 
    as.data.frame() %>% 
    rownames_to_column("Variable") %>% 
    as_tibble()
  return(output)
}

## 2. Circulation plot
Circulation_df <- function(Genrelist_cir_df){
  output <-
    circulation_data %>% 
    filter(genres %in% Genrelist_cir_df) %>% 
    select(movie_title, director_name, gross, title_year) %>% 
    arrange(-gross) %>% 
    distinct(movie_title, .keep_all = T)
  
  return(output)
}

## 3. Word cloud

Word_df <- function(Genrelist_wc){
  output <-
    wordcloud_data %>% 
    filter(genres %in% Genrelist_wc) %>% 
    group_by(genres, plot_keyword) %>% 
    summarise(freq = n()) %>% 
    arrange(desc(freq))
  return(output)
}
