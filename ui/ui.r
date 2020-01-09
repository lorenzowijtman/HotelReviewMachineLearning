ui <- navbarPage("Data Science 2", id="nav",
                 
                 tabPanel("Interactive map",
                          div(class="outer",
                              
                              tags$head(
                                # Include our custom CSS
                                includeCSS("ui/styles.css")
                              ),
                              
                              # If not using custom CSS, set height of leafletOutput to a number instead of percent
                              leafletOutput("mymap", width="100%", height="100%"),
                              
                              tagList(tags$head(tags$script(type="text/javascript", src = "busy.js"))),
                              div(class = "busy", p('Loading'),img(src="loading.gif")),
                              
                              # Shiny versions prior to 0.11 should use class = "modal" instead.
                              absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                            draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                            width = 330, height = "auto",
                                            
                                            h2("Data Science 2"),
                                            
                                            selectInput("countrySelect", "Country", c("")),
                                            selectInput("citySelect", "City", c("")),
                                            selectInput("hotelSelect", "Hotel", c("")),
                                            # conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
                                            #                  # Only prompt for threshold when coloring or sizing by superzip
                                            #                  numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
                                            # ),
                                            
                                            plotOutput("histCentile", height = 200),
                                            plotOutput("scatterCollegeIncome", height = 250)
                              )
                          )
                 ),
                 
                 tabPanel("Algorithms",),
                 
                 conditionalPanel("false", icon("crosshair"))
)