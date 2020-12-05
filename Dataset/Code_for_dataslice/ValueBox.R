# Data for valuebox:

df <- 
  read_csv("./Dataset/imdb_explore_clean.csv") %>% 
  select(movie_title, director_name, gross, title_year, genres) %>% 
  distinct(movie_title, genres, .keep_all = T)

genrelist <- unique(pull(df,genres))


df_final <-
  tibble(movie_title = "",
         director_name = "",
         gross = 0,
         title_year = 0,
         genres = "")


for (g in genrelist){
  
  df_sub <- 
    df %>% 
    filter(genres == g) %>% 
    arrange(gross = desc(gross)) %>% 
    slice(1:3)
  
  df_final <- rbind(df_final, df_sub)
    

  
}


df_final %>%
  slice(-1) %>% 
  write_csv("./Dataset/shiny_valuedf.csv")
