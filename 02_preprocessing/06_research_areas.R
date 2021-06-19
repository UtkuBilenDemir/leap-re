library(stringr)
library(data.table)
M_05 <- readRDS(file = "01_data/02_bibliometrix/05.02_dataframe_seperated-aff_-_cou_refactored.Rds")
cou_table <- readRDS(file = "01_data/0201_tables/country_table_-_2.Rds")

wos_categories <- read_csv("../bibliometry_module/00_data/research_areas/wos_categories.csv")
## # Load SciMet journal classification from bib. module 
## scimet <- read_csv("../bibliometry_module/00_data/science_metrix/journal->SciMet.csv")
## scimet_class <- read_csv("../bibliometry_module/00_data/science_metrix/sm_journal_classification_106_1.csv")
## 
## # Create SciMet columns in the df
## scimet_A <- rep(NA, nrow(M_05))
## scimet_B <- rep(NA, nrow(M_05))
## scimet_C <- rep(NA, nrow(M_05))
## 
## M_05$SO[!(unique(str_to_title(M_05$SO)) %in% scimet$jou)]
## length(unique(str_to_title(M_05$SO)))
## length(scimet$jou)
## 
## 
## 
##   
## sum(unique(M_05$SN) %in% scimet$issn)
## length(unique(M_05$SN))
## 
## M_05$SO[which(!(unique(str_to_title(M_05$SO)) %in% scimet_class$Source_title))]
## 
## 
## test <- rep(NA, length(unique(M_05$SO)))
## for(i in 1:length(test)){
##   print(i)
##   try(
##   test[i] <- agrep(unique(M_05$SO)[i], scimet_class$Source_title, ignore.case = TRUE )
##   )
## }
## agrepl(M_05$SO, scimet_class$Source_title, ignore.case = TRUE)
## 
## scimet_class$Source_title[2247]
## 
## sum(!is.na(test))
## saveRDS(test, file = "01_data/test.Rds")
## 
## test
## na_index <- is.na(test)
## unique(M_05$SN)[(!is.na(unique(M_05$SO)[na_index]))]
## 
## un_jou_df <- unique(M_05[, c("SO", "SN", "EI")])
## test2 <- rep(NA, nrow(un_jou_df))
## wh_issn <- which(!is.na(un_jou_df$SN))
## wh_essn <- which(!is.na(un_jou_df$EI) & is.na(un_jou_df$SN)) 
## wh_jname <- which(!is.na(un_jou_df$SO & is.na(un_jou_df$EI) & is.na(un_jou_df$SN)))
## for(i in 1:length(test2)){
##   print(i)
##   if(i %in% wh_issn){
##     tryCatch(
##       test2[i] <- which(un_jou_df$SN[i] == scimet_class$issn),
##       error = function(e) {
##         try(test2[i] <- agrep(un_jou_df$SO[i], scimet_class$Source_title, ignore.case = TRUE ))
##       }
##     ) 
##   } else if(i %in% wh_essn){
##     tryCatch(
##       test2[i] <- which(un_jou_df$EI[i] == scimet_class$essn),
##       error = function(e) {
##         try(test2[i] <- agrep(un_jou_df$SO[i], scimet_class$Source_title, ignore.case = TRUE ))
##       }
##     )
##   } else if(i %in% wh_issn){
##     try(
##       test2[i] <- agrep(un_jou_df$SO[i], scimet_class$Source_title, ignore.case = TRUE )
##     )
##   }
## } 
## 
## test2[920]
## agrep(M_05$SN[13],scimet_class$issn, ignore.case = TRUE)
## 
## 
## un_jou_df$SN[920]
## 
## 
## ## !!! Journal classification approach has yield problematic results. Tehere are 
## ## over 2500 journals that couldn't be identified through science metrix cat.
## ## ABORT !!!


ncol(wos_categories)
match(M_05$WC, wos_categories$`Life Sciences & Biomedicine`)

# Create a dictionary from the wos categorization
wos_dict <- as.data.frame(c(wos_categories$`Arts & Humanities`, 
      wos_categories$`Life Sciences & Biomedicine`, 
      wos_categories$`Physical Sciences`,
      wos_categories$`Social Sciences`,
      wos_categories$Technology))

wos_dict$row <- rep(colnames(wos_categories), each=nrow(wos_categories))
colnames(wos_dict)[1] <- "res_areas"
wos_dict.na <- which(is.na(wos_dict$res_areas))
wos_dict <- wos_dict[-c(wos_dict.na), ]
rownames(wos_dict) <-  wos_dict$res_areas
wos_dict.row <- wos_dict$res_areas
wos_dict <- as.data.frame(wos_dict[,"row"])
rownames(wos_dict) <- str_to_title(wos_dict.row)


# Create a proper column with proper names
M_05$res_areas <- str_to_title(M_05$WC)
M_05$res_areas[M_05$res_areas == "Materials Science, Biomaterials"] <- "Materials Science"
M_05$res_areas[M_05$res_areas == "Agriculture, Multidisciplinary"] <- "Agriculture"
M_05$res_areas[M_05$res_areas == "Engineering, Multidisciplinary"] <- "Engineering"
M_05$res_areas[M_05$res_areas == "Business, Finance"] <- "Business & Economics"
M_05$res_areas[M_05$res_areas == "Materials Science, Composites"] <- "Materials Science"
M_05$res_areas[M_05$res_areas == "Materials Science, Textiles"] <- "Materials Science"
M_05$res_areas[M_05$res_areas == "Engineering, Multidisciplinary"] <- "Engineering"

M_05$res_areas <- M_05$res_areas %>% gsub("Business;", "Business & Economics;", .)

research_domain <- rep(NA, nrow(M_05))
for(i in 1:length(M_05$res_areas)){
  wc_list <- str_split(M_05$res_areas[i], "; ")
  wc_list <- wc_list[[1]]
  if(length(wc_list) > 1){
    temp <- rep(NA, length(wc_list))
    for(k in 1:length(wc_list)){
      temp[k] <- wos_dict[wc_list[k],]
      if(is.na(temp[k])){
        temp[k] <- wos_dict[str_split(wc_list[k], ",")[[1]][1], ]
        if(is.na(temp[k])){
        print(paste0("-> ", wc_list[k]))
        }
        }
    } 
    temp <- paste(temp, collapse = ";")
    } else {
      temp <- wos_dict[wc_list[1],]
    }
    research_domain[i] <- unique(temp)
  }



saveRDS(wos_dict, "../bibliometry_module/00_data/research_areas/wos_dictionary.Rds")
saveRDS(M_05, file = "01_data/02_bibliometrix/05.03_dataframe_seperated-aff_-_res_areas.Rds")