library(formattable)
library(sparkline)
library(dplyr)
library(formattable)
library(tidyr)
library(data.table)
library(htmltools)
library(reticulate)
library(stringr)
library(tidyr)
library(kableExtra)

pd <- import("pandas")
M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0608_org_proper.pickle")
M_06_ex <- readRDS("./01_data/02_bibliometrix/res_area_exp_07_ngrams.Rds")
M_06_ex <- as.data.frame(M_06_ex)
# Important org_name correction:



M_06[M_06["org_prop"] == "Chungbuk National University", "org_prop"] <- "JeonBuk National University"
M_06_ex[M_06_ex["org_prop"] == "Chungbuk National University", "org_prop"] <- "JeonBuk National University"
## M_06_ex$org_prop <- as.list(M_06_ex$org_prop)
## M_06_ex$org_prop <- lapply(M_06_ex$org_prop, function(x) replace(x,is.null(x)," "))
## M_06_ex$org_prop <- unlist(M_06_ex$org_prop)
## M_06_ex[which(M_06_ex["org_prop"] == "Chungbuk National University"), "org_prop"][[1]] <- "JeonBuk National University"
## 
wos_dict <- readRDS("./../bibliometry_module/00_data/research_areas/wos_dictionary.Rds")

# Better formattable methods
bg <- readRDS("../bibliometry_module/88_supplementary_methods/formattable_color_grader.Rds")
color_bar2 <- readRDS("../bibliometry_module/88_supplementary_methods/formattable_better_color_bar.Rds")


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

M_06_ex$prop_domain <- un_dict_domain

sample_indexes <- sample(1:nrow(M_06_ex), 900)
cbind(M_06_ex$res_areas[sample_indexes], M_06_ex$prop_domain[sample_indexes])[1:100,]    # seems fine

# domain dfs
ps_df <- M_06_ex[M_06_ex$prop_domain == "Physical Sciences", ]
rownames(ps_df) <-  NULL
te_df <- M_06_ex[M_06_ex$prop_domain == "Technology", ]
rownames(te_df) <-  NULL
ls_df <- M_06_ex[M_06_ex$prop_domain == "Life Sciences & Biomedicine", ]
rownames(ls_df) <-  NULL
ss_df <- M_06_ex[M_06_ex$prop_domain %in% c("Social Sciences" , "Arts & Humanities"), ]
rownames(ss_df) <-  NULL


# -> Go to each individual publication
# -> get the organisations
# -> assess each combination a row with the number of co-pub
partner_find <- function (df, ID_colname="ID", org_colname="org_prop") {
  df[ID_colname] <- as.vector(unlist(df[ID_colname]))
  org_pair <- vector()
  co_pub <-  vector()
  ids <- character()
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
          ids[ind] <- paste0(as.character(ids[ind]), ",", as.character(un_ids[i]))
          #ids[ind] <- c(ids[ind], un_ids[i])
        } else if (pair2 %in% org_pair) {
          ind <- which(pair2==org_pair)
          co_pub[ind] <- co_pub[ind] + 1
          ids[ind] <- paste0(as.character(ids[ind]), ",", as.character(un_ids[i]))
          #ids[ind] <- c(ids[ind], un_ids[i])
        } else {
          org_pair <- c(org_pair, pair)
          co_pub <- c(co_pub, 1)
          ids <- c(ids, as.character(un_ids[i]))
        }
      #if (i %% 1000 == 0) {
      #  print(ids)
      #}
      }
    }
  }
  out_df <- as.data.frame(cbind(org_pair, co_pub, ids))
  out_df$co_pub <- as.numeric(out_df$co_pub)
  out_df <- out_df[order(out_df$co_pub, decreasing = TRUE), ] 
  rownames(out_df) <- NULL
  return(out_df)
}

# 1
print("ps")
ps_part_df <-  partner_find(ps_df)
rownames(ps_part_df) <-  NULL
print("tech")
te_part_df <-  partner_find(te_df)
rownames(te_part_df) <-  NULL
print("ls")
ls_part_df <-  partner_find(ls_df)
rownames(ls_part_df) <-  NULL
print("ss")
ss_part_df <-  partner_find(ss_df)
rownames(ss_part_df) <-  NULL

saveRDS(ps_part_df, "./01_data/06_domain_partnerships/ps_part_df.Rds")
saveRDS(te_part_df, "./01_data/06_domain_partnerships/te_part_df.Rds")
saveRDS(ls_part_df, "./01_data/06_domain_partnerships/ls_part_df.Rds")
saveRDS(ss_part_df, "./01_data/06_domain_partnerships/ss_part_df.Rds")





head(ps_part_df, 10)

head(te_part_df)
head(ls_part_df)
head(ss_part_df, 10)

# <- create a data frame in form 
# [country1, org1, # of co-pub, most popular res area, org2, country2]
gen_pair_table <- function(df, 
                          main_df, 
                          id_colname="ids", 
                          main_id_colname="ID", 
                          org_colname="org_pair", 
                          country_colname="au_off_country",
                          main_org_colname="org_prop",
                          ra_colname="res_areas",
                          copub_freq_colname="co_pub") {
  country1_list <- vector()
  country2_list <- vector()
  pair1_list <- vector()
  pair2_list <- vector()
  copub_freq_list<- vector()
  mv_ra_list <- vector()
  df <- as.data.frame(df)
  main_df <- as.data.frame(main_df)

  for (i in seq_len(nrow(df))) {
    print(paste0(format(round(i/nrow(df), 2), nsmall = 2), "% is completed"))
    pair1 <- unlist(str_split(df[i, org_colname], ","))[1]
    country1 <- main_df[main_df[main_org_colname] == pair1, country_colname][1]
    pair2 <- unlist(str_split(df[i, org_colname], ","))[2]
    country2 <- main_df[main_df[main_org_colname] == pair2, country_colname][1]

    ids <- as.vector(sapply(str_split(df[i, id_colname], ","), as.numeric))
    #print(ids)
    ids <- which(main_df[[main_id_colname]] %in% ids)
    #print(ids)
    temp_df <- as.data.frame(main_df[ids, ])
    #print(head(temp_df))
    research_areas <- unlist(as.vector(unlist(unique(temp_df[, ra_colname]))))
    re_freqs <- vector()
    for (j in seq_along(research_areas)) {
      re_freqs <- c(re_freqs, length(unique(temp_df[temp_df[ra_colname] == research_areas[j], "ID"])))
    }
    re_freqs <- as.vector(re_freqs)
    re_freqs <-  sapply(re_freqs, as.numeric)
    #print(re_freqs)
    #mv_ra <- paste0(research_areas[order(re_freqs, decreasing = TRUE)[1]], " (", re_freqs[order(re_freqs[1], decreasing=TRUE)], ")")  
    mv_ra <- paste0(research_areas[order(re_freqs, decreasing = TRUE)[1]])  

    country1_list <- c(country1_list, country1)
    country2_list <- c(country2_list, country2)
    pair1_list <- c(pair1_list, pair1)
    pair2_list <- c(pair2_list, pair2)
    copub_freq_list <- c(copub_freq_list, as.vector(unlist(df[copub_freq_colname]))[i])
    mv_ra_list <- c(mv_ra_list, mv_ra)
    }
    return (as.data.frame(cbind(country1_list, pair1_list, copub_freq_list, pair2_list, country2_list, mv_ra_list)))
}

# 2
ps_table <- gen_pair_table(head(ps_part_df, 500), ps_df)
te_table <- gen_pair_table(head(te_part_df, 500), te_df)
ls_table <- gen_pair_table(head(ls_part_df, 500), ls_df)
ss_table <- gen_pair_table(head(ss_part_df, 500), ss_df)

head(te_table)

# What we want is actually an interregional table, there is too many pairings from same country/region


eleminate_reg_pairings <- function(table_df, 
                                  main_df, 
                                  region_colname="eu_au_region", 
                                  country_colname="au_off_country",
                                  country1_colname="country1_list",
                                  country2_colname="country2_list"
                                  ) {
  #main_df[region_colname] <- unlist(main_df[region_colname])
  main_df[is.na(main_df[region_colname]), region_colname] <- " "
  print(unique(main_df[region_colname]))
  rows_to_rm <- vector()
  for (i in seq_len(nrow(table_df))) {
    print(paste0(format(round(i/nrow(table_df), 2), nsmall = 2), "% is completed"))
    print(paste0(table_df[i, country1_colname], " --- ", table_df[i, country2_colname]))
    reg1 <- main_df[which(main_df[country_colname] == table_df[i, country1_colname])[1], region_colname]
    reg2 <- main_df[which(main_df[country_colname] == table_df[i, country2_colname])[1], region_colname]
    if (is.na(reg1) | is.na(reg2) ){
      next()
    } else if (reg1 == reg2) {
      print(paste0(reg1, " ::: ", reg2))
      rows_to_rm <- c(rows_to_rm, i)
    }
  }
  colnames(table_df) <- c("Country 1", "Partner 1", "Num. of co-pub.", "Partner 2", "Country 2", "Most Visible Res. Area")
  return (table_df[-c(rows_to_rm), ])
}


ps_table_interreg <- eleminate_reg_pairings(ps_table, ps_df)
te_table_interreg <- eleminate_reg_pairings(te_table, te_df)
ls_table_interreg <- eleminate_reg_pairings(ls_table, ls_df)
ss_table_interreg <- eleminate_reg_pairings(ss_table, ss_df)
rownames(ps_table_interreg) <- NULL
rownames(te_table_interreg) <- NULL
rownames(ls_table_interreg) <- NULL
rownames(ss_table_interreg) <- NULL
#3
head(ps_table_interreg, 10)
head(te_table_interreg, 10)
head(ls_table_interreg, 10)
head(ss_table_interreg, 10)

colnames(ps_table_interreg)
ps_table_interreg$`Country 1`
# We need to get a specific number of pairings from each region, otherwise it's only Egypt and SA
separate_table_into_regions <- function(table_df,
                                        main_df,
                                        african_colname="African",
                                        main_country_colname="au_off_country",
                                        region_colname="eu_au_region",
                                        country1_colname="Country 1",
                                        country2_colname="Country 2",
                                        partner1_colname="Partner 1",
                                        partner2_colname="Partner 2") {
  table_df$region <- ""
  for (i in seq_len(nrow(table_df))) {
    country1 <- table_df[[country1_colname]][i]
    print(country1)
    country2 <- table_df[[country2_colname]][i]
    african_country <- ""
    # Is the following really boolean?
    condit <- main_df[match( country1, main_df[[main_country_colname]]), african_colname]
    if (is.na(condit)) {
      next()
    } else if (condit == "True") {
      african_country <- country1
    } else {
      african_country <- country2
      # swap if the second partner is the african
      temp_country <- country1
      temp_partner <- table_df[i, partner1_colname]
      table_df[i, partner1_colname] <- table_df[i, partner2_colname]
      table_df[i, country1_colname] <- country2
      table_df[i, partner2_colname] <- temp_partner
      table_df[i, country2_colname] <- temp_country
    }
    region <- main_df[match(african_country, main_df[[main_country_colname]]), region_colname]
    table_df$region[i] <- region
  }
  #table_df <- as.data.frame(cbind(regions, table_df))
  #colnames(table_df)[1] <- "Region"
  #reg_ids <- vector()
  #un_reg <- unique(table_df[["Region"]])
  #for (j in seq_along(un_reg)) {
  #  reg_ids <- c(reg_ids, which(table_df["Region"] == un_reg[j])[1:3])
  #}
  #return(table_df[reg_ids,])
  return(table_df)

}


ps_table_regional <- separate_table_into_regions(ps_table_interreg, M_06_ex)
te_table_regional <- separate_table_into_regions(te_table_interreg, M_06_ex)
ls_table_regional <- separate_table_into_regions(ls_table_interreg, M_06_ex)
ss_table_regional <- separate_table_into_regions(ss_table_interreg, M_06_ex)

au_regions <- unique(ls_table_regional$region)[c(1,6,7,3, 4 )]
pick_from_each_region <- function(table_df, region_colname="region", region_vector=au_regions) {
  inds <- vector()
  inds <- c(inds, which(table_df[[region_colname]] == au_regions[1])[1:5])
  inds <- c(inds, which(table_df[[region_colname]] %in% au_regions[c(2,3,4)])[1:5])
  inds <- c(inds, which(table_df[[region_colname]] == au_regions[5])[1:5])
  out_df <- table_df[inds,]
  out_df[6:10, region_colname] <- "Western, Central, Eastern Africa"
  out_df <- out_df[, c(ncol(out_df), 1:(ncol(out_df)-1))]
  rownames(out_df) <- c("N1", "N2", "N3", "N4", "N5",
                        "WCE1", "WCE2", "WCE3", "WCE4", "WCE5",
                        "S1", "S2", "S3", "S4", "S5")
  return(out_df)
}

ps_table_regional_picked <- pick_from_each_region(ps_table_regional)
te_table_regional_picked <- pick_from_each_region(te_table_regional)
ls_table_regional_picked <- pick_from_each_region(ls_table_regional)
ss_table_regional_picked <- pick_from_each_region(ss_table_regional)

# Prepare formattable tables
gen_pair_table <- function(table_df) {
  out_table <- table_df[,2:ncol(table_df)] %>%
  mutate(
    `Num. of co-pub.` = color_bar2("lightblue")(`Num. of co-pub.`),

    `Country 1` = formattable::formatter("span", style = ~ formattable::style(color = "grey", font.weight = "bold"))(`Country 1`),
    `Country 2` = formatter("span", style = ~ formattable::style(color = "grey", font.weight = "bold", align="c"))(`Country 2`),
    `Partner 1` = formatter("span", style = ~ formattable::style(color = "grey", font.weight = "bold"))(`Partner 1`),
    `Partner 2` = formatter("span", style = ~ formattable::style(color = "grey", font.weight = "bold"))(`Partner 2`),
    `Most Visible Res. Area` = formatter("span", style = ~ formattable::style(color = "grey", font.weight = "bold"))(`Most Visible Res. Area`),

  ) %>%
  kable("html", escape = F, "striped",align=c(rep('l', 2), "c", rep("r", 3)), , table.attr = "style='width:30%;'") %>%
  kable_styling("hover", full_width = F) %>%
  #column_spec(5, width = "3cm") 
  pack_rows(unique(test$region)[1], 1, 5 , label_row_css = "background-color: #C9A38D; color: #fff;") %>%
  pack_rows(unique(test$region)[2], 6, 10, label_row_css = "background-color: #5EBB9F; color: #fff;") %>%
  pack_rows(unique(test$region)[3],11, 15, label_row_css = "background-color: #E2BA56; color: #fff;")

  return(out_table)
}

ps_pair_table <- gen_pair_table(ps_table_regional_picked)
te_pair_table <- gen_pair_table(te_table_regional_picked)
ls_pair_table <- gen_pair_table(ls_table_regional_picked)
ss_pair_table <- gen_pair_table(ss_table_regional_picked)


saveRDS(M_06_ex, "./01_data/02_bibliometrix/res_area_exp_07_ngrams.Rds")
saveRDS(ps_pair_table, "./04_visualisation/04_tables/ps_pair_table.Rds")
saveRDS(te_pair_table, "./04_visualisation/04_tables/te_pair_table.Rds")
saveRDS(ls_pair_table, "./04_visualisation/04_tables/ls_pair_table.Rds")
saveRDS(ss_pair_table, "./04_visualisation/04_tables/ss_pair_table.Rds")
