library(canvasXpress)
library(bannerCommenter)
library(stringr)
library(htmlwidgets)
library(htmltools)
library(leaflet)
library(rgdal)
library(sp)
library(sf)
library(geojsonio)
library(leaflet.extras)


require("reticulate")
source_python("../bibliometry_module/88_supplementary_methods/R_pickle_reader.py")
M_06 <- read_pickle_file("./01_data/02_bibliometrix/0603_GRID_au-off_names.pickle")

# Country Table
unsd_regions <- read.csv("./01_data/0201_tables/02_country_table.csv")

# Official boundaries of Africa (Western Sahara problem solved)
au_off <- readRDS("./01_data/04_geospatial_data/au_official_boundaries.Rds")

# Create initial mapbox drawing
m <- leaflet(au_off) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv('pk.eyJ1IjoidWRvZTIxMzEyIiwiYSI6ImNrcG9sa2o5cTMwMm8ycHJpem1jaTBrN2wifQ.2EjPIn-cmD1xzsjY-jQO0A')))

# Create colour palette for choropleth layer
bins <- c(0, 40, 100, 200, 400, 600, 800, 1000, 3000, 5000, Inf)
pal <- colorBin("YlOrRd", domain = au_off$color_code, bins = bins)

# Adjust color distribution
bins2 <- c(1,2,3,4, 5)
pal2 <- colorNumeric("Dark2", domain = au_off$region_num)

# Choropleth
labels <- sprintf(
  "<strong>%s</strong><br/>%g pub.<br/><i>%s<i/>",
  au_off$name, au_off$freq, au_off$region
) %>% lapply(htmltools::HTML)

m <- m %>% addPolygons(
  fillColor = ~pal(freq),
  weight = 2,
  opacity = 1,
  color = "black",
  dashArray = "1",
  fillOpacity = 0.7,
  highlight = highlightOptions(
    weight = 2,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labels,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))

# Add title
# TODO: Do we want title??
## rr <- tags$div(
##   HTML('<strong>Number of RE-related publications in African countries between 2011-2020</strong>')
## )

map_pub_freq <- m %>% addLegend(pal = pal, title="Amount of pub.", values = ~freq, opacity = 0.7,
                position = "bottomright") %>%
##   addControl(rr, position = "bottomleft") %>%
setMapWidgetStyle(list(background= "white"))

saveWidget(map_pub_freq, file="./04_visualisation/02_maps/03_results/choropleth.html")
saveRDS(map_pub_freq, file = "./04_visualisation/02_maps/03_results/choropleth.Rds")

#---------------------------------------------------------------------------------------------------------------------------------------
# Regional map
reg_color <- c("#BF9983", "#898989", "#AF8DA5", "#54B195", "#D8B04C")
names(reg_color) <- unique(au_off$region)[c(1,3,5,2,6)]

r <- leaflet(au_off) %>%
  # setView(-96, 37.8, 4) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv('pk.eyJ1IjoidWRvZTIxMzEyIiwiYSI6ImNrcG9sa2o5cTMwMm8ycHJpem1jaTBrN2wifQ.2EjPIn-cmD1xzsjY-jQO0A')))


# Regions
r <- r %>% addPolygons(
  fillColor = ~pal2(region_num),
  weight = 2,
  opacity = 1,
  color = "black",
  dashArray = "1",
  fillOpacity = 0.7,
  highlight = highlightOptions(
    weight = 2,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labels,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))

## rrr <- tags$div(
##   HTML('<strong>African Union geographic regions</strong>')
## )  
map_cou_reg <- r %>% addLegend(colors = reg_color, labels=names(reg_color), title="AU Regions", values = ~region_num, opacity = 0.7,
                position = "bottomright") %>%
##  addControl(rrr, position = "bottomleft") %>%
  # Make background white
  setMapWidgetStyle(list(background = "white"))


## saveWidget(map_cou_reg, file="01_data/03_visualisations/map_cou_reg_-_2.html")
saveRDS(map_cou_reg, file = "./04_visualisation/02_maps/03_results/au_regions.Rds")


length(unique(na_df$ID)) / length(unique(M_06$ID))
unique(M_06[order(M_06$Country_relative, decreasing = TRUE), c("au_off_country")])[1:10]
M_06[, "au_off_country"]


