library(reticulate)
library(dplyr)
library(plotly)
library(dplyr)


pd <- import("pandas")

M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0608_org_proper.pickle")
wos <- readRDS("./../bibliometry_module/00_data/research_areas/wos_dictionary.Rds")

# EXPLODED DATAFRAME
M_06_ex <- readRDS("./01_data/02_bibliometrix/res_area_exp_069999_res_oty.Rds")
colnames(M_06_ex)

ra_df <- readRDS("./04_visualisation/05_treemaps/ra_df.Rds")
## ra_un <- unique(M_06_ex$res_areas)
## ra <- rep("", length(unique(ra_un)))
## rd <- rep("", length(unique(ra_un)))
## ra_freq <- rep(0, length(unique(ra_un)))
## for (i in seq_along(unique(ra_un))) {
##   ra[i] <- ra_un[i]
##   ra_freq[i] <- as.numeric(unique(M_06_ex[M_06_ex$res_areas == ra[i], "res_pub_freq"]))
##   d_indexes <- which(length(M_06_ex[ M_06_ex$res_areas == ra[i], "res_domains"]) == 1)
## 
##   ## rd[i] <- unique(M_06_ex[M_06_ex$res_areas == ra[i], "res_domains"])
##   ## rd[i] <- M_06_ex[d_indexes, "res_domains"][1]
##   rd[i] <- M_06_ex[ M_06_ex$res_areas == ra[i], "res_domains"][d_indexes][1]
## 
## }
## 
## 
## wos
## 
## rd <- wos[ra,]
## rd
## ra_df <- as.data.frame(cbind(rd,ra,ra_freq))
## ra_df <- ra_df[order(as.numeric(ra_df$ra_freq), decreasing = TRUE),]
## 
## paste0(ra_df$rd, " ::: ", ra_df$ra, " ::: ", ra_df$ra_freq)
## ra_df$rd[35] <- "Technology"
## ra_df$rd[51] <- "Technology"
## ra_df$rd[64] <- "Technology"
## ra_df$rd[68] <- "Technology"
## ra_df$rd[78] <- "Technology"
## ra_df$rd[92] <- "Technology"
## ra_df$rd[93] <- "Technology"
## 
## 
## 
## 
## 
## ra_df$rd[143] <- "Technology"
## ra_df$rd[115] <- "Technology"
## ra_df$rd[124] <- "Technology"
## ra_df$rd[102] <- "Technology"
## ra_df$rd[132] <- "Technology"
## ra_df$rd[133] <- "Technology"
## ra_df$rd[134] <- "Social Sciences"
## ra_df$rd[140] <- "Social Sciences"
## ra_df$rd[185] <- "Social Sciences"
## ra_df$rd[198] <- "Social Sciences"
## ra_df$rd[202] <- "Social Sciences"
## ra_df$rd[203] <- "Social Sciences"
## ra_df$rd[173] <- "Arts & Humanities"
## ra_df$rd[56] <- "Life Sciences & Biomedicine"
## ra_df$rd[74] <- "Life Sciences & Biomedicine"
## ra_df$rd[125] <- "Life Sciences & Biomedicine"
## ra_df$rd[189] <- "Life Sciences & Biomedicine"
## ra_df$rd[139] <- "Life Sciences & Biomedicine"
## ra_df$rd[195] <- "Life Sciences & Biomedicine"
## ra_df$rd[85] <- "Physical Sciences"
## ra_df$rd[91] <- "Physical Sciences"
## ra_df$rd[150] <- "Physical Sciences"
## 
## rownames(ra_df)<- c()
## ra_df[which(is.na(ra_df$rd)),]
## 
## ra_df$rd[70] <- "Social Sciences"
## ra_df$rd[80] <- "Technology"
## ra_df$rd[121] <- "Technology"
## ra_df<- ra_df[-c(190), ]
## 
## 
## rd_un <- unique(ra_df$rd)
## rd_freq <- rep(0, length(rd_un))
## for (i in seq_along(rd_un)){
##   rd_freq[i] <- length(unique(M_06_ex[sapply(rd_un[i], grepl, M_06_ex$res_domains), "ID"])[[1]])
## }
## 
## 
## ind(ra_df, as.data.frame(cbind(rep("", length(rd_un)), rd_un, rd_freq)))
## 



###########

unique(M_06_ex[sapply(rd_un[i], grepl, M_06_ex$res_domains), "ID"])[[1]]



res_areas_df <- read.csv("./01_data/0201_tables/res_areas.txt", sep="\t")
res_areas_df <- as.data.frame(res_areas_df)

colnames(res_areas_df)[1]  <- "res_area"
domain <- wos[res_areas_df$res_area,]
res_areas_df$res_domain <- domain

table

ra <- rep("", length(nrow(unique(M_06))))
for (i in seq_along(M_06$res_areas)) {

}

domain2 <- wos[table$area,]
## # Followings are simpler approaches
domains <- rep("", nrow(res_areas_df))
for (i in seq_along(res_areas_df$Web.of.Science.Categories)) {
  domains[i] <- M_06[res_areas_df$Web.of.Science.Categories[i] %in% M_06$res_areas, "res_domains"][1]
}

as.data.frame(paste0(res_areas_df$res_domain, " ::: ", res_areas_df$res_area ))



domains
colnames(M_06)


## simple_df  <- M_06[c("ID", "res_areas", "res_domains")]


library(reticulate)
library(kableExtra)
library(formattable)
library(plotly)
library(dplyr)
library(tidyr)
library(stringr)

M_06 <- read_pickle_file("./01_data/02_bibliometrix/0608_org_proper.pickle")

# Create org df
cairo_df <- M_06[M_06$org_prop == "Cairo University", ]
# GENERAL treemap?

# Unique res areas from the org
cairo_res_area_un <- str_split(cairo_df$res_area, ";") 
cairo_res_area_un <- unique(trimws(unlist(cairo_res_area_un)))
## GENERAL
res_area_un <- str_split(M_06$res_area, ";") 
res_area_un <- unique(trimws(unlist(res_area_un)))

# Get the corresponding domains and pub freqs
cairo_domain <- rep("", length(cairo_res_area_un)) 
cairo_area <- rep("", length(cairo_res_area_un))
cairo_area_freq <- rep("", length(cairo_res_area_un))
#GENERAL
domain <- rep("", length(res_area_un)) 
area <- rep("", length(res_area_un))
area_freq <- rep("", length(res_area_un))



for (i in seq_along(cairo_res_area_un)) {
    indexes <- which(sapply(cairo_res_area_un[i] , grepl, cairo_df$res_area))
    domain <-  unique(unlist(cairo_df[cairo_df$res_area == cairo_res_area_un[i], "res_domains"]))
    if (length(domain) == 0) {
        domain <- "na"
    }
    freq <- length(unique(cairo_df[indexes, "ID"]))
    cairo_domain[i] <- as.character(domain)
    cairo_area[i] <-  cairo_res_area_un[i]
    cairo_area_freq[i] <-  freq

}

gen_res_columns <- function (df, res_area_un, res_area_colname="res_areas", res_domain_colname="res_domains", id_colname="ID") {
  #print(res_area_un)
  domain <- rep("", length(res_area_un)) 
  area <- rep("", length(res_area_un))
  area_freq <- rep("", length(res_area_un))
  for (i in seq_along(res_area_un)) {
    indexes <- which(sapply(res_area_un[i] , grepl, as.vector(unlist(df[res_area_colname]))))
    print(paste0("unarea: ",res_area_un[i]))
    #print(as.vector(unlist(df[res_area_colname][1])))
    domain <-  unique(unlist(df[df[res_area_colname] == res_area_un[i], res_domain_colname]))
    print(domain)
    if (length(domain) == 0) {
        domain <- "na"
    }
    freq <- length(unique(df[indexes, id_colname]))
    print(freq)
    domain[i] <- as.character(domain)
    area[i] <-  cairo_res_area_un[i]
    area_freq[i] <- freq

  }
  table <- as.data.frame(cbind(domain, area, area_freq))
  table$area_freq <- as.numeric(table$area_freq)
  rownames(table) <- c()
  table <- table[order(table$area_freq, decreasing = TRUE),]
  ## Some of the res domains aren't defined
  #table[table$area == "Green & Sustainable Science & Technology" , "domain" ] <- "Technology"
  #table[table$area == "Thermodynamics" , "domain" ] <- "Physical Sciences"
  #table[table$area == "Computer Science, Information Systems" , "domain" ] <- "Technology"
  #table[table$area == "Instruments & Instrumentation" , "domain" ] <- "Technology"
  #table[table$area == "Materials Science, Coatings & Films" , "domain" ] <- "Technology"
  #table[table$area == "Engineering, Manufacturing" , "domain" ] <- "Technology"
  #table[table$area == "Metallurgy & Metallurgical Engineering" , "domain" ] <- "Technology"
  #table[table$area == "Biochemistry & Molecular Biology" , "domain" ] <- "Physical Sciences"
  #table[table$area == "Physics, Atomic, Molecular & Chemical" , "domain" ] <- "Physical Sciences"
  #table[table$area == "Engineering, Industrial" , "domain" ] <- "Technology"
  #table[table$area == "Chemistry, Applied" , "domain" ] <- "Physical Sciences"
  #table[table$area == "Operations Research & Management Science" , "domain" ] <- "Technology"
  #table[table$area == "Engineering, Multidisciplinary" , "domain" ] <- "Technology"
  #table[table$area == "Marine & Freshwater Biology" , "domain" ] <- "Physical Sciences"
  #table[table$area == "Computer Science, Software Engineering" , "domain" ] <- "Technology"
  #table[table$area == "Mechanics" , "domain" ] <- "Technology"
  #table[table$area == "Mathematics" , "domain" ] <- "Physical Sciences"
  #table[table$area == "Crystallography" , "domain" ] <- "Physical Sciences"
  

  return(table)
}

cairo_table <- as.data.frame(cbind(cairo_domain, cairo_area, cairo_area_freq))
cairo_table$cairo_area_freq <-  as.numeric(cairo_table$cairo_area_freq)
rownames(cairo_table) <- c()
cairo_table <- cairo_table[order(cairo_table$cairo_area_freq, decreasing = TRUE),]




# Some of the res domains aren't defined
cairo_table[cairo_table$cairo_area == "Green & Sustainable Science & Technology" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Thermodynamics" , "cairo_domain" ] <- "Physical Sciences"
cairo_table[cairo_table$cairo_area == "Computer Science, Information Systems" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Instruments & Instrumentation" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Materials Science, Coatings & Films" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Engineering, Manufacturing" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Metallurgy & Metallurgical Engineering" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Biochemistry & Molecular Biology" , "cairo_domain" ] <- "Physical Sciences"
cairo_table[cairo_table$cairo_area == "Physics, Atomic, Molecular & Chemical" , "cairo_domain" ] <- "Physical Sciences"
cairo_table[cairo_table$cairo_area == "Engineering, Industrial" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Chemistry, Applied" , "cairo_domain" ] <- "Physical Sciences"
cairo_table[cairo_table$cairo_area == "Operations Research & Management Science" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Engineering, Multidisciplinary" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Marine & Freshwater Biology" , "cairo_domain" ] <- "Physical Sciences"
cairo_table[cairo_table$cairo_area == "Computer Science, Software Engineering" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Mechanics" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Mathematics" , "cairo_domain" ] <- "Physical Sciences"
cairo_table[cairo_table$cairo_area == "Crystallography" , "cairo_domain" ] <- "Physical Sciences"
# GENERAL
table <- gen_res_columns(df=M_06, res_area_un)

colnames(M_06)
unlist(which(sapply("Engineering", grepl, unlist(M_06["res_areas"])))) 
as.vector(unlist(M_06["res_areas"]))


# Do we need to? Yes, we do
# Remove areas with fewer than 0.05% of the total pub
cairo_thresh <- length(unique(cairo_df$ID)) * 0.005
cairo_table$cairo_area_freq <- as.numeric(cairo_table$cairo_area_freq)
cairo_table <- cairo_table[!(cairo_table$cairo_area_freq < cairo_thresh), ]
cairo_table <- cairo_table[order(cairo_table$cairo_area_freq, decreasing = TRUE), ]
rownames(cairo_table) <- c()
formattable(cairo_table)

# Maybe??
## collapse(cairo_table, cairo_domain)
## 
## kbl(mtcars[1:10, 1:6], caption = "Group Rows") %>%
##   kable_paper("striped", full_width = F) %>%
##   pack_rows("Group 1", 4, 7) %>%
##   pack_rows("Group 2", 8, 10)



######################################## TEST
nrow(cairo_table)
length(cairo_domain)
length(cairo_area )
length(cairo_area_freq)
length(cairo_res_area_un)



# Engineering problem ---> Ditch the sole "Engineering", it is just a confusing extra level
cairo_table <- cairo_table[ -c(which(cairo_table$cairo_area == "Engineering")),]
## en_indexes <- sapply("Engineering", grepl, M_06$res_area)
## en_df <- M_06[en_indexes, ]
## strict_en_indexes <- en_df$res_area == "Engineering"
## en_df[strict_en_indexes, c("res_areas") ]
## which(strict_en_indexes)


library(plotly)

fig <- plot_ly(
  type="treemap",
  labels=c("Eve", "Cain", "Seth", "Enos", "Noam", "Abel", "Awan", "Enoch", "Azura"),
  parents=c("", "Eve", "Eve", "Seth", "Seth", "Eve", "Eve", "Awan", "Eve")
)
fig



# TESTS
library(plotly)

labels = c("Eve", "Cain", "Seth", "Enos", "Noam", "Abel", "Awan", "Enoch", "Azura")
parents = c("", "Eve", "Eve", "Seth", "Seth", "Eve", "Eve", "Awan", "Eve")

fig <- plot_ly(
  type='treemap',
  labels=labels,
  parents=parents,
  values= c(10, 14, 12, 10, 2, 6, 6, 1, 4),
  textinfo="label+value+percent parent+percent entry+percent root",
  domain=list(column=0))

fig <- fig %>% add_trace(
  type='treemap',
  branchvalues="total",
  labels=labels,
  parents=parents,
  values=c(65, 14, 12, 10, 2, 6, 6, 1, 4),
  textinfo="label+value+percent parent+percent entry",
  outsidetextfont=list(size=20, color= "darkblue"),
  marker=list(line= list(width=2)),
  pathbar=list(visible= FALSE),
  domain=list(column=1))

fig <- fig %>% layout(
  grid=list(columns=2, rows=1),
  margin=list(l=0, r=0, b=0, t=0))

fig

# domains and domain freqs

cairo_domains_un <- unlist(unique(cairo_table$cairo_domain))
cairo_domain_freq <- rep(0, length(cairo_domains_un))

for (i in seq_along(cairo_domains_un)) {
    cairo_domain_freq[i] <- length(unique(unlist(cairo_df["ID"][[1]])[which(lapply(cairo_domains_un[i], grepl, unlist(cairo_df$res_domains))[[1]])]))
}
cairo_ek <- as.data.frame(cbind(rep("", length(cairo_domains_un)), cairo_domains_un, cairo_domain_freq))
names(cairo_ek) <- names(cairo_table)
cairo_table <- rbind(cairo_table, cairo_ek)


fig <- plot_ly(
  type='treemap',
  branchvalues="total",
  tiling=list(packing="squarify"),
  labels=unlist(cairo_table$cairo_area),
  parents=unlist(cairo_table$cairo_domain),
  values= as.numeric(unlist(cairo_table$cairo_area_freq)),
  marker=list(line= list(width=2)),
  textfont=list(size=25),
  textinfo="label+value+percent parent+percent entry",
  domain=list(column=0),
  margin=list(l=0, r=0, b=0, t=0))
  
fig

 %>% layout(uniformtext=list(minsize=35
#, mode='hide'
))



ra_df$value <- ra_df$ra_freq
ra_df$value[ra_df$ra == "Technology"] <- sum(as.numeric(ra_df$ra_freq[ra_df$rd == "Technology"]))
ra_df$value[ra_df$ra == "Life Sciences & Biomedicine"] <- sum(as.numeric(ra_df$ra_freq[ra_df$rd == "Life Sciences & Biomedicine"]))
ra_df$value[ra_df$ra == "Physical Sciences"] <- sum(as.numeric(ra_df$ra_freq[ra_df$rd == "Physical Sciences"]))
ra_df$value[ra_df$ra == "Social Sciences"] <- sum(as.numeric(ra_df$ra_freq[ra_df$rd == "Social Sciences"]))
ra_df$value[ra_df$ra == "Arts & Humanities"] <- sum(as.numeric(ra_df$ra_freq[ra_df$rd == "Arts & Humanities"]))
ra_df$value <- as.numeric(ra_df$value)


gen_ra_tree <- plot_ly(
  type='treemap',
  branchvalues="total",
  #tiling=list(packing="squarify"),
  labels=unlist(ra_df$ra),
  parents=unlist(ra_df$rd),
  values= as.numeric(unlist(ra_df$value)),
  ##marker=list(line= list(width=2), colors=c("#FC8D62", "#8DA0CB", "#66C2A5", "#E5C494", "#FFD92F" ), color=ra_df$rd),
  ## marker=list(colors=c("#FC8D62", "#8DA0CB", "#66C2A5", "#E5C494", "#FFD92F" )),
  textfont=list(size=25),
  textinfo="label+value",
  domain=list(column=0),
  # This one is real good
  hovertemplate = paste0(ra_df$ra, ": ", ra_df$ra_freq ," pub.", "<extra></extra>")
    ) %>% layout(treemapcolorway=c("#FC8D62", "#8DA0CB", "#66C2A5", "#E5C494", "#FFD92F" )) 
  
gen_ra_tree

gen_ra_sun <- plot_ly(
  type='sunburst',
  branchvalues="total",
  #tiling=list(packing="squarify"),
  labels=unlist(ra_df$ra),
  parents=unlist(ra_df$rd),
  values= as.numeric(unlist(ra_df$value)),
  ##marker=list(line= list(width=2), colors=c("#FC8D62", "#8DA0CB", "#66C2A5", "#E5C494", "#FFD92F" ), color=ra_df$rd),
  ## marker=list(colors=c("#FC8D62", "#8DA0CB", "#66C2A5", "#E5C494", "#FFD92F" )),
  textfont=list(size=25),
  textinfo="label+value",
  domain=list(column=0),
  # This one is real good
  hovertemplate = paste0(ra_df$ra, ": ", ra_df$ra_freq ," pub.", "<extra></extra>"),
  texttemplate = paste0(ra_df$ra, "\n ", ra_df$ra_freq )
    ) %>% layout(colorway=c("#66C2A5","#FC8D62", "#8DA0CB",  "#E5C494", "#FFD92F" ))  %>% 
    layout(annotations = 
    list(y=-1,text = "A single publication may be associated with multiple research domains/ areas. \n
    The sum of the number of publications in individual research domains/areas does not add up to the total number of publications.", 
      showarrow = F, xref='paper', yref='paper', 
      #xanchor='right', yanchor='auto', xshift=0, yshift=0,
      font=list(size=10))
 )
  
gen_ra_sun



saveRDS(ra_df, "./04_visualisation/05_treemaps/ra_df.Rds")
saveRDS(gen_ra_tree, "./04_visualisation/05_treemaps/gen_ra_tree.Rds")
saveRDS(gen_ra_sun, "./04_visualisation/05_treemaps/gen_ra_sun.Rds")
