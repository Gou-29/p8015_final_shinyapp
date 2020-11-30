#ui.R

dashboardPage(
  dashboardHeader(
    title = "CRAN whales"
  ),
  dashboardSidebar(
    checkboxGroupInput(inputId = "GenreList",
                       label = 'Genre:', 
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



