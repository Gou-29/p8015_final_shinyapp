# Plotly

df1 = read_csv("./Dataset/imdb_explore_clean.csv") %>% 
  select(movie_title,genres, gross, num_critic_for_reviews,duration,director_facebook_likes,
         actor_3_facebook_likes,actor_2_facebook_likes,actor_1_facebook_likes,
         num_voted_users, facenumber_in_poster, num_user_for_reviews,
         budget, imdb_score, aspect_ratio, movie_facebook_likes, title_year) %>% 
  mutate(title_year = as.numeric(title_year)) %>% 
  distinct(movie_title, genres, .keep_all = T)
  

write_csv(df1, "./Dataset/shiny_plotly.csv")