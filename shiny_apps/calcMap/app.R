
#PLEASE NOTE THAT GIVEN THE LARGE AMOUNT OF DATA, THE GENERATED MAP MAY TAKE A FEW MOMENTS TO LOAD

library(shiny)
library(leaflet)

calcium.sites <- read.csv("mapping_data_calcium_97648.csv") 

ui <- fillPage(
  titlePanel("Freshwater Calcium Concentration Data Viewer"),
  leafletOutput("calcmap",  height = "100%")
  
)

server <- function(input, output) {

  output$calcmap <- renderLeaflet({
    
    leaflet(options = leafletOptions()) %>%
      addTiles() %>%
      addCircleMarkers(data = calcium.sites, 
                       lng = ~LONGITUDE, 
                       lat = ~LATITUDE,
                       popup = ~paste(sep = "<br/>",
                                      paste("Latitude: ", LATITUDE),
                                      paste("Longitude: ", LONGITUDE),
                                      paste("Median: ",MEDIAN,"mg/l"),
                                      paste("Minimum: ",MIN.DTAV,"mg/l"),
                                      paste("Maximum: ",MAX.DTAV,"mg/l"),
                                      paste("Dates sampled: ", NO_DATES),
                                      paste("Total records:", NO_RECORDS),
                                      paste("Data Sources:", SOURCE_IDS)
                       ),
                       radius = 2,
                       color = ~ifelse(SHARE == "NO", "grey", "blue"),
                       clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = FALSE,
                                                             disableClusteringAtZoom = 9))
    })

}


shinyApp(ui = ui, server = server)