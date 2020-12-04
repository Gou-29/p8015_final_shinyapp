#ui.R
dashboardPage(
  skin = "yellow",
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
             tabPanel("TOP plots",
                      fluidRow(
                        column(8, wordcloud2Output('wordcloud2', width = 800, height = 600)),
                        column(4,
                               box(title = "Top plots in selected genres:",
                                   solidHeader = T,
                                   width = 12,
                                   collapsible = T,
                                   div(DT::DTOutput("test_df_3"), style = "font-size: 100%;")))
                      )
                      
             ),
             tabPanel("Radar plot", id = "radar", 
                      fluidRow( 
                        column(6, plotlyOutput("plot1")),
                        column(6, plotlyOutput("plot2"))),
                      fluidRow(
                        column(12, 
                        box(title = "Data in actual scale:",
                                    solidHeader = T,
                                    width = 12,
                                    collapsible = T,
                                    div(DT::DTOutput("test_df"), style = "font-size: 100%;"))))

             ),
             tabPanel("Mean_Gross over time",
                      #fluidRow(
                      #  column(1),
                      #  actionButton("update", "upadte_plot")),
                      fluidRow(
                        column(1),
                        column(4, imageOutput("plot3")),
                        column(2),
                        column(4, imageOutput("plot4")),
                        column(1)
                      )
             ),
             tabPanel("Gross vs. ?",
                      fluidRow(
                        column(6, plotlyOutput("plot6", width = 400, height = 400)),
                        column(6, plotlyOutput("plot7", width = 400, height = 400))
                      ),
                      fluidRow(
                        column(6, plotlyOutput("plot8", width = 400, height = 400)),
                        column(6, plotlyOutput("plot9", width = 400, height = 400))
                      )
                      
             ),
             tabPanel("Circulation plot",
                      fluidRow(
                        column(7, imageOutput("plot5", height = 800)), 
                        column(5, 
                               box(title = "Top Movies in history:",
                                   solidHeader = T,
                                   width = 12,
                                   collapsible = T,
                                   div(DT::DTOutput("test_df_2"), style = "font-size: 100%;")))
                               )
                      
             )
             
             
      )
    )
  )
)



