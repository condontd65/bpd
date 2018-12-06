library(tidyverse)
library(DBI)
#library(odbc)
library(RODBC)
library(dplyr)
library(ggplot2)
library(leaflet)
library(leaflet.esri)
library(leaflet.extras)

# Set up connection to sql server
con <- odbcDriverConnect('driver={SQL Server};
                 server=vsql22;database=BPDCrime;
                 trusted_connection=true')

# query P1ccounts table
P1counts <- sqlQuery(con, "SELECT * FROM dbo.CityHallP1CCounts;")

# get counts per district to find total N/D values
dist.counts <- as.data.frame(table(P1counts$DISTRICT))

# basic barplot

p <- ggplot(data = dist.counts, aes(x=Var1, y=Freq)) +
  geom_bar(stat='identity') +
  geom_text(aes(label=Freq),
            position = position_dodge(width = 0.9),
            vjust = -0.25)

p

## Create a map using leaflet to practice and explore the data between districts

# Add in url for Boston's tiled basemap layer
bos <- "https://awsgeo.boston.gov/arcgis/rest/services/Basemaps/BostonCityBasemap_WM/MapServer"

m <- leaflet() %>%
  addProviderTiles(providers$Esri.WorldGrayCanvas) %>% 
  addMarkers(lng = -71.057886, lat = 42.360247, 
             popup = "Boston City Hall") %>%
  setView(lng = -71.057886, lat = 42.360247, zoom = 13) %>%
  addEsriTiledMapLayer(url = bos)

m




#dbo.CityHallP1CCounts


