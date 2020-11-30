## Trends of mean_gross by genres over months

library(gganimate)

imdb_clean = read_csv("./data/movie_metadata.csv") %>% 
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
imdb_ymd = read_csv("./data/imdb_ymd.csv") %>% 
  select(-movie_imdb_link)
month_df = 
  tibble(
    month_value = 1:12,
    month = month.name
  )

imdb_m = left_join(imdb_ymd, month_df, by = "month") %>% 
  select(-month) %>% 
  mutate(month = month_value, .keep = "unused")

imdb_clean_ymd = left_join(imdb_clean,imdb_m,by = "movie_title")


p <- imdb_clean_ymd %>%
  select(gross, genres, month) %>% 
  drop_na(month) %>% 
  filter(genres %in% c("Action", "Horror")) %>% 
  group_by(genres, month) %>%
  summarize(mean_gross = mean(gross)) %>%
  ggplot(aes(x = as.factor(month), y = mean_gross, group = genres)) + 
  geom_line(aes(color = genres), size = 1) + 
  geom_point(aes(color = genres), size = 2) + 
  labs(title = "Trends of mean_gross by genres over months",
       x = "Month", 
       y = "Mean Gross") +
  theme(axis.text.x = element_text(angle = 45))
p + transition_reveal(month)