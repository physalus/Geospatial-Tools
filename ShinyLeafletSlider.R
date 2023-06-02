library(shiny)
library(leaflet)
library(readr)
library(dplyr)

ui <- fluidPage(
  titlePanel("Latitude and Longitude Plot with Time Slider"),
  sidebarLayout(
    sidebarPanel(
      fileInput("csv_file", "Select CSV file:"),
      uiOutput("time_range_slider")
    ),
    mainPanel(
      leafletOutput("map")
    )
  )
)

server <- function(input, output) {
  
  # Read the selected CSV file
  data <- reactive({
    req(input$csv_file)
    read_csv(input$csv_file$datapath) %>%
      rename("time" = "DateTimeUTC","latitude"= "Lat","longitude"= "Long") %>% 
      mutate(time = as.POSIXct(time)) 
      
  })
  
  # Calculate minimum and maximum time values
  time_range <- reactive({
    req(data())
    range(data()$time)
  })
  
  # Generate time range slider
  output$time_range_slider <- renderUI({
    if (!is.null(data())) {
      sliderInput("time_range", "Time Range:",
                  min = as.numeric(time_range()[1]),
                  max = as.numeric(time_range()[2]),
                  value = c(as.numeric(time_range()[1]), as.numeric(time_range()[2])),
                  timeFormat = "%Y-%m-%d %H:%M:%S"
      )
    }
  })
  
  # Filter data based on time range
  filtered_data <- reactive({
    data() %>%
      filter(time >= input$time_range[1],
             time <= input$time_range[2])
  })
  
  output$map <- renderLeaflet({
    leaflet() %>% addTiles() %>% 
      fitBounds(lng1 = min(data()$longitude), lat1 = min(data()$latitude),
                lng2 = max(data()$longitude), lat2 = max(data()$latitude)) %>%
      addMarkers(data = filtered_data(), lat = ~latitude, lng = ~longitude)
  })
}

shinyApp(ui, server)
