# ui.R

navbarPage("Title",
           tabPanel("Graphic",fluidPage(theme = shinytheme("flatly")),
                    tags$head(
                      tags$style(HTML(".shiny-output-error-validation{color: red;}"))),
                    pageWithSidebar
                    (
                        headerPanel('Filters'),
                        sidebarPanel(
                          width = 4, 
                          checkboxGroupInput(inputId = "year",
                                             label = 'year:', 
                                             choices = c("Action"="Action",
                                                         "Adventure"="Adventure",
                                                         "Animation"="Animation",
                                                         "Biography"="Biography",
                                                         "Comedy"="Comedy",
                                                         "Crime"="Crime",
                                                         "Documentary"="Documentary",
                                                         "Drama"="Drama",
                                                         "Family"="Family",
                                                         "Fantasy"="Fantasy",
                                                         "Film-Noir"="Film-Noir",
                                                         "History"="History",
                                                         "Horror"="Horror",
                                                         "Music"="Music",
                                                         "Musical"="Musical",
                                                         "Mystery"="Mystery",
                                                         "News"="News",
                                                         "Romance"="Romance",
                                                         "Sci-Fi"="Sci-Fi",
                                                         "Short"="Short",
                                                         "Sport"="Sport",
                                                         "Thriller"="Thriller",
                                                         "War"="War",
                                                         "Western"="Western"), 
                                             inline=TRUE,
                                             selected = c("Action","Sci-Fi")
                                             ),
                          submitButton("Update filters")),
                        mainPanel(
                          p("This is the plot", style = "font-size:25px"),
                          plotlyOutput("plot", width = 800, height=700),
                          )
                    )),
           tabPanel("About",
                    p("Some text"))
)