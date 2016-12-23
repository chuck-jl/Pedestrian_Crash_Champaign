library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(plotly)

function(input, output, session) {

output$map <- renderLeaflet({
  leaflet() %>%
    addProviderTiles("CartoDB.Positron") %>%
    setView(-88.222778, 40.120, zoom = 13) %>% 
    addLegend(position = 'bottomleft',
              pal = pal,
              values = Street_Centerlines.wgs84$SPEED,
              opacity = 0.2,
              title = "Speed Limit") %>%
    addCircles(data = Pedestrian_Crashes.Daylight.wgs84, fillOpacity = 0.5,
               stroke = TRUE, weight = 5, radius = 40,
               color = "cadetblue1",
               popup=Daylight.popup,
               group="Daylight Incidents"
    ) %>%
    addCircles(data = Pedestrian_Crashes.Othertime.wgs84, fillOpacity = 0.5, 
               stroke = TRUE, weight = 5, radius = 40,
               color = "salmon",
               popup=Othertime.popup,
               group="Othertime Incidents"
    ) %>%
    addPolylines(data = Street_Centerlines.wgs84, fill = FALSE, stroke = TRUE,
                 color = ~pal(Street_Centerlines.wgs84@data$SPEED), weight = 4, opacity = 0.1,  fillColor = ~colorNumeric(aaa, Street_Centerlines.wgs84@data$SPEED), 
                 fillOpacity = 0.8, dashArray = NULL, smoothFactor = 1, noClip = FALSE, 
                 group = "Streets data" )%>%
    addLayersControl(
      overlayGroups = c("Othertime Incidents", "Daylight Incidents", "Streets data"),
      options = layersControlOptions(collapsed = TRUE),position = 'bottomright')
  })

output$Weather<- renderPlotly({
  plot_ly(piedata, labels = piedata$Var1, values = piedata$Freq, type = 'pie',
          textposition = 'inside',
          textinfo = 'label+percent',
          insidetextfont = list(color = '#FFFFFF'),
          hoverinfo = 'text',
          text = ~paste(Var1, round(Freq,2), ' %'),
          marker = list(colors = colors,
                        line = list(color = '#FFFFFF', width = 1)),
          #The 'pull' attribute can also be used to create space between the sectors
          showlegend = FALSE) %>%
    layout(title = 'Weather Condition',
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })


output$TrafficControl<- renderPlotly({
  plot_ly(bc, x = bc$date, y = bc$daylight, type = 'bar', name = 'Daylight') %>%
    add_trace(y = bc$other, name = 'Other') %>%
    layout(yaxis = list(title = 'Light Condition Summary'), barmode = 'group')
  })

output$downloadCsv <- downloadHandler(
  filename = "data.csv",
  content = function(file) {
    write.csv(Peddata, file)
  },
  contentType = "text/csv"
)

output$rawtable <- renderPrint({
  orig <- options(width = 1000)
  print((tail(Peddata, input$maxrows)),row.names=FALSE)
  options(orig)
})


}


