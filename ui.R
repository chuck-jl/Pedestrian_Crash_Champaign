library(leaflet)

# Choices for drop-downs



navbarPage("Pedestrian Crashes", id="nav",
           
           tabPanel("Interactive map",
                    div(class="outer",
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js")
                        ),
                        
                        leafletOutput("map", width="100%", height="100%"),
                        
                        # Shiny versions prior to 0.11 should use class="modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 500, height = "auto",
                                      h3("Pedestrian Crashes in Champaign County"),
                                      hr(),
                                      plotlyOutput("Weather", height = 200),
                                      plotlyOutput("TrafficControl", height = 250)
                        )
                    )
           ),
           
           tabPanel("Data explorer",
                    hr(),
                    numericInput("maxrows", "Rows to show", 25, min=1, max=dim(Peddata)[1]),
                    verbatimTextOutput("rawtable"),
                    downloadButton("downloadCsv", "Download All Data as CSV")
           ),
           
           conditionalPanel("false", icon("crosshair"))
)
