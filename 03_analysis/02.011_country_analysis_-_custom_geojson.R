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

M_05 <- readRDS(file = "01_data/02_bibliometrix/05.01_dataframe_seperated-aff_-_cou_cleaned_-_cou_freq.Rds")
unsd_regions <- readRDS(file = "01_data/02_bibliometrix/unsd_regions_dict_2.Rds")


# Official boundaries of Africa (Western Sahara problem solved)
au_off <- geojsonio::geojson_read("01_data/99_supplementary/world-administrative-boundaries_-_Africa.geojson", what = "sp")

# Rename uncommon country names
au_off$name[1] <- "Libya"
au_off$name[26] <- "Dem. Rep. Congo"
au_off$name[8] <- "Tanzania"
au_off$name[47] <- "Eq. Guinea"
au_off$name[34] <- "Central African Rep."
au_off$name[10] <- "Eswatini"
au_off$name[17] <- "São Tomé and Principe"
au_off$name[55] <- "W. Sahara"

# Create a column for au_off country names 
unsd_regions$au_off_names <- unsd_regions$carto_names

# Change mismatched country names
unsd_regions$au_off_names[34] <- "South Sudan"

# Which ones of the country names do not match
unsd.not_match <- which(!(unsd_regions$au_off_names %in% au_off$name))
unsd.match <- which((unsd_regions$au_off_names %in% au_off$name))
unsd_regions$carto_names[unsd.not_match]

# Create a column for frequencies in the unsd_regions
freqs <- rep(NA, nrow(unsd_regions))
for(i in 1:length(rownames(unsd_regions))){
  try(
 freqs[i] <- as.numeric(unique(M_05$cou_tot_pub[rownames(unsd_regions)[i]==M_05$Country]))
  )
}

unsd_regions$tot_pub <- freqs

# Configure geojson object
au_off$freq <- unsd_regions$tot_pub[match(au_off$name, unsd_regions$au_off_names)]
au_off$region <- unsd_regions$au_regions[match(au_off$name, unsd_regions$au_off_names)]
au_off$region_num <- as.numeric(as.factor(unsd_regions$au_regions[match(au_off$name, unsd_regions$au_off_names)]))

au_off$region_unsd <- unsd_regions$unsd_region[match(au_off$name, unsd_regions$au_off_names)]
au_off$region_unsd_num <- as.numeric(as.factor(unsd_regions$unsd_region[match(au_off$name, unsd_regions$au_off_names)]))
# Create initial mapbox drawing
m <- leaflet(au_off) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv('pk.eyJ1IjoidWRvZTIxMzEyIiwiYSI6ImNrcG9sa2o5cTMwMm8ycHJpem1jaTBrN2wifQ.2EjPIn-cmD1xzsjY-jQO0A')))

m %>% addPolygons()


# Create colour palette for choropleth layer
bins <- c(0, 40, 100, 200, 400, 600, 800, 1000, 3000, 5000, Inf)
pal <- colorBin("YlOrRd", domain = au_off$color_code, bins = bins)

# Adjust color distribution
bins2 <- c(1,2,3,4, 5)
pal2 <- colorNumeric("Dark2", domain = au_carto$region_num)


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
rr <- tags$div(
  HTML('<strong>Number of RE-related publications in African countries between 2011-2020</strong>')
)  
map_pub_freq <- m %>% addLegend(pal = pal, title="Amount of pub.", values = ~freq, opacity = 0.7,
                position = "bottomright") %>%
  addControl(rr, position = "bottomleft")

saveWidget(map_pub_freq, file="01_data/03_visualisations/map_pub_freq_-_2.html")
saveRDS(map_pub_freq, file = "01_data/03_visualisations/map_pub_freq_-_2.Rds")

# Regional map
reg_color <- c("#BF9983", "#898989", "#AF8DA5", "#54B195", "#D8B04C")
names(reg_color) <- unique(au_off$region)[c(1,3,5,2,6)]

r <- leaflet(au_off) %>%
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

rrr <- tags$div(
  HTML('<strong>African Union geographic regions</strong>')
)  
map_cou_reg <- r %>% addLegend(colors = reg_color, labels=names(reg_color), title="AU Regions", values = ~region_num, opacity = 0.7,
                position = "bottomright") %>%
  addControl(rrr, position = "bottomleft")


saveWidget(map_cou_reg, file="01_data/03_visualisations/map_cou_reg_-_2.html")
saveRDS(map_cou_reg, file = "01_data/03_visualisations/map_cou_reg_-_2.Rds")



# Same with the unsd regions
# Regional map
reg_color_unsd <- c("#BF9983", "#898989", "#54B195", "#AF8DA5", "#D8B04C")
names(reg_color_unsd) <- unique(au_off$region_unsd)[c(1,3,5,2,6)]

unsd_r <- leaflet(au_off) %>%
  # setView(-96, 37.8, 4) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv('pk.eyJ1IjoidWRvZTIxMzEyIiwiYSI6ImNrcG9sa2o5cTMwMm8ycHJpem1jaTBrN2wifQ.2EjPIn-cmD1xzsjY-jQO0A')))


unsd_r %>% addPolygons()
# Regions
unsd_r <- unsd_r %>% addPolygons(
  fillColor = ~pal2(region_unsd_num),
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

unsd_rrr <- tags$div(
  HTML('<strong>UNSD regions</strong>')
)  
unsd_map_cou_reg <- unsd_r %>% addLegend(colors = reg_color_unsd, labels=names(reg_color_unsd), title="UNSD Regions", values = ~region_unsd_num, opacity = 0.7,
                position = "bottomright") %>%
  addControl(unsd_rrr, position = "bottomleft")


saveWidget(unsd_map_cou_reg, file="01_data/03_visualisations/unsd_map_cou_reg_-_2.html")
saveRDS(unsd_map_cou_reg, file = "01_data/03_visualisations/unsd_map_cou_reg_-_2.Rds")
