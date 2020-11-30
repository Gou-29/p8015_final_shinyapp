# Global. R

library(shiny)
library(shinydashboard)
library(shinythemes)
library(plotly)
library(tidyverse)
library(shinycssloaders)
library(tidyverse)

pacotes = c("shiny", "shinydashboard", "shinythemes", "plotly", "shinycssloaders","tidyverse","knitr")

# Run the following command to verify that the required packages are installed. If some package
# is missing, it will be installed automatically
#package.check <- lapply(pacotes, FUN = function(x) {
#  if (!require(x, character.only = TRUE)) {
#    install.packages(x, dependencies = TRUE)
#  }
#})

# Define working directory
data <- 
  matrix(data = AirPassengers, 
         nrow = 12, 
         ncol = 12,
         byrow = T, 
         dimnames = list(NULL,month.abb)) %>% 
  as_tibble() %>% 
  mutate(year = 1949:1960) %>% 
  pivot_longer(Jan:Dec,
               names_to = "month",
               values_to = "value")

