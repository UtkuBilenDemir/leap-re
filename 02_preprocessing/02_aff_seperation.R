library(tidyr)
library(dplyr) 
# The following comes with rownames :(
## M <- readRDS(file = "01_data/02_bibliometrix/02_bib_dataframe_noab.Rds")

M <- read.csv(file = "01_data/02_bibliometrix/02_bib_dataframe_noab.csv", sep = "\t")

# Split C1 column at ";"s
# and create the affiliations column.
# Each affiliation needs to have its own row
M_exp <- M %>%
  mutate(Affiliation =  strsplit(C1 ,split=';', fixed=TRUE) ) %>%
  unnest(c(Affiliation)) %>%
  mutate(Affiliation = trimws(Affiliation))

write.csv(M_exp, file = "01_data/02_bibliometrix/03_bib_dataframe_exploded-aff.csv",
             row.names = F)

# Elements seperated by a "," in the affiliation entries
# corresponds to following categories:
# 1. Organisation
# 2. Department (!!!might include a couple of entries/levels!!!)
# 3. City (might include ZIPCODE)
# 4. Country

Organisation <- vector(mode="character", length=nrow(M_exp))
Department <- vector(mode="character", length=nrow(M_exp))
City <- vector(mode="character", length=nrow(M_exp))
Country <- vector(mode="character", length=nrow(M_exp))

sep_aff <- sapply(as.vector(M_exp$Affiliation), strsplit, ",")
for(i in seq_along(sep_aff)){
  aff_list <- sep_aff[i][[1]]
  Organisation[i] <- trimws(aff_list[1])
  if(length(aff_list) >= 2){
  Country[i] <- gsub("\\.", "", trimws(aff_list[length(aff_list)]), perl=TRUE) 
    if(length(aff_list) >= 3){
    City[i] <- trimws(aff_list[length(aff_list)-2])
      if(length(aff_list) >= 4){
        Department[i] <- trimws(try(aff_list[2:length(aff_list)-2]))
      }
    }
  }
}


M_aff <- cbind(M_exp, 
                 "Organisation" = Organisation, 
                 "Department" = Department, 
                 "City" = City,
                 "Country" = Country)

View(M_aff)
write.csv(M_aff, file = "01_data/02_bibliometrix/04_bib_dataframe_seperated-aff.csv",
             row.names = F)
