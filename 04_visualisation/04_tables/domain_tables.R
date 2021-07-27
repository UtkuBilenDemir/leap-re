library(formattable)
library(sparkline)
library(dplyr)
library(formattable)
library(tidyr)
library(data.table)
library(htmltools)
library(reticulate)

pd <- import("pandas")
M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0608_org_proper.pickle")
M_06_ex <- readRDS("./01_data/02_bibliometrix/res_area_exp_069999_res_oty.Rds")
wos_dict <- readRDS("./../bibliometry_module/00_data/research_areas/wos_dictionary.Rds")

unique_domains <- unique(M_06_ex$res_domains)
# domain dfs
ps_df <- M_06_ex[M_06_ex$res_domains == "Physical Sciences",]
nrow(ps_df)

un_domain <- rep("", nrow(M_06_ex))
un_id <- unique(M_06_ex$ID)
for (i in seq_along(un_id)) {
  ind <- M_06_ex$ID == un_id[i]
  res_dom_list <- str_split(M_06_ex$res_domains[as.vector(which(ind))[1]], ";")
  for (j in seq_along(res_dom_list)) {
    un_domain[which(ind)[j]] <- res_dom_list[[1]][j]
    print(un_domain[which(ind)[j]])
  }
}
M_06_ex$res_areas[un_domain==""]

colnames(M_06_ex)
wos_dict["Agriculture, Multidisciplinary", ] <- "Life Sciences & Biomedicine"            
wos_dict["Engineering, Marine",] <- "Technology"
wos_dict["Engineering, Ocean"                           ,] <- "Technology"
wos_dict["Engineering, Multidisciplinary"               ,] <- "Technology"
wos_dict["Mathematics, Interdisciplinary Applications"  ,] <- "Physical Sciences"
wos_dict["Materials Science, Coatings & Films"          ,] <- "Technology"
wos_dict["Engineering, Industrial"                      ,] <- "Technology"
wos_dict["Agriculture, Dairy & Animal Science"          ,] <- "Life Sciences & Biomedicine"
wos_dict["Engineering, Petroleum"                       ,] <- "Technology"
wos_dict["Medicine, General & Internal"                 ,] <- "Life Sciences & Biomedicine"
wos_dict["Geography, Physical"                          ,] <- "Physical Sciences"
wos_dict["Physics, Fluids & Plasmas"                    ,] <- "Physical Sciences"
wos_dict["Chemistry, Medicinal"                         ,] <- "Life Sciences & Biomedicine"
wos_dict["Materials Science, Ceramics"                  ,] <- "Technology"
wos_dict["Materials Science, Characterization & Testing",] <- "Technology"
wos_dict["Engineering, Manufacturing"                   ,] <- "Technology"
wos_dict["Education, Scientific Disciplines"            ,] <- "Social Sciences"
wos_dict["Medicine, Legal"                              ,] <- "Life Sciences & Biomedicine"
wos_dict["Materials Science, Paper & Wood"              ,] <- "Technology"
wos_dict["Computer Science, Cybernetics"                ,] <- "Technology"
wos_dict["Business"                                     ,] <- "Social Sciences"
wos_dict["Engineering, Biomedical"                      ,] <- "Technology"
wos_dict["Physics, Nuclear"                             ,] <- "Physical Sciences"
wos_dict["Engineering, Geological"                      ,] <- "Technology"
wos_dict["Materials Science, Biomaterials"              ,] <- "Technology"
wos_dict["Psychology, Social"                           ,] <- "Social Sciences"
wos_dict["Psychology, Clinical"                         ,] <- "Life Sciences & Biomedicine"
wos_dict["Humanities, Multidisciplinary"                ,] <- "Arts & Humanities"
wos_dict["Psychology, Applied"                          ,] <- "Social Sciences"
wos_dict["Industrial Relations & Labor"                 ,] <- "Technology"
wos_dict["Gerontology", ] <- "Life Sciences & Biomedicine"


saveRDS(wos_dict, "./../bibliometry_module/00_data/research_areas/wos_dictionary.Rds")


un_dict_domain <- rep("", nrow(M_06_ex))
for (i in seq_along(M_06_ex$res_areas)) {
  un_dict_domain[i] <- wos_dict[M_06_ex$res_areas[i],]
}

unique(M_06_ex$res_areas[is.na(un_dict_domain)])
unique(wos_dict)

