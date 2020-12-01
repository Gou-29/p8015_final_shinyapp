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
             tabPanel("Radar plot",
                      fluidRow(
                        column(6, plotlyOutput("plot1")),
                        column(6, plotlyOutput("plot2")),
                      )
             ),
             tabPanel("Animation plot",
                      imageOutput("plot3", width = 800, height = 500)
             ),
             tabPanel("Whales by hour",
                      plotlyOutput("plot4", width = 800, height = 500)
             )
      )
    )
  )
)



