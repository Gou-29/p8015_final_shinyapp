#ui.R
dashboardPage(
  skin = "yellow",
  dashboardHeader(
    title = "IMDb Explore!"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
    checkboxGroupInput(inputId = "GenreList",
                       label = 'Select Genre:', 
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
                                   "History" = "History",
                                   "Horror" = "Horror",
                                   "Music" = "Music",
                                   "Musical" = "Musical",
                                   "Mystery" = "Mystery",
                                   "Romance" = "Romance",
                                   "Sci-Fi" = "Sci-Fi",
                                   "Sport" = "Sport",
                                   "Thriller" = "Thriller",
                                   "War" = "War",
                                   "Western" = "Western"), 
                       inline = TRUE,
                       selected = c("Action","Sci-Fi")
    )),
    menuItem(submitButton("Update filters")),
    menuItem(text = "Back to homepage", href = "https://seriousbamboo.github.io/p8105_IMDb.github.io/"),
    menuItem(text = "Github Code for the website", href = "https://github.com/Gou-29/p8015_final_shinyapp"))
  ),
  dashboardBody(
    fluidRow(
      valueBoxOutput("A"),
      valueBoxOutput("B"),
      valueBoxOutput("C")
    ),
    fluidRow(
      tabBox(id = "tab", width = 12,
             tabPanel("TOP Words In Movies",
                      fluidRow(
                        column(8, wordcloud2Output('wordcloud2', width = 800, height = 600)),
                        column(4,
                               box(title = "Top words in selected genres:",
                                   solidHeader = T,
                                   width = 12,
                                   collapsible = T,
                                   div(DT::DTOutput("Wordcloud"), style = "font-size: 100%;")))
                      )
                      
             ),
             tabPanel("Historical TOP 50",
                      fluidRow(
                        column(7, imageOutput("plot5", height = 800)), 
                        column(5, 
                               box(title = "In selected genres, they are in history top 50:",
                                   solidHeader = T,
                                   width = 12,
                                   collapsible = T,
                                   div(DT::DTOutput("Circulation"), style = "font-size: 100%;")))
                      )
                      
             ),
             tabPanel("Mean Gross box office over time",
                      fluidRow(
                        column(1),
                        column(4, imageOutput("plot3")),
                        column(2),
                        column(4, imageOutput("plot4")),
                        column(1)
                      ),
                      fluidRow(
                        column(6,
                               box(title = "Source Data:",
                                   solidHeader = T,
                                   width = 12,
                                   collapsible = T,
                                   div(DT::DTOutput("animation_1"), style = "font-size: 100%;"))),
                        column(6,
                               box(title = "Source Data:",
                                   solidHeader = T,
                                   width = 12,
                                   collapsible = T,
                                   div(DT::DTOutput("animation_2"), style = "font-size: 100%;")))
                        
                      )
             ),
             tabPanel("Gross box office vs. Everything!",
                      fluidRow(
                        box(width = 8, 
                        checkboxGroupInput(inputId = "varlist",
                                           label = 'Please Select Varibale:', 
                                           choices = c("num_critic_for_reviews" = "num_critic_for_reviews",
                                                       "num_voted_users" = "num_voted_users",
                                                       "num_user_for_reviews" = "num_user_for_reviews",
                                                       "duration" = "duration",
                                                       "imdb_score" = "imdb_score",
                                                       "budget" = "budget",
                                                       "facenumber_in_poster" = "facenumber_in_poster",
                                                       "director_facebook_likes" = "director_facebook_likes",
                                                       "actor_1_facebook_likes" = "actor_1_facebook_likes",
                                                       "actor_2_facebook_likes" = "actor_2_facebook_likes",
                                                       "actor_3_facebook_likes" = "actor_3_facebook_likes",
                                                       "movie_facebook_likes" = "movie_facebook_likes"
                                                       ), 
                                           inline = TRUE,
                                           selected = c("num_critic_for_reviews","imdb_score")
                        ),
                        submitButton("Update Variable list")),
                        box(width = 4, 
                            title = "Note",
                            "Pleaes select no more than 4 variables. Additional varialbles wil be ignored. For regression,
                            a single linear regression is conduct. The regression coefficient, standard error of coefficeint
                            , t statistics and p value of the slope are reported")
                      ),
                      
                      fluidRow(
                        column(3, plotlyOutput("plot6", width = 350, height = 450)),
                        column(3, 
                               box(title = "Regression results:",
                                   solidHeader = T,
                                   width = 12,
                                   collapsible = T,
                                   div(DT::DTOutput("lm_1"), style = "font-size: 100%;"))),
                        column(3, plotlyOutput("plot7", width = 350, height = 450)), #width = 400, height = 400)),
                        column(3, 
                               box(title = "Regression results:",
                                   solidHeader = T,
                                   width = 12,
                                   collapsible = T,
                                   div(DT::DTOutput("lm_2"), style = "font-size: 100%;")))
                      ),
                      fluidRow(
                        column(3, plotlyOutput("plot8", width = 350, height = 450)), #width = 400, height = 400)),
                        column(3, 
                               box(title = "Regression results:",
                                   solidHeader = T,
                                   width = 12,
                                   collapsible = T,
                                   div(DT::DTOutput("lm_3"), style = "font-size: 100%;", height = "20%"))),
                        column(3, plotlyOutput("plot9", width = 350, height = 450)), #width = 400, height = 400)),
                        column(3, 
                               box(title = "Regression results:",
                                   solidHeader = T,
                                   width = 12,
                                   collapsible = T,
                                   div(DT::DTOutput("lm_4"), style = "font-size: 100%;", height = "20%")))
                      )
                      
             ),
             tabPanel("Radar Analysis", id = "radar", 
                      fluidRow( 
                        column(6, plotlyOutput("plot1")),
                        column(6, plotlyOutput("plot2"))),
                      fluidRow(
                        column(12, 
                               box(title = "Data in actual scale:",
                                   solidHeader = T,
                                   width = 12,
                                   collapsible = T,
                                   div(DT::DTOutput("Radar"), style = "font-size: 100%;"))))
                      
             )

             
             
      )
    )
  )
)



