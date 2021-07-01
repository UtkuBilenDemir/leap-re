library(stringr)
library(tidyverse)
library(reticulate)
pd <- import("pandas")

M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0606_org_prop.pickle")
M_06_new <- readRDS("./01_data/02_bibliometrix/0607_org_oty.Rds")
M_06_new
## au_off <- readRDS(file = "01_data/04_geospatial_data/au_official_boundaries.Rds")
## org_table <- readRDS(file = "01_data/0201_tables/country_table.Rds")


unique(M_06[M_06$au_off_country == "South Africa", "cou_tot_pub"])
unique(M_06_new[M_06_new$au_off_country == "South Africa", "cou_tot_pub"])
  
# Create pub freq columns for each year
for(year in sort(unique(M_06$PY), decreasing = FALSE)){
  new_col_name <- paste0('org_pub_', year)
  M_06[[new_col_name]] <- NA
}


years.max_index <- max(M_06$PY) == M_06$PY  
years.min_index <- min(M_06$PY) == M_06$PY  

org_rel_pub <- rep(NA, nrow(M_06))
org_name_un <- unique(M_06$org_prop)
for(i in 1:length(org_name_un)){
  print(i)
  temp_indexes <- M_06$org_prop == org_name_un[i][[1]]
  temp_org_df <- M_06[temp_indexes, ]
  
  max_year_freq <- length(unique(temp_org_df$ID[temp_org_df$PY == max(M_06$PY)]))
  min_year_freq <- length(unique(temp_org_df$ID[temp_org_df$PY == min(M_06$PY)]))
  rel <- max_year_freq/min_year_freq
  org_rel_pub[temp_indexes] <- rel
  
  # Also create columns with pub. frequencies in each year
  for(year in sort(unique(M_06$PY), decreasing = FALSE)){
    temp_df <- M_06[temp_indexes, ]
    temp_year_indexes <- temp_df$PY == year
    year_pub_freq <- length(unique(temp_df$ID[temp_year_indexes]))
    
    year_col_name <- paste0("org_pub_", year)
    M_06[[year_col_name]][temp_indexes] <- year_pub_freq
  }
}
print("bitti")

1+1
org_rel_pub

org_rel_pub[org_rel_pub == Inf] <- NA


M_06$org_relative <- org_rel_pub
M_06[, c("org_prop", "org_freq_prop", "org_relative")]
colnames(M_06)


# Add it to the country table

##cou_rel <-  rep(NA, nrow(cou_table))
##citat <-  rep(NA, nrow(cou_table))
##for(i in 1:nrow(cou_table)){
##  cou_rel[i] <- M_05$Country_relative[cou_table$au_off_names[i] == M_05$Country_names][1]
##}

##cou_table$rel_pub <- cou_rel
##
### TODO: Times Cited?
##
### Sort them
##cou_table[order(cou_table$tot_pub, decreasing = TRUE),]

# Create Publication frequency columns for each year

# ---

saveRDS(M_06, file = "./01_data/0607_org_oty.Rds")
M_06 <- as.data.frame(apply(M_06, 2, as.character))
write_csv(M_06, file = "./01_data/0607_org_oty.csv")
## saveRDS(unsd_regions, file = "01_data/0201_tables/country_table_-_2.Rds")

write_csv(as.data.frame(apply(M_06_new, 2, as.character)), file = "./01_data/02_bibliometrix/0607_org_oty.csv")


write_csv(as.data.frame(apply(M_06_new, 2, as.character)), file = "./01_data/0688_org_oty.csv")


2+2
