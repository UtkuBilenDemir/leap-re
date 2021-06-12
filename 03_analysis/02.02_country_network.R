M_05 <- readRDS(file = "01_data/02_bibliometrix/05_dataframe_seperated-aff_-_cou_cleaned.Rds")
unsd_regions <- readRDS(file = "01_data/02_bibliometrix/unsd_regions_dict.Rds")

# Load package
# devtools::install_github("mattflor/chorddiag")
library(chorddiag)

# library(htmlwidgets)
# saveWidget(p, file=paste0( getwd(), "/HtmlWidget/chord_interactive.html"))

m["black",]
class(m)
nodes <- c("EGYPT", 
           "MOROCCO",
           "NIGERIA",
           "GHANA",
           "DEM REP CONGO", 
           "CAMEROON",
           "ETHIOPIA",
           "KENYA", 
           "SOUTH AFRICA",
           "BOTSWANA",
           "GERMANY",
           "FRANCE",
           "CHINA",
           "USA"
           )

unique(M_05$Country)

length(unique(M_05$ID[(M_05$Country == "EGYPT" | M_05$Country == "NIGERIA" )]))

networkify <- function(df, nodes, node_col="Country", id_col="ID"){
  out_m <- matrix( nrow = length(nodes), ncol = length(nodes))
  dimnames(out_m) <- list(node=nodes, node2=nodes)
  for(node in nodes){
    #node_matches <- node == df[, node_col]
    node_row <- rep(0, length(nodes))
    names(node_row) <- nodes
    for(node2 in nodes){
      node_matches <- (node == df[, node_col] | node2 == df[, node_col])
      unique_ids <- unique(df[node_matches, id_col])
      node_row[node2] <- length(unique_ids)
    }
    out_m[node, ] <- node_row
  }
  return(out_m)
}
  
country_m <- networkify(M_05, nodes)
pure_country_m <- country_m 
for(i in 1:nrow(country_m)){
  for(j in 1:ncol(country_m)){
    if(i==j){
      country_m[i,j] <- 0
    }
  }
}

country_m


chorddiag(country_m, groupnamePadding = 20)
p





nodes_alt <- c("EGYPT", 
           "LIBYA",
           "NIGERIA",
           "SENEGAL",
           "DEM REP CONGO", 
           "ZAMBIA",
           "ETHIOPIA",
           "KENYA", 
           "SOUTH AFRICA",
           "BOTSWANA",
           "GERMANY",
           "ENGLAND",
           "CHINA",
           "USA"
)

cou_col <- c(
"#a6cee3",
"#1f78b4",
"#b2df8a",
"#33a02c",
"#fb9a99",
"#e31a1c",
"#fdbf6f",
"#ff7f00",
"#cab2d6",
"#6a3d9a",
"#1b9e77",
"#a65628",
"#e41a1c",
"#d95f02"
)

country_m_alt <- networkify(M_05, nodes_alt)

for(i in 1:nrow(country_m_alt)){
  for(j in 1:ncol(country_m_alt)){
    if(i==j){
      country_m_alt[i,j] <- 0
    }
  }
}

country_chord <- chorddiag(country_m_alt, groupColors = cou_col, groupnamePadding = 50)

# save the widget
library(htmlwidgets)
# saveWidget(p, file=paste0( getwd(), "/HtmlWidget/chord_interactive.html"))

saveRDS(country_chord, file = "01_data/03_visualisations/country_chord.Rds")



