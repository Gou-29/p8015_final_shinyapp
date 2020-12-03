#Circulation plot

imdb_cir <- read_csv("./Dataset/imdb_explore_clean.csv")

imdb_cir <-
  imdb_cir %>% 
  select(movie_title, director_name, title_year, gross, genres) %>% 
  distinct(movie_title, genres,  .keep_all = T)

valuelist <- unique(pull(imdb_cir, gross))

valuelist <- sort(valuelist, decreasing = T)[1:50]

imdb_cir_final <-
  imdb_cir %>% 
  filter(gross %in% valuelist) %>% 
  arrange(gross)

write_csv(imdb_cir_final, "./Dataset/shiny_circulation.csv")
