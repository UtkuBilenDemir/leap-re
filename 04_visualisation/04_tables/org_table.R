library(formattable)
library(sparkline)
library(dplyr)
library(formattable)
library(tidyr)
library(data.table)
library(htmltools)
library(reticulate)

pd <- import("pandas")



## M_06 <- readRDS(M_06_ex, file = "./01_data/02_bibliometrix/0607_org_oty.Rds")

M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0608_org_proper.pickle")

M_06$au_off_country[1]

# French organisations are entered as African
cirad_df <- M_06[M_06$org_prop == "CIRAD", ]
unique(cirad_df$au_off_country)
length(unique(cirad_df$ID[("Senegal" == cirad_df$au_off_country)]))
length(unique(M_06[M_06[M_06$org_prop == "CSIR",]$au_off_country == "Ghana", "ID"] ))
length(unique(M_06[M_06$org_prop=="CSIR" & "" %in% M_06$au_off_country,  "ID"]))
length(unique(M_06[M_06$org_prop=="World Agroforestry Centre" & "Kenya" %in% M_06$au_off_country,  "ID"]))

# Create a df with only country collab.
      egypt_indexes_un <- unique(M_06[M_06$au_off_country == "Egypt", "ID"])
    morocco_indexes_un <- unique(M_06[M_06$au_off_country == "Morocco", "ID"])
    algeria_indexes_un <- unique(M_06[M_06$au_off_country == "Algeria", "ID"])
    nigeria_indexes_un <- unique(M_06[M_06$au_off_country == "Nigeria", "ID"])
      ghana_indexes_un <- unique(M_06[M_06$au_off_country == "Ghana", "ID"])
    senegal_indexes_un <- unique(M_06[M_06$au_off_country == "Senegal", "ID"])
   cameroon_indexes_un <- unique(M_06[M_06$au_off_country == "Cameroon", "ID"])
demrepcongo_indexes_un <- unique(M_06[M_06$au_off_country == "Dem. Rep. Congo", "ID"])
   ethiopia_indexes_un <- unique(M_06[M_06$au_off_country == "Ethiopia", "ID"])
      kenya_indexes_un <- unique(M_06[M_06$au_off_country == "Kenya", "ID"])
   tanzania_indexes_un <- unique(M_06[M_06$au_off_country == "Tanzania", "ID"])
         sa_indexes_un <- unique(M_06[M_06$au_off_country == "South Africa", "ID"])
   zimbabwe_indexes_un <- unique(M_06[M_06$au_off_country == "Zimbabwe",  "ID"])
 sen_gha_ni_indexes_un <- unique(M_06[M_06$au_off_country %in% c("Senegal", "Ghana", "Nigeria"), "ID"])
eth_ken_tan_indexes_un <- unique(M_06[M_06$au_off_country %in% c("Ethiopia", "Kenya", "Tanzania"), "ID"])
con_cam_gab_indexes_un <- unique(M_06[M_06$au_off_country %in% c("Dem. Rep. Congo", "Cameroon", "Gabon"), "ID"])

      egypt_df <- M_06[which(M_06$ID %in%       egypt_indexes_un),]
    morocco_df <- M_06[which(M_06$ID %in%     morocco_indexes_un),]
    algeria_df <- M_06[which(M_06$ID %in%     algeria_indexes_un),]
    nigeria_df <- M_06[which(M_06$ID %in%     nigeria_indexes_un),]
      ghana_df <- M_06[which(M_06$ID %in%       ghana_indexes_un),]
    senegal_df <- M_06[which(M_06$ID %in%     senegal_indexes_un),]
   cameroon_df <- M_06[which(M_06$ID %in%    cameroon_indexes_un),]
demrepcongo_df <- M_06[which(M_06$ID %in% demrepcongo_indexes_un),]
   ethiopia_df <- M_06[which(M_06$ID %in%    ethiopia_indexes_un),]
      kenya_df <- M_06[which(M_06$ID %in%       kenya_indexes_un),]
   tanzania_df <- M_06[which(M_06$ID %in%    tanzania_indexes_un),]
         sa_df <- M_06[which(M_06$ID %in%          sa_indexes_un),]
   zimbabwe_df <- M_06[which(M_06$ID %in%    zimbabwe_indexes_un),]
 sen_gha_ni_df <- M_06[which(M_06$ID %in%  sen_gha_ni_indexes_un),]
eth_ken_tan_df <- M_06[which(M_06$ID %in% eth_ken_tan_indexes_un),]
con_cam_gab_df <- M_06[which(M_06$ID %in% con_cam_gab_indexes_un),]


# only the country affiliations
      egypt_df_au <- M_06[M_06$au_off_country == "Egypt", ]
    morocco_df_au <- M_06[M_06$au_off_country == "Morocco", ]
    algeria_df_au <- M_06[M_06$au_off_country == "Algeria", ]
    nigeria_df_au <- M_06[M_06$au_off_country == "Nigeria", ]
      ghana_df_au <- M_06[M_06$au_off_country == "Ghana", ]
    senegal_df_au <- M_06[M_06$au_off_country == "Senegal", ]
   cameroon_df_au <- M_06[M_06$au_off_country == "Cameroon", ]
demrepcongo_df_au <- M_06[M_06$au_off_country == "Dem. Rep. Congo", ]
   ethiopia_df_au <- M_06[M_06$au_off_country == "Ethiopia", ]
      kenya_df_au <- M_06[M_06$au_off_country == "Kenya", ]
   tanzania_df_au <- M_06[M_06$au_off_country == "Tanzania", ]
         sa_df_au <- M_06[M_06$au_off_country == "South Africa", ]
   zimbabwe_df_au <- M_06[M_06$au_off_country == "Zimbabwe", ]
 sen_gha_ni_df_au <- M_06[M_06$au_off_country %in% c("Senegal", "Ghana", "Nigeria"), ]
eth_ken_tan_df_au <- M_06[M_06$au_off_country %in% c("Ethiopia", "Kenya", "Tanzania"), ]
con_cam_gab_df_au <- M_06[M_06$au_off_country %in% c("Dem. Rep. Congo", "Cameroon", "Gabon"), ]

# Create a country table
      egypt_orgs <- unlist(unique(      egypt_df_au$org_prop))
    morocco_orgs <- unlist(unique(    morocco_df_au$org_prop))
    algeria_orgs <- unlist(unique(    algeria_df_au$org_prop))
    nigeria_orgs <- unlist(unique(    nigeria_df_au$org_prop))
      ghana_orgs <- unlist(unique(      ghana_df_au$org_prop))
    senegal_orgs <- unlist(unique(    senegal_df_au$org_prop))
   cameroon_orgs <- unlist(unique(   cameroon_df_au$org_prop))
demrepcongo_orgs <- unlist(unique(demrepcongo_df_au$org_prop))
   ethiopia_orgs <- unlist(unique(   ethiopia_df_au$org_prop))
      kenya_orgs <- unlist(unique(      kenya_df_au$org_prop))
   tanzania_orgs <- unlist(unique(   tanzania_df_au$org_prop))
         sa_orgs <- unlist(unique(         sa_df_au$org_prop))
   zimbabwe_orgs <- unlist(unique(   zimbabwe_df_au$org_prop))
 sen_gha_ni_orgs <- unlist(unique( sen_gha_ni_df_au$org_prop))
eth_ken_tan_orgs <- unlist(unique(eth_ken_tan_df_au$org_prop))
con_cam_gab_orgs <- unlist(unique(con_cam_gab_df_au$org_prop))


gen_org_table <- function(org_list) {
  out_org_df <- data.frame()
  for (i in seq_along(org_list)) {
    org_row <- M_06[M_06$org_prop == org_list[i], ][1,]
        org_row[, "org_relative"] <- round(org_row[, "org_relative"], digits=2) 
        out_org_df <- rbind(out_org_df, org_row[, c("org_prop", 
                                                        "org_pub_2011" , 
                                                        "org_pub_2012" , 
                                                        "org_pub_2013" , 
                                                        "org_pub_2014" , 
                                                        "org_pub_2015" , 
                                                        "org_pub_2016" , 
                                                        "org_pub_2017" , 
                                                        "org_pub_2018" , 
                                                        "org_pub_2019" , 
                                                        "org_pub_2020" , 
                                                        "org_relative", 
                                                        "org_freq_prop")])
  }
  return(out_org_df)
}

      egypt_org_df <-  gen_org_table(      egypt_orgs)
    morocco_org_df <-  gen_org_table(    morocco_orgs)
    algeria_org_df <-  gen_org_table(    algeria_orgs)
    nigeria_org_df <-  gen_org_table(    nigeria_orgs)
      ghana_org_df <-  gen_org_table(      ghana_orgs)
    senegal_org_df <-  gen_org_table(    senegal_orgs)
   cameroon_org_df <-  gen_org_table(   cameroon_orgs)
demrepcongo_org_df <-  gen_org_table(demrepcongo_orgs)
   ethiopia_org_df <-  gen_org_table(   ethiopia_orgs)
      kenya_org_df <-  gen_org_table(      kenya_orgs)
   tanzania_org_df <-  gen_org_table(   tanzania_orgs)
         sa_org_df <-  gen_org_table(         sa_orgs)
   zimbabwe_org_df <-  gen_org_table(   zimbabwe_orgs)
 sen_gha_ni_org_df <-  gen_org_table( sen_gha_ni_orgs)

eth_ken_tan_org_df <-  gen_org_table(eth_ken_tan_orgs)
con_cam_gab_org_df <-  gen_org_table(con_cam_gab_orgs)

## for (i in seq_along(egypt_orgs)) {
##     org_row <- M_06[M_06$org_prop == egypt_orgs[i],][1,]
##     org_row[, "org_relative"] <- round(org_row[, "org_relative"], digits=2) 
##     egypt_org_df <- rbind(egypt_org_df, org_row[, c("org_prop", 
##                                                     "org_pub_2011" , 
##                                                     "org_pub_2012" , 
##                                                     "org_pub_2013" , 
##                                                     "org_pub_2014" , 
##                                                     "org_pub_2015" , 
##                                                     "org_pub_2016" , 
##                                                     "org_pub_2017" , 
##                                                     "org_pub_2018" , 
##                                                     "org_pub_2019" , 
##                                                     "org_pub_2020" , 
##                                                     "org_relative", 
##                                                     "org_freq_prop")])
## }
      egypt_org_df <-       egypt_org_df[order(as.numeric(      egypt_org_df$org_freq_prop), decreasing = TRUE),]
    morocco_org_df <-     morocco_org_df[order(as.numeric(    morocco_org_df$org_freq_prop), decreasing = TRUE),]
    algeria_org_df <-     algeria_org_df[order(as.numeric(    algeria_org_df$org_freq_prop), decreasing = TRUE),]
    nigeria_org_df <-     nigeria_org_df[order(as.numeric(    nigeria_org_df$org_freq_prop), decreasing = TRUE),]
      ghana_org_df <-       ghana_org_df[order(as.numeric(      ghana_org_df$org_freq_prop), decreasing = TRUE),]
    senegal_org_df <-     senegal_org_df[order(as.numeric(    senegal_org_df$org_freq_prop), decreasing = TRUE),]
   cameroon_org_df <-    cameroon_org_df[order(as.numeric(   cameroon_org_df$org_freq_prop), decreasing = TRUE),]
demrepcongo_org_df <- demrepcongo_org_df[order(as.numeric(demrepcongo_org_df$org_freq_prop), decreasing = TRUE),]
   ethiopia_org_df <-    ethiopia_org_df[order(as.numeric(   ethiopia_org_df$org_freq_prop), decreasing = TRUE),]
      kenya_org_df <-       kenya_org_df[order(as.numeric(      kenya_org_df$org_freq_prop), decreasing = TRUE),]
   tanzania_org_df <-    tanzania_org_df[order(as.numeric(   tanzania_org_df$org_freq_prop), decreasing = TRUE),]
         sa_org_df <-          sa_org_df[order(as.numeric(         sa_org_df$org_freq_prop), decreasing = TRUE),]
   zimbabwe_org_df <-    zimbabwe_org_df[order(as.numeric(   zimbabwe_org_df$org_freq_prop), decreasing = TRUE),]
 sen_gha_ni_org_df <-  sen_gha_ni_org_df[order(as.numeric( sen_gha_ni_org_df$org_freq_prop), decreasing = TRUE),]
eth_ken_tan_org_df <- eth_ken_tan_org_df[order(as.numeric(eth_ken_tan_org_df$org_freq_prop), decreasing = TRUE),]
con_cam_gab_org_df <- con_cam_gab_org_df[order(as.numeric(con_cam_gab_org_df$org_freq_prop), decreasing = TRUE),]

# Remove internationals
sen_to_rm <- c("CIRAD", "North-West University", "CSIR" )
eth_to_rm <- c("University of Nigeria")
con_to_rm <- c("CIRAD", "World Agroforestry Centre", "International Institute of Tropical Agriculture (IITA)" , "Centre of Biotechnology of Sfax")

sen_to_rm_indexes <- which(sen_gha_ni_org_df$org_prop %in% sen_to_rm)
eth_to_rm_indexes <- which(eth_ken_tan_org_df$org_prop %in% eth_to_rm)
con_to_rm_indexes <- which(con_cam_gab_org_df$org_prop %in% con_to_rm)

sen_gha_ni_org_df <- sen_gha_ni_org_df[-c(sen_to_rm_indexes), ][1:5,]
eth_ken_tan_org_df <- eth_ken_tan_org_df[-c(eth_to_rm_indexes), ][1:5,]
con_cam_gab_org_df <- con_cam_gab_org_df[-c(con_to_rm_indexes), ][1:5,]

rownames(      egypt_org_df) <- seq_along(rownames(      egypt_org_df))
rownames(    morocco_org_df) <- seq_along(rownames(    morocco_org_df))
rownames(    algeria_org_df) <- seq_along(rownames(    algeria_org_df))
rownames(    nigeria_org_df) <- seq_along(rownames(    nigeria_org_df))
rownames(      ghana_org_df) <- seq_along(rownames(      ghana_org_df))
rownames(    senegal_org_df) <- seq_along(rownames(    senegal_org_df))
rownames(   cameroon_org_df) <- seq_along(rownames(   cameroon_org_df))
rownames(demrepcongo_org_df) <- seq_along(rownames(demrepcongo_org_df))
rownames(   ethiopia_org_df) <- seq_along(rownames(   ethiopia_org_df))
rownames(      kenya_org_df) <- seq_along(rownames(      kenya_org_df))
rownames(   tanzania_org_df) <- seq_along(rownames(   tanzania_org_df))
rownames(         sa_org_df) <- seq_along(rownames(         sa_org_df))
rownames(   zimbabwe_org_df) <- seq_along(rownames(   zimbabwe_org_df))
rownames( sen_gha_ni_org_df) <- seq_along(rownames( sen_gha_ni_org_df))
rownames(eth_ken_tan_org_df) <- seq_along(rownames(eth_ken_tan_org_df))
rownames(con_cam_gab_org_df) <- seq_along(rownames(con_cam_gab_org_df))


# Now the formatttable trans.
      egypt_org_df$`pub_2012` = apply(      egypt_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
    morocco_org_df$`pub_2012` = apply(    morocco_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
    algeria_org_df$`pub_2012` = apply(    algeria_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
    nigeria_org_df$`pub_2012` = apply(    nigeria_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
      ghana_org_df$`pub_2012` = apply(      ghana_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
    senegal_org_df$`pub_2012` = apply(    senegal_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
   cameroon_org_df$`pub_2012` = apply(   cameroon_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
demrepcongo_org_df$`pub_2012` = apply(demrepcongo_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
   ethiopia_org_df$`pub_2012` = apply(   ethiopia_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
      kenya_org_df$`pub_2012` = apply(      kenya_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
   tanzania_org_df$`pub_2012` = apply(   tanzania_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
         sa_org_df$`pub_2012` = apply(         sa_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
   zimbabwe_org_df$`pub_2012` = apply(   zimbabwe_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
 sen_gha_ni_org_df$`pub_2012` = apply( sen_gha_ni_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
eth_ken_tan_org_df$`pub_2012` = apply(eth_ken_tan_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
con_cam_gab_org_df$`pub_2012` = apply(con_cam_gab_org_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))

## sen_gha_ni_org_df <-sen_gha_ni_org_df[1:5,]
## sen_gha_ni_df$Country <- c("Nigeria", "Nigeria", "Nigeria", "Ghana", "Ghana")


      egypt_org_df <-       egypt_org_df[,c(1:2, 14, 11,12, 13)]
    morocco_org_df <-     morocco_org_df[,c(1:2, 14, 11,12, 13)]
    algeria_org_df <-     algeria_org_df[,c(1:2, 14, 11,12, 13)]
    nigeria_org_df <-     nigeria_org_df[,c(1:2, 14, 11,12, 13)]
      ghana_org_df <-       ghana_org_df[,c(1:2, 14, 11,12, 13)]
    senegal_org_df <-     senegal_org_df[,c(1:2, 14, 11,12, 13)]
   cameroon_org_df <-    cameroon_org_df[,c(1:2, 14, 11,12, 13)]
demrepcongo_org_df <- demrepcongo_org_df[,c(1:2, 14, 11,12, 13)]
   ethiopia_org_df <-    ethiopia_org_df[,c(1:2, 14, 11,12, 13)]
      kenya_org_df <-       kenya_org_df[,c(1:2, 14, 11,12, 13)]
   tanzania_org_df <-    tanzania_org_df[,c(1:2, 14, 11,12, 13)]
         sa_org_df <-          sa_org_df[,c(1:2, 14, 11,12, 13)]
   zimbabwe_org_df <-    zimbabwe_org_df[,c(1:2, 14, 11,12, 13)]
 sen_gha_ni_org_df <-  sen_gha_ni_org_df[,c(1:2, 14, 11,12, 13)]
eth_ken_tan_org_df <- eth_ken_tan_org_df[,c(1:2, 14, 11,12, 13)]
con_cam_gab_org_df <- con_cam_gab_org_df[,c(1:2, 14, 11,12, 13)]

colnames(      egypt_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames(    morocco_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames(    algeria_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames(    nigeria_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames(      ghana_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames(    senegal_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames(   cameroon_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames(demrepcongo_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames(   ethiopia_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames(      kenya_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames(   tanzania_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames(         sa_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames(   zimbabwe_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames( sen_gha_ni_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames(eth_ken_tan_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")
colnames(con_cam_gab_org_df) <- c("Organisation", "2011","    ","2020","Rel. growth rate (2011-2020)","Total num. of pub. (2011-2020)")

gen_org_ftable <- function(df) {
  out_table <- as.htmlwidget(formattable(df[1:5,],
    align = c("l",rep("r", NCOL(df) - 1)), 
    list(`Organisation` = formatter("span", style = ~ style(color = "grey", font.weight = "bold")),
    `Rel. growth rate (2011-2020)` = color_tile("#f5f5f5", "lightpink"),
    `Total num. of pub. (2011-2020)` = color_bar2("lightblue")
  )))

   out_table$dependencies = c(out_table$dependencies, htmlwidgets:::widget_dependencies("sparkline", "sparkline"))
   return(out_table)
 }

bg <- function(start, end, color, ...) {
  paste("linear-gradient(90deg,transparent ",percent(start),",",
        color, percent(start), ",", color, percent(end),
        ", transparent", percent(end),")")
}
color_bar2 <-  function (color = "lightgray", fun = "proportion", ...) {
    fun <- match.fun(fun)
    formatter("span", style = function(x) formattable::style(display = "inline-block",
                `unicode-bidi` = "plaintext", 
                "background" = bg(1-fun(as.numeric(x), ...), 1, color), "width"="100%" ))
}

saveRDS(bg, "../bibliometry_module/88_supplementary_methods/formattable_color_grader.Rds")
saveRDS(color_bar2, "../bibliometry_module/88_supplementary_methods/formattable_better_color_bar.Rds")


      egypt_out <- gen_org_ftable(      egypt_org_df)
    morocco_out <- gen_org_ftable(    morocco_org_df)
    algeria_out <- gen_org_ftable(    algeria_org_df)
    nigeria_out <- gen_org_ftable(    nigeria_org_df)
      ghana_out <- gen_org_ftable(      ghana_org_df)
    senegal_out <- gen_org_ftable(    senegal_org_df)
   cameroon_out <- gen_org_ftable(   cameroon_org_df)
demrepcongo_out <- gen_org_ftable(demrepcongo_org_df)
   ethiopia_out <- gen_org_ftable(   ethiopia_org_df)
      kenya_out <- gen_org_ftable(      kenya_org_df)
   tanzania_out <- gen_org_ftable(   tanzania_org_df)
         sa_out <- gen_org_ftable(         sa_org_df)
   zimbabwe_out <- gen_org_ftable(   zimbabwe_org_df)


sen_gha_ni_org_df <- sen_gha_ni_org_df[1:5,]
sen_gha_ni_org_df$Country <- c("Nigeria", "Nigeria", "Nigeria", "Ghana", "Ghana")
 sen_gha_ni_out <- gen_org_ftable( sen_gha_ni_org_df)

eth_ken_tan_org_df <- eth_ken_tan_org_df[1:5,]
eth_ken_tan_org_df$Country <- c("Ethiopia", "Kenya", "Ethiopia", "Tanzania", "Kenya")
eth_ken_tan_out <- gen_org_ftable(eth_ken_tan_org_df)

con_cam_gab_org_df <- con_cam_gab_org_df[1:5,]
con_cam_gab_org_df$Country <- c("Cameroon", "Cameroon", "Cameroon", "Cameroon", "Cameroon")
con_cam_gab_out <- gen_org_ftable(con_cam_gab_org_df)


saveRDS(egypt_out, "./04_visualisation/04_tables/egypt_org_table.Rds")
saveRDS(morocco_out, "./04_visualisation/04_tables/morocco_org_table.Rds")
saveRDS(algeria_out, "./04_visualisation/04_tables/algeria_org_table.Rds")
saveRDS(sen_gha_ni_out, "./04_visualisation/04_tables/sen_gha_ni_org_table.Rds")
saveRDS(eth_ken_tan_out, "./04_visualisation/04_tables/eth_ken_tan_org_table.Rds")
saveRDS(con_cam_gab_out, "./04_visualisation/04_tables/con_cam_gab_org_table.Rds")
saveRDS(sa_out, "./04_visualisation/04_tables/sa_org_table.Rds")
