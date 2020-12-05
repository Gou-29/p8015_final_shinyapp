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
library(broom)

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
valuebox_df = read_csv("./Dataset/shiny_valuedf.csv")

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
    theme(axis.text.x = element_text(angle = -45),
          plot.title = element_text(hjust = 0.5)) 
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
    theme(axis.text.x = element_text(angle = 45),
          plot.title = element_text(hjust = 0.5))
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

## 4. Gross vs. IMDb_score + the regression line

plot_grossplus <- function(Genrelist_gross, selected_var)
{
  if(is.na(selected_var)) return()
  
  p <- 
    plotly_df %>% 
    filter(genres %in% Genrelist_gross, title_year > 1980, imdb_score > 3) %>% 
    mutate(genres = as.factor(genres)) %>% 
    select(gross, selected_var, genres, movie_title)
  
  gg <- ggplot(p, aes_string(x = selected_var, y = 'gross', color = 'genres')) +
    geom_point(aes(frame = genres, ids = movie_title, alpha = gross)) +
    theme(legend.position = "none",
          plot.title = element_text(hjust = 0.5)) + 
    xlab(label = "") +
    geom_smooth(aes(frame = genres), method = "lm", se= F) +
    ggtitle(str_c("Versus ", selected_var))
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
  
  if(length(Genrelist_Radar_df) == 0) return()
  
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
Valubox_df <- function(Genrelist_cir_df){
  
  if(length(Genrelist_cir_df) == 0) return()
  output <-
    valuebox_df %>% 
    filter(genres %in% Genrelist_cir_df) %>% 
    select(movie_title, director_name, gross, title_year) %>% 
    arrange(-gross) %>% 
    distinct(movie_title, .keep_all = T)
  
  return(output)
}


Circulation_df <- function(Genrelist_cir_df){
  
  if(length(Genrelist_cir_df) == 0) return()
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
  
  if(length(Genrelist_wc) == 0) return()
  output <-
    wordcloud_data %>% 
    filter(genres %in% Genrelist_wc) %>% 
    group_by(genres, plot_keyword) %>% 
    summarise(freq = n()) %>% 
    arrange(desc(freq))
  return(output)
}

## Regression

gross_lm_df <- function(Genrelist_lm, selected_var)
{
  if(length(selected_var)==0) return()
  
  if(is.na(selected_var)) return()
  
  if(length(Genrelist_lm)==0) return()
  
  lm_df <- 
    plotly_df %>% 
    filter(genres %in% Genrelist_lm, title_year > 1980, imdb_score > 3) %>% 
    select(gross, selected_var, genres)
  
  lm_result <- tibble(Terms = "",Value = 0,  genres = "")
  
  
  #return(lm_result)
  for (t in Genrelist_lm)
  {
    lm_df_sub <-
      lm_df %>% 
      filter(genres == t) %>% 
      select(-genres)
    
    
    lm_result_sub  <- lm(gross~., data = lm_df_sub) 
    lm_result_sub <-  
      broom::tidy(lm_result_sub) %>% 
      pivot_longer(estimate:p.value, 
                   names_to = "Terms", 
                   values_to = "Value") %>% 
      slice(-1,-2,-3,-4) %>% 
      mutate(genres = t) %>% 
      select(-term) %>% 
      mutate(Value = round(Value, 3))
    
    lm_result <-
      rbind(lm_result, lm_result_sub)
  }
  
  lm_result <-
    lm_result %>% 
    slice(-1) %>% 
    mutate(Terms = str_replace(Terms, "statistic", "t.stat"))
  
  
  return(lm_result)
  
}



## Animation plot


animation_month_df <- function(Genrelist_month_df)
{
  if(length(Genrelist_month_df) == 0) return()
  
  ot <- 
    animation_data %>% 
    select(-year) %>% 
    group_by(genres, month) %>% 
    summarise(N= n(),
              mean_imdb_score = round(mean(imdb_score, na.rm = T),3),
              mean_Gross = round(mean(gross, na.rm = T),3))
  return(ot)
}


animation_year_df <- function(Genrelist_year_df)
{
  if(length(Genrelist_year_df) == 0) return()
  
  ot1 <- 
    animation_data %>% 
    select(-month) %>% 
    group_by(genres, year) %>% 
    summarise(N= n(),
              mean_imdb_score = round(mean(imdb_score, na.rm = T),3),
              mean_Gross = round(mean(gross, na.rm = T),3)) %>% 
    arrange(desc(year))
  return(ot1)
}
