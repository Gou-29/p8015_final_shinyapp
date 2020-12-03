#ui.R

dashboardPage(
  dashboardHeader(
    title = "IMDb"
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
      valueBoxOutput("A"),
      valueBoxOutput("B"),
      valueBoxOutput("C")
    ),
    fluidRow(
      tabBox(id = "tab", width = 12,
             tabPanel("Radar plot",
                      fluidRow(
                        column(6, plotlyOutput("plot1")),
                        column(6, plotlyOutput("plot2")),
                      box(title = "Test df",
                            solidHeader = T,
                            width = 12,
                            collapsible = T,
                            div(DT::DTOutput("test_df"), style = "font-size: 100%;")),
                      )
             ),
             tabPanel("Animation plot",
                      fluidRow(
                        column(6, imageOutput("plot3")),
                        column(6, imageOutput("plot4")),
                      )
             ),
             tabPanel("Circulation",
                      imageOutput("plot5", width = 1200, height = 800)
             ),
             tabPanel("Circulation 2",
                      plotlyOutput("plot6", width = 1200, height = 800)
             )
      )
    )
  )
)



