library(stringr)
library(tidyverse)

M_05 <- readRDS(file = "01_data/02_bibliometrix/05.01_dataframe_seperated-aff_-_cou_cleaned_-_cou_freq.Rds")
au_off <- readRDS(file = "01_data/04_geospatial_data/au_official_boundaries.Rds")
cou_table <- readRDS(file = "01_data/0201_tables/country_table.Rds")

# Correct the country names
M_05$Country_names

corr_country_names <- str_to_title(M_05$Country)

corrected.african_country_names <- cou_table[M_05$Country, "au_off_names"]
corrected.african_indexes <- which(!is.na(corrected.african_country_names))
corr_country_names[corrected.african_indexes] <- corrected.african_country_names[corrected.african_indexes]
M_05$Country_names <- corr_country_names


# Find the relative growth for each country
M_05$Country_names
  
years.max_index <- max(M_05$PY) == M_05$PY  
years.min_index <- min(M_05$PY) == M_05$PY  

rel_pub <- rep(NA, nrow(M_05))
cou_name_un <- unique(M_05$Country_names)
for(i in 1:length(cou_name_un)){
  print(i)
  temp_indexes <- M_05$Country_names == cou_name_un[i]
  
  max_year_freq <- length(unique(M_05$ID[M_05$PY[temp_indexes] == max(M_05$PY)]))
  min_year_freq <- length(unique(M_05$ID[M_05$PY[temp_indexes] == min(M_05$PY)]))
  rel <- max_year_freq/min_year_freq
  rel_pub[temp_indexes] <- rel
}

rel_pub[rel_pub == Inf] <- NA


M_05$Country_relative <- rel_pub
M_05[, c("Country_names", "cou_tot_pub","Country_relative")]

saveRDS(M_05, file = "01_data/02_bibliometrix/05.02_dataframe_seperated-aff_-_cou_refactored.Rds")

# Add it to the country table
