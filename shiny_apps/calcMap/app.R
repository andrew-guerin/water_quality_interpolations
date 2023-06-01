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
      setView(lat = 65, lng = -110, zoom = 2) %>% 
      addTiles() %>%
      addCircleMarkers(data = calcium.sites, 
                       lng = ~LONGITUDE, 
                       lat = ~LATITUDE,
                       popup = ~paste(sep = "<br/>",
                                      paste("Site: ", SITE_ID),
                                      paste("Latitude: ", LATITUDE),
                                      paste("Longitude: ", LONGITUDE),
                                      paste("Median: ",MEDIAN,"mg/l"),
                                      paste("Minimum: ",MIN.DTAV,"mg/l"),
                                      paste("Maximum: ",MAX.DTAV,"mg/l"),
                                      paste("Dates sampled: ", NO_DATES),
                                      paste("Total records:", NO_RECORDS)
                       ),
                       radius = 2,
                       color = ~ifelse(SHARE == "YES", "blue", "grey"),
                       clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = FALSE,
                                                             disableClusteringAtZoom = 9))
    })
  
}


shinyApp(ui = ui, server = server)