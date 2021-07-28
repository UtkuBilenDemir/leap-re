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

M_06_ex$prop_domain <- un_dict_domain
sum(is.na(M_06_ex$prop_domain))

unique(M_06_ex$prop_domain)


sample_indexes <- sample(1:nrow(M_06_ex), 900)
cbind(M_06_ex$res_areas[sample_indexes], M_06_ex$prop_domain[sample_indexes])[1:100,]    # seems fine

# domain dfs
ps_df <- M_06_ex[M_06_ex$prop_domain == "Physical Sciences", ]
te_df <- M_06_ex[M_06_ex$prop_domain == "Technology", ]
ls_df <- M_06_ex[M_06_ex$prop_domain == "Life Sciences & Biomedicine", ]
ss_df <- M_06_ex[M_06_ex$prop_domain %in% c("Social Sciences" , "Arts & Humanities"), ]


# -> Go to each individual publication
# -> get the organisations
# -> assess each combination a row with the number of co-pub
partner_find <- function (df, ID_colname="ID", org_colname="org_prop") {
  df[ID_colname] <- as.vector(unlist(df[ID_colname]))
  org_pair <- vector()
  co_pub <-  vector()
  ids <- list()
  un_ids <- as.vector(unlist(unique(df[ID_colname])))
  for (i in seq_along(un_ids)) {
    print(paste0(i/length(un_ids), " is completed"))
    id_df <- df[df[ID_colname] == un_ids[i], ]
    temp_orgs <- unlist(unique(id_df[org_colname]))
    # Get all combinations of the orgs (stored in columns)
    if(length(temp_orgs) < 2 ) {
      next()
    } else{
      temp_orgs_combn <- combn(temp_orgs, 2)
      for (j in seq_len(ncol(temp_orgs_combn))) {
        pair <- paste0(temp_orgs_combn[ ,j], collapse=",")
        pair2 <- paste0(rev(temp_orgs_combn[ ,j]), collapse=",")
        if (pair %in% org_pair) {
          ind <- which(pair ==org_pair)
          co_pub[ind] <- co_pub[ind] + 1
          ids[ind] <- paste0(as.character(ids[ind]), as.character(un_ids[i]), collapse = ",")
          #ids[ind] <- c(ids[ind], un_ids[i])
        } else if (pair2 %in% org_pair) {
          ind <- which(pair2==org_pair)
          co_pub[ind] <- co_pub[ind] + 1
          ids[ind] <- paste0(as.character(ids[ind]), as.character(un_ids[i]), collapse = ",")
          ids[ind] <- c(ids[ind], un_ids[i])
        } else {
          org_pair <- c(org_pair, pair)
          co_pub <- c(co_pub, 1)
          ids <- c(ids, as.character(un_ids[i]))
        }
      if (i %% 1000 == 0) {
        print(ids)
      }
      }
    }
  }
  out_df <- as.data.frame(cbind(org_pair, co_pub, ids))
  out_df$co_pub <- as.numeric(out_df$co_pub)
  out_df <- out_df[order(out_df$co_pub, decreasing = TRUE), ] 
  rownames(out_df) <- NULL
  return(out_df)
}

print("ps")
ps_part_df <-  partner_find(ps_df)
print("tech")
te_part_df <-  partner_find(te_df)
print("ls")
ls_part_df <-  partner_find(ls_df)
print("ss")
ss_part_df <-  partner_find(ss_df)

saveRDS(ps_part_df, "./01_data/06_domain_partnerships/ps_part_df.Rds")
saveRDS(te_part_df, "./01_data/06_domain_partnerships/te_part_df.Rds")
saveRDS(ls_part_df, "./01_data/06_domain_partnerships/ls_part_df.Rds")
saveRDS(ss_part_df, "./01_data/06_domain_partnerships/ss_part_df.Rds")




rownames(te_part_df) <- NULL

head(ps_part_df, 10)

head(te_part_df)
head(ls_part_df)
head(ss_part_df, 10)

# <- create a data frame in form 
# [country1, org1, # of co-pub, most popular res area, org2, country2]
gen_pair_table <- function(df, 
                          main_df, 
                          id_colname="ids", 
                          org_colname="org_pair", 
                          country_colname="Country_names",
                          main_org_colname="org_prop") {
  for (i in seq_len(nrow(df))) {
    pair1 <- str_split(df[i, org_colname], ",")[1]
    country1 <- main_df[main_df[main_org_colname] == pair1, country_colname][1]
    pair2 <- str_split(df[i, org_colname], ",")[2]
    country2 <- main_df[main_df[main_org_colname] == pair2, country_colname][1]
    research_areas <
  }
}

colnames(M_06_ex)
as.data.frame(table(M_06_ex["Country_names"]))

as.character(M_06_ex$ID[1000])
