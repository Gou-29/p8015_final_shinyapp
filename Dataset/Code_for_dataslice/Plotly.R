# Plotly

df1 = read_csv("./Dataset/imdb_explore_clean.csv") %>% 
  select(movie_title, genres, title_year, gross, budget, imdb_score) %>% 
  mutate(title_year = as.numeric(title_year)) %>%
  write_csv("./Dataset/shiny_plotly.csv")