library(stringr)
library(tidyverse)
library(reticulate)
library(tidyr)
library(dplyr)   

M_06 <- readRDS("./01_data/02_bibliometrix/0607_org_oty.Rds")



# !!!! IT IS IMPORTANT TO EXPLODE THE DATAFRAME !!!!
M_06_ex <- M_06 %>%
     separate_rows("res_areas", sep=";")
M_06_ex$res_areas <- trimws(M_06_ex$res_areas)


# Create pub freq columns for each year
for(year in sort(unique(M_06_ex$PY), decreasing = FALSE)){
  new_col_name <- paste0('res_area_pub_', year)
  M_06_ex[[new_col_name]] <- NA
}



years.max_index <- max(M_06_ex$PY) == M_06_ex$PY  
years.min_index <- min(M_06_ex$PY) == M_06_ex$PY  

res_rel_pub <- rep(NA, nrow(M_06_ex))
res_pub_freq <- rep(NA, nrow(M_06_ex))

res_name_un <- unique(M_06_ex$res_areas)
for(i in seq_along(res_name_un)){
  print(res_name_un[i])
  temp_indexes <- M_06_ex$res_areas == res_name_un[i][[1]]
  temp_res_df <- M_06_ex[temp_indexes, ]
  pub_freq <- length(unique(M_06_ex[temp_indexes, "ID" ]))
  
  max_year_freq <- length(unique(temp_res_df$ID[temp_res_df$PY == max(M_06_ex$PY)]))
  min_year_freq <- length(unique(temp_res_df$ID[temp_res_df$PY == min(M_06_ex$PY)]))
  rel <- max_year_freq/min_year_freq
  res_rel_pub[temp_indexes] <- rel
  
  # Also create columns with pub. frequencies in each year
  for(year in sort(unique(M_06_ex$PY), decreasing = FALSE)){
    temp_df <- M_06_ex[temp_indexes, ]
    temp_year_indexes <- temp_df$PY == year
    year_pub_freq <- length(unique(temp_df$ID[temp_year_indexes]))
    
    year_col_name <- paste0("res_area_pub_", year)
    M_06_ex[[year_col_name]][temp_indexes] <- year_pub_freq
  }
}

colnames(M_06_ex)

sum(M_06_ex[1, c(107:116)])
length(unique(M_06$ID[M_06_ex$res_areas[1] == M_06_ex$res_areas]))
res_rel_pub

res_rel_pub[res_rel_pub == Inf] <- NA



# PUB FREQ res area
M_06_ex$res_pub_freq <- NA
for (i in seq_along(unique(M_06_ex$res_areas))) {
    indexes <-  which(unique(M_06_ex$res_areas)[i] == M_06_ex$res_areas)
    
    M_06_ex$res_pub_freq[indexes] <- length(unique(as.vector(M_06_ex$ID[indexes])))
    print(
     length(indexes))
}


length(unique(M_06_ex$ID[sample(100,100,1000)]))

trimws(unique(M_06_ex$res_areas)[i]) == "Geriatrics & Gerontology"
M_06_ex[1:10, c("res_areas", "res_pub_freq")]
M_06_ex$res_areas[1:10]

M_06_ex$res_relative <- res_rel_pub
M_06_ex[, c("res_areas", "res_area_pub_2011", "res_area_pub_2020","res_relative")]

colnames(M_06_ex)

saveRDS(M_06_ex, file = "./01_data/02_bibliometrix/res_area_exp_069999_res_oty.Rds")
write_csv(M_06_ex, file = "./01_data/02_bibliometrix/res_area_exp_06999_res_oty.csv")
## saveRDS(unsd_regions, file = "01_data/0201_tables/country_table_-_2.Rds")
