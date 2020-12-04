# ymd

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

for (i in 1:nrow(dataset_r)) {
  test_df = read_csv("./data/imdb_release.csv")
  if (is.na(test_df[[3]][i])) {
    test_df[[3]][i] <- get_ymd(test_df[[2]][i])
  } 
  test_df %>% 
    write_csv(.,"./data/imdb_release.csv")
}

imdb_ymd = read_csv("./data/imdb_release.csv") %>% 
  separate(release_date, into = c("day","month","year"), sep = " ", fill = "left") %>% 
  write_csv(.,"./data/imdb_ymd.csv")