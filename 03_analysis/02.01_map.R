library(canvasXpress)
library(bannerCommenter)
library(stringr)
library(htmlwidgets)
library(htmltools)
M_05 <- readRDS(file = "01_data/02_bibliometrix/05_dataframe_seperated-aff_-_cou_cleaned.Rds")
unsd_regions <- readRDS(file = "01_data/02_bibliometrix/unsd_regions_dict.Rds")




## # ## Grab African topojson
## 
## # Topo correct names
## unsd_regions$topo_names <- str_to_title(rownames(unsd_regions))
## 
## # Which ones are not present in the geojson data
## not_ind <- which(!(unsd_regions$topo_names %in% unique(africa$geounit)))
## unsd_regions$topo_names[not_ind]
## unsd_regions$topo_names[not_ind[1]] <- unique(africa$geounit)[9]
## unsd_regions$topo_names[not_ind[2]] <- unique(africa$geounit)[7]
## unsd_regions$topo_names[not_ind[3]] <- unique(africa$geounit)[22]
## unsd_regions$topo_names[not_ind[4]] <- unique(africa$geounit)[10]
## unsd_regions$topo_names[not_ind[5]] <- unique(africa$geounit)[6]
## # Mauritius and Eswatini are problematic
## unsd_regions$topo_names[not_ind[12]] <- unique(africa$geounit)[48]
## 
## ## Eliminate the unmatched ones
## unmatched_countries <- unsd_regions$topo_names[which(!(unsd_regions$topo_names %in% unique(africa$geounit)))]
## 
## 
## M_05$Country_names <- unsd_regions[M_05$Country,2]
## 
## pub_freq <- as.data.frame(table(M_05$Country_names) )
## colnames(pub_freq) <- c("Countries", "# of pub.")
## 
## pub_freq$`# of pub.`
## rownames(pub_freq) <- pub_freq$Countries
## 
## pub_freq <- pub_freq$`# of pub.`
## 
## pubf <- as.data.frame(pub_freq[,2])
## rownames(pubf) <- rownames(pub_freq)
## colnames(pubf) <- "freq"
## 
## q <- pubf[-c(which(rownames(pubf) %in% unmatched_countries)),]
## p <- rownames(pubf)[-c(which(rownames(pubf) %in% unmatched_countries))]
## 
## pf <- as.data.frame(q)
## rownames(pf) <- p
## colnames(pf) <- "Freq."
## 
## canvasXpress(
##   data=pfn,
##   # varAnnot=rownames(pubf),
##   colorBy="freq",
##   graphType="Map",
##   # legendOrder=list(Winner=list("Republican", "Democrat")),
##   mapId="freq",
##   # mapProjection="albers",
##   theme="wallStreetJournal",
##   title="2000 Presidential Elections",
##   topoJSON="https://www.canvasxpress.org/data/africa.geo.json"
## )
## 
## africa$geounit[41] <- "Spania"
## africa$geounit[15] <- "Spaniar"
## pfn <- as.data.frame(pf[africa$geounit,])
## rownames(pfn) <- africa$geounit
## colnames(pfn) <- "freq"
## 
## table(africa$geounit)
## 
## str(afr)
## 
## 
## 
## 
## y=read.table("https://www.canvasxpress.org/data/cX-CO2T-dat.txt", header=TRUE, sep="\t", quote="", row.names=1, fill=TRUE, check.names=FALSE, stringsAsFactors=FALSE)
## z=read.table("https://www.canvasxpress.org/data/cX-CO2T-var.txt", header=TRUE, sep="\t", quote="", row.names=1, fill=TRUE, check.names=FALSE, stringsAsFactors=FALSE)
## 
## rownames(pfn)
## 
## world_countries <- as.data.frame(rownames(z))
## rownames(world_countries) <- z$Country
## 
## pfnm <- pfn 
## rownames(pfnm) <- world_countries[rownames(pfn),]
## 
## rownames(pfn)[7]
## 
## 
## 
## 
## 
## 
## 
## 
## # Palette of 30 colors
## library(RColorBrewer)
## my_colors <- brewer.pal(9, "Reds") 
## my_colors <- colorRampPalette(my_colors)(30)
## 
## # Attribute the appropriate color to each country
## class_of_country <- cut(africa@data$POP2005, 30)
## my_colors <- my_colors[as.numeric(class_of_country)]
## 
## # Make the plot
## plot(africa , xlim=c(-20,60) , ylim=c(-40,40), col=my_colors ,  bg = "#A6CAE0")
## 
## 
## 
## 
## 
## library(rgdal)
## my_spdf <- readOGR(dsn=path.expand("C:/Users/Downloads/Files/World-Shapefiles"), layer="TM_WORLD_BORDERS_SIMPL-0.3")
## 
## 
## 
## # Keep only data concerning Africa
## africa <- my_spdf[my_spdf@data$REGION==2 , ]
## 
## # Plot africa
## par(mar=c(0,0,0,0))
## plot(africa , xlim=c(-20,60) , ylim=c(-40,35), col="steelblue", lwd=0.5 )
## 
## 
## 
## 
## 
## 
## 
## 
## 
## 
## 
## 
## # Download the shapefile. (note that I store it in a folder called DATA. You have to change that if needed.)
## download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="DATA/world_shape_file.zip")
## # You now have it in your current working directory, have a look!
## 
## # Unzip this file. You can do it with R (as below), or clicking on the object you downloaded.
## system("unzip 01_data/99_supplementary/TM_WORLD_BORDERS_SIMPL-0.3.zip")
## #  -- > You now have 4 files. One of these files is a .shp file! (TM_WORLD_BORDERS_SIMPL-0.3.shp)
## 
## 
## 
## # Read this shape file with the rgdal library. 
## library(rgdal)
## world_spdf <- readOGR( 
##   dsn= paste0(getwd(),"/") , 
##   layer="TM_WORLD_BORDERS_SIMPL-0.3",
##   verbose=FALSE
## )
## 
## # Clean the data object
## library(dplyr)
## world_spdf@data$POP2005[ which(world_spdf@data$POP2005 == 0)] = NA
## world_spdf@data$POP2005 <- as.numeric(as.character(world_spdf@data$POP2005)) / 1000000 %>% round(2)
## 
## # -- > Now you have a Spdf object (spatial polygon data frame). You can start doing maps!
## 
## # Create a color palette with handmade bins.
## library(RColorBrewer)
## library(leaflet)
## mybins <- c(0,10,20,50,100,500,Inf)
## mypalette <- colorBin( palette="YlOrBr", domain=world_spdf@data$POP2005, na.color="transparent", bins=mybins)
## 
## 
## 
## # Prepare the text for tooltips:
## mytext <- paste(
##   "Country: ", world_spdf@data$NAME,"<br/>", 
##   "Area: ", world_spdf@data$AREA, "<br/>", 
##   "Population: ", round(world_spdf@data$POP2005, 2), 
##   sep="") %>%
##   lapply(htmltools::HTML)
## 
## # Final Map
## leaflet(world_spdf) %>% 
##   addTiles()  %>% 
##   setView( lat=10, lng=0 , zoom=2) %>%
##   addPolygons( 
##     fillColor = ~mypalette(POP2005), 
##     stroke=TRUE, 
##     fillOpacity = 0.9, 
##     color="white", 
##     weight=0.3,
##     label = mytext,
##     labelOptions = labelOptions( 
##       style = list("font-weight" = "normal", padding = "3px 8px"), 
##       textsize = "13px", 
##       direction = "auto"
##     )
##   ) %>%
##   addLegend( pal=mypalette, values=~POP2005, opacity=0.9, title = "Population (M)", position = "bottomleft" )
## 
## m  
## 
## # save the widget in a html file if needed.
## # library(htmlwidgets)
## # saveWidget(m, file=paste0( getwd(), "/HtmlWidget/choroplethLeaflet5.html"))
## 
## 
## 
## 
## # Palette of 30 colors
## library(RColorBrewer)
## my_colors <- brewer.pal(9, "Reds") 
## my_colors <- colorRampPalette(my_colors)(30)
## 
## # Attribute the appropriate color to each country
## class_of_country <- cut(africa@data$POP2005, 30)
## my_colors <- my_colors[as.numeric(class_of_country)]
## 
## # Make the plot
## plot(africa , xlim=c(-20,60) , ylim=c(-40,40), col=my_colors ,  bg = "#A6CAE0")
## 
## 
## 
## 






















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

M_05$Country_names <- unsd_regions[M_05$Country,2]
au_freq <- as.data.frame(as.data.frame(table(M_05$Country_names))$Freq)
rownames(au_freq) <- as.data.frame(table(M_05$Country_names))$Var1

au_regions <- as.data.frame(unsd_regions$unsd_region[-c(56)])
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



reg_color <- c("#BF9983", "#FFFFFF", "#AF8DA5", "#54B195", "#DDDDDD")

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
  HTML('<strong>United Nations geoscheme for Africa</strong>')
)  
map_cou_reg <- r %>% addLegend(colors = cou_col[1:6], labels=unique(au_carto$region), title="UNSD Regions", values = ~region_num, opacity = 0.7,
                position = "bottomright") %>%
  addControl(rr, position = "bottomleft")
?addLegend

