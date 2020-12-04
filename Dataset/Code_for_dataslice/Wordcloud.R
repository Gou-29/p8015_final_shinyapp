#Wordcloud

imdb_raw = 
  read_csv("imdb_explore_clean.csv") %>% 
  select(genres, plot_keyword) %>% 
  write.csv("./Dataset/shiny_keyword.csv")