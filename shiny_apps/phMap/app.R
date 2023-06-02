library(shiny)
library(leaflet)

ph.sites <- read.csv("mapping_data_ph_208784.csv") 

ui <- fillPage(
  titlePanel("Freshwater pH Data Viewer"),
  leafletOutput("phmap",  height = "100%")
  
)

server <- function(input, output) {
  
  output$phmap <- renderLeaflet({
    
    leaflet(options = leafletOptions()) %>%
      addTiles() %>%
      addCircleMarkers(data = ph.sites, 
                       lng = ~LONGITUDE, 
                       lat = ~LATITUDE,
                       popup = ~paste(sep = "<br/>",
                                      paste("Site: ", SITE_ID),
                                      paste("Latitude: ", LATITUDE),
                                      paste("Longitude: ", LONGITUDE),
                                      paste("Median: ",MEDIAN),
                                      paste("Minimum: ",MIN.DTAV),
                                      paste("Maximum: ",MAX.DTAV),
                                      paste("Dates sampled: ", NO_DATES),
                                      paste("Total records:", NO_RECORDS)
                       ),
                       radius = 2,
                       color = ~ifelse(SHARE == "NO", "grey", "red"),
                       clusterOptions = markerClusterOptions(spiderfyOnMaxZoom = FALSE,
                                                             disableClusteringAtZoom = 9))
    })
  
}


shinyApp(ui = ui, server = server)