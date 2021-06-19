library(stringr)
M_05 <- readRDS(file = "01_data/02_bibliometrix/05.02_dataframe_seperated-aff_-_cou_refactored.Rds")
cou_table <- readRDS(file = "01_data/0201_tables/country_table_-_2.Rds")

# Load SciMet journal classification from bib. module 
scimet <- read_csv("../bibliometry_module/00_data/science_metrix/journal->SciMet.csv")
scimet_class <- read_csv("../bibliometry_module/00_data/science_metrix/sm_journal_classification_106_1.csv")

# Create SciMet columns in the df
scimet_A <- rep(NA, nrow(M_05))
scimet_B <- rep(NA, nrow(M_05))
scimet_C <- rep(NA, nrow(M_05))

M_05$SO[!(unique(str_to_title(M_05$SO)) %in% scimet$jou)]
length(unique(str_to_title(M_05$SO)))
length(scimet$jou)



  
sum(unique(M_05$SN) %in% scimet$issn)
length(unique(M_05$SN))

M_05$SO[which(!(unique(str_to_title(M_05$SO)) %in% scimet_class$Source_title))]


test <- rep(NA, length(unique(M_05$SO)))
for(i in 1:length(test)){
  print(i)
  try(
  test[i] <- agrep(unique(M_05$SO)[i], scimet_class$Source_title, ignore.case = TRUE )
  )
}
agrepl(M_05$SO, scimet_class$Source_title, ignore.case = TRUE)

scimet_class$Source_title[2247]

sum(!is.na(test))
saveRDS(test, file = "01_data/test.Rds")
