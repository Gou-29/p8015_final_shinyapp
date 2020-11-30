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
                                             choices = c("1949" = 1949, "1950" = 1950, "1951" = 1951,
                                                         "1952" = 1952, "1953" = 1953, "1954" = 1954,
                                                         "1955" = 1955, "1956" = 1956, "1957" = 1957,
                                                         "1958" = 1958, "1959" = 1959, "1960" = 1960), 
                                             inline=TRUE,
                                             selected = c("1949","1950")
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