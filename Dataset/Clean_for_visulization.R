### Include libraries
library(tidyverse)
library(stringr)
library(xml2)
library(rvest)
### Import data
imdb_raw = read_csv("./movie_metadata.csv")

### Get the year month date:

get_ymd <- function(url_raw)
{
  url = str_replace(url_raw,"\\?ref","releaseinfo?ref")
  swm_html = read_html(url)
  ymd = 
    swm_html %>% 
    html_nodes(css = ".release-date-item:nth-child(1) .release-date-item__date") %>% 
    html_text()
  return(ymd)
}

#imdb = 
#  imdb_raw %>% 
#  mutate(ymd = map(movie_imdb_link, get_ymd)) %>% 
#  unnest(ymd)

### Cleaning
imdb_clean = 
  imdb_raw %>%
  drop_na(movie_title, gross) %>% 
  mutate(movie_title = str_replace(movie_title,"\\?$","")) %>% 
  separate(genres,
           sep = "\\|",
           into = c("g1","g2","g3","g4","g5","g6","g7","g8")) %>% 
  pivot_longer(g1:g8,
               names_to = "dummy",
               values_to = "genres") %>%
  select(-dummy) %>% 
  drop_na(genres) %>% 
  separate(plot_keywords, 
           sep = "\\|",
           into = c("g1","g2","g3","g4","g5","g6","g7","g8")) %>% 
  pivot_longer(g1:g8,
               names_to = "dummy",
               values_to = "plot_keyword") %>%
  select(-dummy) %>% 
  drop_na(plot_keyword) %>% 
  write_csv(.,"./imdb_explore_clean.csv")

### Get the date of onboarding:




##

## Radar
imdb_vis <- read_csv("./Dataset/imdb_explore_clean.csv")

imdb_radar <-
  imdb_vis %>% 
  select(movie_title,genres, num_critic_for_reviews,duration,director_facebook_likes,
         actor_3_facebook_likes,actor_2_facebook_likes,actor_1_facebook_likes,
         num_voted_users, facenumber_in_poster, num_user_for_reviews,
         budget, imdb_score, aspect_ratio, movie_facebook_likes) %>% 
  distinct(movie_title,genres,.keep_all = TRUE) 

name_list_radar = names(imdb_radar)

group_and_standardize <- function(Tibble)
{
  name_list_radar = names(Tibble)
  Tibble_begin <- 
    Tibble %>% 
    select(name_list_radar[2]) %>% 
    group_by(genres) %>% 
    summarise(n=n())
  
  for (i in 3:length(name_list_radar))
  {
    Tibble_process <- 
      Tibble %>% 
      select(name_list_radar[2],name_list_radar[i]) %>% 
      rename(dummyname = name_list_radar[i]) %>% 
      group_by(genres) %>% 
      summarise(dummy = mean(dummyname, na.rm = T)) %>% 
      mutate(dummy = (dummy - min(dummy, na.rm = T))/(max(dummy, na.rm = T)- min(dummy, na.rm = T))) %>% 
      select(dummy)
    Tibble_begin = cbind(Tibble_begin,Tibble_process)
  }
  return(Tibble_begin)
}


imdb_radar <- group_and_standardize(imdb_radar)
names(imdb_radar) = c("genres","N", name_list_radar[3:length(name_list_radar)])
imdb_radar <-
  imdb_radar %>% 
  as_tibble() %>% 
  select(-N) %>% 
  pivot_longer(num_critic_for_reviews:movie_facebook_likes,
             names_to = "variable",
             values_to = "value")

write_csv(imdb_radar,"./Dataset/shiny_radar.csv")

