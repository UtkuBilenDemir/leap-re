library(reticulate)
library(tidytext)
library(stringr)

pd <- import("pandas")
M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0608_org_proper.pickle")
M_06_ex <- readRDS("./01_data/02_bibliometrix/res_area_exp_069999_res_oty.Rds")
wos_dict <- readRDS("./../bibliometry_module/00_data/research_areas/wos_dictionary.Rds")

# domain dfs
ps_df <- M_06_ex[M_06_ex$prop_domain == "Physical Sciences", ]
te_df <- M_06_ex[M_06_ex$prop_domain == "Technology", ]
ls_df <- M_06_ex[M_06_ex$prop_domain == "Life Sciences & Biomedicine", ]
ss_df <- M_06_ex[M_06_ex$prop_domain %in% c("Social Sciences" , "Arts & Humanities"), ]


str_split(trimws(str_split(M_06_ex$DE[300], ";")[[1]]), " ")

paste0(sapply(FUN=gsub," ", "_", trimws(str_split(M_06_ex$DE[300], ";")[[1]]), fixed = TRUE), collapse=" ")

M_06_ex$prop_keyword <- M_06_ex$DE %>%
  sapply(FUN=gsub, "; ", "-", ., fixed=TRUE) %>%
  sapply(FUN=gsub, " ", "_", ., fixed=TRUE) %>%
  sapply(FUN=gsub, "-", " ", ., fixed=TRUE) 



#M_06_ex$text <-  M_06_ex["TI"]
bla <-  unlist(unique(M_06_ex["TI"]))
#bigrams <-   text %>%
  
bla[300]  
length(bla)

bigram = "" 
test_tok <- unnest_tokens(as.character(bla), bigram, token = "ngrams", n = 2)




gsub("; ", "-", M_06_ex$DE[300]) 
