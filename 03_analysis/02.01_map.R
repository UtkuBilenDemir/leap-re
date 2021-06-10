library(canvasXpress)
library(bannerCommenter)
library(stringr)
library(htmlwidgets)
library(htmltools)
library(leaflet)
M_05 <- readRDS(file = "01_data/02_bibliometrix/05_dataframe_seperated-aff_-_cou_cleaned.Rds")
unsd_regions <- readRDS(file = "01_data/02_bibliometrix/unsd_regions_dict.Rds")
unsd_regions$carto_names
unsd_regions$au_regions <- unsd_regions$unsd_region

unsd_regions$au_regions[unsd_regions$au_regions == "Middle Africa"] <- "Central Africa"
unsd_regions$au_regions[10] <-  "Eastern Africa"
unsd_regions$au_regions[12] <-  "Southern Africa"
unsd_regions$au_regions[13] <-  "Southern Africa"
unsd_regions$au_regions[21] <-  "Southern Africa"
unsd_regions$au_regions[22] <-  "Southern Africa"
unsd_regions$au_regions[26] <-  "Southern Africa"
unsd_regions$au_regions[32] <-  "Central Africa"
unsd_regions$au_regions[41] <-  "Northern Africa"
unsd_regions[nrow(unsd_regions) + 1, ] <- c( "Eastern Africa", "Eastern Africa", "Somaliland")
rownames(unsd_regions[61]) <- "SOMALILAND"
 
## -------------------------------------------------------------------------------



au_countries <- geojsonio::geojson_read("01_data/99_supplementary/africa.geo.json", what = "sp")
names(au_countries)

au_map <- geojsonio::geojson_read("01_data/99_supplementary/au.geojson", what = "sp")
au_carto <- geojsonio::geojson_read("01_data/99_supplementary/africa_adm0.geojson", what = "sp")

library(geojsonio)
spdf <- geojson_read("https://raw.githubusercontent.com/gregoiredavid/france-geojson/master/communes.geojson",  what = "sp")

str(spdf)

# Read this shape file with the rgdal library. 
library(rgdal)
my_spdf <- readOGR( 
  dsn= paste0(getwd(),"/") , 
  layer="TM_WORLD_BORDERS_SIMPL-0.3",
  verbose=FALSE
)

# Keep only data concerning Africa
africa <- my_spdf[my_spdf@data$REGION==2 , ]

# Plot africa
par(mar=c(0,0,0,0))
plot(africa , xlim=c(-20,60) , ylim=c(-40,35), col="steelblue", lwd=0.5 )



au_carto$adm0_a3



canvasXpress(
  data=pfn,
  # varAnnot=rownames(pubf),
  colorBy="freq",
  graphType="Map",
  # legendOrder=list(Winner=list("Republican", "Democrat")),
  mapId="freq",
  # mapProjection="albers",
  theme="wallStreetJournal",
  title="2000 Presidential Elections",
  topoJSON="https://www.canvasxpress.org/data/africa.geo.json"
)



class(au_carto)
states <- geojsonio::geojson_read("https://raw.githubusercontent.com/PublicaMundi/MappingAPI/master/data/geojson/us-states.json", what = "sp")

not_match <- which(!(str_to_title(rownames(unsd_regions)) %in% au_carto$name))
unsd_regions$carto_names <- str_to_title(rownames(unsd_regions))

unsd_regions$carto_names[4] <- au_carto$name[35]
unsd_regions$carto_names[17] <- au_carto$name[32]
unsd_regions$carto_names[28] <- au_carto$name[11]
unsd_regions$carto_names[29] <- au_carto$name[40]
unsd_regions$carto_names[34] <- au_carto$name[5]
unsd_regions$carto_names[38] <- au_carto$name[33]
unsd_regions$carto_names[40] <- au_carto$name[38]
unsd_regions$carto_names[53] <- au_carto$name[41]
unsd_regions$carto_names[55] <- au_carto$name[52]
unsd_regions$carto_names[56] <- au_carto$name[27]

M_05$Country_names <- unsd_regions[M_05$Country,3]
au_freq <- as.data.frame(as.data.frame(table(M_05$Country_names))$Freq)
rownames(au_freq) <- as.data.frame(table(M_05$Country_names))$Var1

### au_regions <- as.data.frame(unsd_regions$unsd_region[-c(56)])
au_regions <- as.data.frame(unsd_regions$au_region[-c(56)])
rownames(au_regions) <- unsd_regions$carto_names[-c(56)]
nrow(unsd_regions[56,])

au_carto$freq <- au_freq[au_carto$name,]
au_carto$region <- au_regions[au_carto$name,]
au_carto$region_num <- as.numeric(as.factor(au_regions[au_carto$name,]))

m <- leaflet(au_carto) %>%
  # setView(-96, 37.8, 4) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv('pk.eyJ1IjoidWRvZTIxMzEyIiwiYSI6ImNrcG9sa2o5cTMwMm8ycHJpem1jaTBrN2wifQ.2EjPIn-cmD1xzsjY-jQO0A')))

m %>% addPolygons()

au_carto$name

bins <- c(0, 40, 100, 200, 500, 1000, 5000, 10000, Inf)
pal <- colorBin("YlOrRd", domain = au_carto$adm0_a3, bins = bins)

bins2 <- c(1,2,3,4, 5)
pal2 <- colorNumeric("Dark2", domain = au_carto$region_num)
?colorBin


# Publication freq
m %>% addPolygons(
  fillColor = ~pal(freq),
  weight = 2,
  opacity = 1,
  color = "black",
  dashArray = "3",
  fillOpacity = 0.7,
  highlight = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE))


labels <- sprintf(
  "<strong>%s</strong><br/>%g pub.<br/><i>%s<i/>",
  au_carto$name, au_carto$freq, au_carto$region
) %>% lapply(htmltools::HTML)

m <- m %>% addPolygons(
  fillColor = ~pal(freq),
  weight = 2,
  opacity = 1,
  color = "black",
  dashArray = "3",
  fillOpacity = 0.7,
  highlight = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labels,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))


rr <- tags$div(
  HTML('<strong>Number of RE-related publications in African countries between 2011-2020</strong>')
)  
map_pub_freq <- m %>% addLegend(pal = pal, title="Amount of pub.", values = ~freq, opacity = 0.7,
                position = "bottomright") %>%
  addControl(rr, position = "bottomleft")

saveWidget(map_pub_freq, file="01_data/03_visualisations/map_pub_freq.html")
saveRDS(map_pub_freq, file = "01_data/03_visualisations/map_pub_freq.Rds")



reg_color <- c("#BF9983", "#898989", "#AF8DA5", "#54B195", "#D8B04C")
names(reg_color) <- unique(au_carto$region)[c(2,4,3,5,1)]

r <- leaflet(au_carto) %>%
  # setView(-96, 37.8, 4) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv('pk.eyJ1IjoidWRvZTIxMzEyIiwiYSI6ImNrcG9sa2o5cTMwMm8ycHJpem1jaTBrN2wifQ.2EjPIn-cmD1xzsjY-jQO0A')))


r %>% addPolygons()
# Regions
r <- r %>% addPolygons(
  fillColor = ~pal2(region_num),
  weight = 2,
  opacity = 1,
  color = "black",
  dashArray = "3",
  fillOpacity = 0.7,
  highlight = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labels,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))

rrr <- tags$div(
  HTML('<strong>African Union geographic regions</strong>')
)  
map_cou_reg <- r %>% addLegend(colors = reg_color, labels=names(reg_color), title="AU Regions", values = ~region_num, opacity = 0.7,
                position = "bottomright") %>%
  addControl(rrr, position = "bottomleft")

saveWidget(map_cou_reg, file="01_data/03_visualisations/map_cou_reg.html")
saveRDS(map_cou_reg, file = "01_data/03_visualisations/map_cou_reg.Rds")
