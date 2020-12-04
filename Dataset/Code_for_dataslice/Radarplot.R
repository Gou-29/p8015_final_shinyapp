########################################
##            Shiny data              ##
########################################
## Radar plot

### Step 1. Extract relevant data:

imdb_vis <- read_csv("./Dataset/imdb_explore_clean.csv")

imdb_radar <-
  imdb_vis %>% 
  select(movie_title,genres, gross, num_critic_for_reviews,duration,director_facebook_likes,
         actor_3_facebook_likes,actor_2_facebook_likes,actor_1_facebook_likes,
         num_voted_users, facenumber_in_poster, num_user_for_reviews,
         budget, imdb_score, aspect_ratio, movie_facebook_likes) %>% 
  distinct(movie_title,genres,.keep_all = TRUE) 

imdb_radar_raw = imdb_radar

name_list_radar = names(imdb_radar)


### Step 2. Functions for summarize:

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


group_without_standardize <- function(Tibble)
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
      select(dummy)
    Tibble_begin = cbind(Tibble_begin,Tibble_process)
  }
  return(Tibble_begin)
}


## The final data

imdb_radar <- group_and_standardize(imdb_radar)
names(imdb_radar) = c("genres","N", name_list_radar[3:length(name_list_radar)])
imdb_radar <-
  imdb_radar %>% 
  as_tibble() %>% 
  #select(N) %>% 
  mutate(N = (N - min(N))/(max(N)-min(N))) %>% 
  pivot_longer(N:movie_facebook_likes,
               names_to = "variable",
               values_to = "value")

write_csv(imdb_radar,"./Dataset/shiny_radar.csv")


imdb_radar_raw <- group_without_standardize(imdb_radar_raw)
names(imdb_radar_raw) = c("genres","N", name_list_radar[3:length(name_list_radar)])
imdb_radar_raw <-
  imdb_radar_raw %>% 
  as_tibble() 

write_csv(imdb_radar_raw,"./Dataset/shiny_radar_df.csv")