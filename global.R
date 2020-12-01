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

# Global setting for plot:

theme_set(theme_minimal() + theme(legend.position = "bottom"))
options(
  ggplot2.continuous.colour = "viridis",
  ggplot2.continuous.fill = "viridis"
)
scale_colour_discrete = scale_color_viridis_d
scale_fill_discrete = scale_fill_viridis_d



#The data for plot

radarplot_data <- read_csv("shiny_radar.csv")
animation_data <- read_csv("shiny_animation.csv")
circulation_data = read_csv("shiny_circulate.csv")

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
    ylim(-500000000, max(data$gross)) +
    theme_minimal() +
    theme(
      legend.position = "right",
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

## 4. Animation 2:

plot_animation_2 <- function(Genrelist_Animation_2)
{
  accumulate_by <- function(dat, var) {
    var <- lazyeval::f_eval(var, dat)
    lvls <- plotly:::getLevels(var)
    dats <- lapply(seq_along(lvls), function(x) {
      cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
    })
    dplyr::bind_rows(dats)
  }
  
  p <- 
    animation_data %>%  
    drop_na(month) %>% 
    filter(genres %in% Genrelist_Animation_2) %>% 
    group_by(genres, month) %>%
    summarize(mean_gross = mean(gross))
  
  p <- p %>% accumulate_by( ~ month)
  
  p <- p %>%
    plot_ly(
      x = ~month, 
      y = ~mean_gross,
      split = ~ genres,
      frame = ~frame, 
      type = 'scatter',
      mode = 'lines + markers', 
      line = list(simplyfy = F),
      marker = list(size = 10)
    )
  p <- p %>% layout(
    xaxis = list(
      title = "Month",
      zeroline = F
    ),
    yaxis = list(
      title = "Mean_Gross",
      zeroline = F
    )
  ) 
  p <- p %>% animation_opts(
    frame = 100, 
    transition = 0, 
    redraw = FALSE
  )
  p <- p %>% animation_slider(
    hide = T
  )
  p <- p %>% animation_button(
    x = 1, xanchor = "right", y = 0, yanchor = "bottom"
  )
  
  return(p)
  
}
