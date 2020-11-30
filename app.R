library(shiny)
library(shinydashboard)
library(shinythemes)
library(plotly)
library(tidyverse)
library(shinycssloaders)
library(tidyverse)
library(wordcloud2)

radarplot_data <- read_csv("shiny_radar.csv")
name_list_radar <- c("movie_title","genres","num_critic_for_reviews",
                     "duration","director_facebook_likes","actor_3_facebook_likes",
                     "actor_2_facebook_likes","actor_1_facebook_likes"
                     ,"num_voted_users", "facenumber_in_poster","num_user_for_reviews","budget"
                     ,"imdb_score","aspect_ratio","movie_facebook_likes")



ui <- dashboardPage(
  dashboardHeader(
    title = "CRAN whales"
  ),
  dashboardSidebar(
    checkboxGroupInput(inputId = "year",
                       label = 'year:', 
                       choices = c("Action" = "Action",
                                   "Adventure" = "Adventure",
                                   "Animation" = "Animation",
                                   "Biography" = "Biography",
                                   "Comedy" = "Comedy",
                                   "Crime" = "Crime",
                                   "Documentary" = "Documentary",
                                   "Drama" = "Drama",
                                   "Family" = "Family",
                                   "Fantasy" = "Fantasy",
                                   "Film-Noir" = "Film-Noir",
                                   "History" = "History",
                                   "Horror" = "Horror",
                                   "Music" = "Music",
                                   "Musical" = "Musical",
                                   "Mystery" = "Mystery",
                                   "News" = "News",
                                   "Romance" = "Romance",
                                   "Sci-Fi" = "Sci-Fi",
                                   "Short" = "Short",
                                   "Sport" = "Sport",
                                   "Thriller" = "Thriller",
                                   "War" = "War",
                                   "Western" = "Western"), 
                       inline = TRUE,
                       selected = c("Action","Sci-Fi")
    ),
    submitButton("Update filters")
  ),
  dashboardBody(
    fluidRow(
      tabBox(id = "tab", width = 12,
             tabPanel("All traffic",
                      fluidRow(
                        column(6, plotlyOutput("plot1")),
                        column(6, plotlyOutput("plot4")),
                      ), 
                      fluidRow(
                        column(6, plotlyOutput("plot5")),
                        column(6, plotlyOutput("plot6")),
                      )
             ),
             tabPanel("Biggest whales",
                      plotlyOutput("plot2", width = 800, height = 500)
             ),
             tabPanel("Whales by hour",
                      plotlyOutput("plot3", width = 800, height = 500)
             )
      )
    )
  )
)





server <- function(input, output) {
  selectdata <- function(Genres, Tibble){
    value_vector <- 
      Tibble %>% 
      filter(genres == Genres) %>% 
      pull(value)
    return(value_vector)
  }
  
  add_closed_trace <- function(p, r, theta, ...) 
  {
    plotly::add_trace(p, r = c(r, r[1]), theta = c(theta, theta[1]), ...)
  }
  
  plot_the_fig <- function(Genreslist){
    
    output <- plot_ly(
      type = 'scatterpolar',
      mode = "closest")#,
    #fill = "toself")
    
    for (i in 1:length(Genreslist)) {
      output <- 
        output %>% 
        add_closed_trace(
          r = selectdata(Genreslist[i],radarplot_data),
          theta = name_list_radar[3:15],
          showlegend = T,
          mode =  "toself",
          name = Genreslist[i]) 
    }
    
    return(output)
  }
  
  output$plot1 <- renderPlotly({ 
    
    validate(need(length(input$year) > 0, "please select"))
    
    plot_the_fig(input$year)})
  
  output$plot2 <- renderPlotly({ 
    
    validate(need(length(input$year) > 0, "please select"))
    
    plot_the_fig(input$year)})
  
  output$plot3 <- renderPlotly({ 
    
    validate(need(length(input$year) > 0, "please select"))
    
    plot_the_fig(input$year)})
  
  output$plot4 <- renderPlotly({ 
    
    validate(need(length(input$year) > 0, "please select"))
    
    plot_the_fig(input$year)})
  
  output$plot5 <- renderPlotly({ 
    
    validate(need(length(input$year) > 0, "please select"))
    
    plot_the_fig(input$year)})
  
  output$plot6 <- renderPlotly({ 
    
    validate(need(length(input$year) > 0, "please select"))
    
    plot_the_fig(input$year)})
  
}

shinyApp(ui, server)