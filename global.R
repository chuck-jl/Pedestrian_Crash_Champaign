library(dplyr)
library(plotly)
library(sp)
library(maptools)
library(rgdal)
library(leaflet)

Street_Centerlines <- readOGR(dsn = "./Data/Street_Centerlines.shp", layer = "Street_Centerlines")
Street_Centerlines.wgs84 <- spTransform(Street_Centerlines, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

Pedestrian_Crashes <- readOGR(dsn = "./Data/Pedestrian_Crashes.shp", layer = "Pedestrian_Crashes")
Pedestrian_Crashes.wgs84 <- spTransform(Pedestrian_Crashes, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
Daylight <- c("Daylight")
Othertime <- c("Darkness", "Darkness, lighted road", "Dawn", "Dusk", "NA")
Pedestrian_Crashes.Daylight.wgs84 <- Pedestrian_Crashes.wgs84[Pedestrian_Crashes.wgs84$Light %in% Daylight,] 
Pedestrian_Crashes.Othertime.wgs84 <- Pedestrian_Crashes.wgs84[Pedestrian_Crashes.wgs84$Light %in% Othertime,]

Peddata<-read.csv("Data/Pedestrian_Crashes_from_2005_to_2014.csv")
Peddata$latitude <- jitter(Peddata$latitude)
Peddata$longitude <- jitter(Peddata$longitude)

Daylight<-Peddata[Peddata$Light=='Daylight',]
Other<-Peddata[Peddata$Light !='Daylight',]


names(Daylight)[1] = paste('Lon1')
names(Daylight)[2] = paste('Lat1')

names(Other)[1] = paste('Lon2')
names(Other)[2] = paste('Lat2')


Daylight.popup <- paste0("<b>Year: </b>", Pedestrian_Crashes.Daylight.wgs84@data$Year, "<br>",
                         "<b>Injury: </b>", Pedestrian_Crashes.Daylight.wgs84@data$Injury, 
                         "<b>Fatality: </b>", Pedestrian_Crashes.Daylight.wgs84@data$Fatality, "<br>",
                         "<b>Weather: </b>", Pedestrian_Crashes.Daylight.wgs84@data$Weather, "<br>",
                         "<b>Road Surface: </b>", Pedestrian_Crashes.Daylight.wgs84@data$RoadSurfac, "<br>",
                         "<b>Traffic Control:  </b>", Pedestrian_Crashes.Daylight.wgs84@data$TrafficCon)


Othertime.popup <- paste0("<b>Year: </b>", Pedestrian_Crashes.Othertime.wgs84@data$Year, "<br>",
                          "<b>Injury: </b>", Pedestrian_Crashes.Othertime.wgs84@data$Injury, 
                          "<b>Fatality: </b>", Pedestrian_Crashes.Othertime.wgs84@data$Fatality, "<br>",
                          "<b>Weather: </b>", Pedestrian_Crashes.Othertime.wgs84@data$Weather, "<br>",
                          "<b>Road Surface: </b>", Pedestrian_Crashes.Othertime.wgs84@data$RoadSurfac, "<br>",
                          "<b>Traffic Control:  </b>", Pedestrian_Crashes.Othertime.wgs84@data$TrafficCon)


aaa <- heat.colors(12, alpha = 1)
pal = colorNumeric(aaa, Street_Centerlines.wgs84@data$SPEED)





pie<-as.data.frame(table(Peddata$Weather))
pie$Freq<-pie$Freq/4.55
piedata<-pie[,c('Var1','Freq')]

hist1<-as.data.frame(table(Daylight$Year))
names(hist1)[1]<-paste("date")
names(hist1)[2]<-paste("daylight")

hist2<-as.data.frame(table(Other$Year))
names(hist2)[1]<-paste("date")
names(hist2)[2]<-paste("other")

histfinal<-merge(x = hist1, y = hist2, by = "date", all.x = TRUE)

colors <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)', 'rgb(171,104,87)', 'rgb(114,147,203)')

b<-as.data.frame(table(Daylight$Year))
names(b)[1]<-paste("date")
names(b)[2]<-paste("daylight")
Other<-Peddata[Peddata$Light !='Daylight',]
c<-as.data.frame(table(Other$Year))
names(c)[1]<-paste("date")
names(c)[2]<-paste("other")
bc<-merge(x = b, y = c, by = "date", all.x = TRUE)
