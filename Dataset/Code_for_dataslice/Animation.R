# Animation 
imdb_clean = read_csv("./dataset/movie_metadata.csv") %>% 
  drop_na(movie_title, gross) %>% 
  mutate(movie_title = str_replace(movie_title,"\\?$","")) %>% 
  separate(genres,
           sep = "\\|",
           into = c("g1","g2","g3","g4","g5","g6","g7","g8")) %>% 
  pivot_longer(g1:g8,
               names_to = "dummy",
               values_to = "genres") %>%
  select(-dummy) %>% 
  drop_na(genres)

imdb_ymd = read_csv("./dataset/imdb_ymd.csv") %>% 
  select(-movie_imdb_link)

month_df = 
  tibble(
    month_value = 1:12,
    month = month.name
  )

imdb_m = left_join(imdb_ymd, month_df, by = "month") %>% 
  select(-month) %>% 
  mutate(month = month_value, .keep = "unused")

imdb_cleanymd = left_join(imdb_clean,imdb_m,by = "movie_title")
imdb_cleanymd %>% 
  select(gross, genres, month, year, imdb_score) %>% 
  write_csv("./data/shiny_animation.csv")