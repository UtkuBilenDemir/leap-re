library(stringr)
M_05 <- readRDS(file = "01_data/02_bibliometrix/05.03_dataframe_seperated-aff_-_res_areas.Rds")

# Clean city names
new_city <- M_05$Affiliation %>%
str_split(",") %>%
lapply( function(x) x[length(x) -1]) %>%
trimws()

# Some city names include the zipcode (which is important information)
# split the words so we can examine
split_city <- new_city %>%
str_split(" ")


# Extract the zipcodes and remove those from the cities
zip_code <- rep(NA, nrow(M_05))
for(i in 1:length(split_city)){
  zip_check <- lapply( "\\d", grepl, split_city[i][[1]] )[[1]]
  print(split_city[i][[1]] )
  if(sum(zip_check) != 0){
    print(split_city[i][[1]][which(zip_check)])
    zip_code[i] <- split_city[i][[1]][which(zip_check)]
    split_city[i][[1]] <- split_city[i][[1]][-c(which(zip_check))]
  }
}

# Let's rebind the new city names
new_city <- split_city %>% 
  lapply(paste, collapse=" ") %>%
  unlist()


# Clean department names
new_department <- M_05$Affiliation %>%
  str_split(",") %>%
  lapply( function(x) paste(x[-c(1, length(x)-1, length(x))], collapse=",")) %>%
  trimws()

# Add those to the df
M_05$City <- new_city
M_05$ZIP <- zip_code
M_05$Department <- new_department

colnames(M_05)[c(1:78, 97, 79, 82, 80:81, 83:96 )]

# Reorder columns
M_06 <- M_05[, c(1:78, 97, 79, 82, 80:81, 83:96 )]

saveRDS(M_06, file = "01_data/02_bibliometrix/06_dataframe_-_improved_affiliations.Rds")