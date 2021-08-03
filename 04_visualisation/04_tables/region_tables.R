library(formattable)
library(sparkline)
library(dplyr)
library(formattable)
library(tidyr)
library(data.table)
library(htmltools)

library(reticulate)
#  Start na table
pd <- import("pandas")

#M_06 <- pd$read_pickle("/01_data/02_bibliometrix/0608_org_proper.pickle")
## M_06 <- readRDS("./01_data/02_bibliometrix/0607_org_oty.Rds")
M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0608_org_proper.pickle")

# Create a df with only region based collab.
na_indexes_un <- unique(M_06[M_06$au_regions == "Northern Africa", "ID"])
wa_indexes_un <- unique(M_06[M_06$au_regions == "Western Africa", "ID"])
ca_indexes_un <- unique(M_06[M_06$au_regions == "Central Africa", "ID"])
ea_indexes_un <- unique(M_06[M_06$au_regions == "Eastern Africa", "ID"])
sa_indexes_un <- unique(M_06[M_06$au_regions == "Southern Africa", "ID"])

na_df <- M_06[which(M_06$ID %in% na_indexes_un),]
wa_df <- M_06[which(M_06$ID %in% wa_indexes_un),]
ca_df <- M_06[which(M_06$ID %in% ca_indexes_un),]
ea_df <- M_06[which(M_06$ID %in% ea_indexes_un),]
sa_df <- M_06[which(M_06$ID %in% sa_indexes_un),]

# only the northern african affiliations
na_df_au <- M_06[M_06$au_regions == "Northern Africa", ]
wa_df_au <- M_06[M_06$au_regions == "Western Africa", ]
ca_df_au <- M_06[M_06$au_regions == "Central Africa", ]
ea_df_au <- M_06[M_06$au_regions == "Eastern Africa", ]
sa_df_au <- M_06[M_06$au_regions == "Southern Africa", ]

# Create a country table
na_countries <- unique(na_df_au$au_off_country)
wa_countries <- unique(wa_df_au$au_off_country)
ca_countries <- unique(ca_df_au$au_off_country)
ea_countries <- unique(ea_df_au$au_off_country)
sa_countries <- unique(sa_df_au$au_off_country)

na_country_df <-  data.frame()
wa_country_df <-  data.frame()
ca_country_df <-  data.frame()
ea_country_df <-  data.frame()
sa_country_df <-  data.frame()

gen_region_df <- function(reg_cou, df=M_06, c_num=97) {
  out_df <-  data.frame()
  for (i in seq_along(reg_cou)){
    cou_row <- df[df$au_off_country == reg_cou[i],][1,]
    cou_row[, c_num] <- round(cou_row[, c_num], digits=2)
    out_df <- rbind(out_df, cou_row[, c(101, 87:96, 86, 97)])
  }
  return (out_df)
}

na_country_df <- gen_region_df(na_countries)
wa_country_df <- gen_region_df(wa_countries)
ca_country_df <- gen_region_df(ca_countries)
ea_country_df <- gen_region_df(ea_countries)
sa_country_df <- gen_region_df(sa_countries)


## for (i in seq_along(na_countries)) {
##     cou_row <- M_06[M_06$au_off_country == na_countries[i],][1,]
##     cou_row[, 97] <- round(cou_row[, 97], digits=2) 
##     na_country_df <- rbind(na_country_df, cou_row[, c(101, 87:96, 86, 97)])
## }
na_country_df <- na_country_df[order(na_country_df$cou_tot_pub, decreasing = TRUE),]
wa_country_df <- wa_country_df[order(wa_country_df$cou_tot_pub, decreasing = TRUE),]
ca_country_df <- ca_country_df[order(ca_country_df$cou_tot_pub, decreasing = TRUE),]
ea_country_df <- ea_country_df[order(ea_country_df$cou_tot_pub, decreasing = TRUE),]
sa_country_df <- sa_country_df[order(sa_country_df$cou_tot_pub, decreasing = TRUE),]

rownames(na_country_df) <- seq_along(rownames(na_country_df))
rownames(wa_country_df) <- seq_along(rownames(wa_country_df))
rownames(ca_country_df) <- seq_along(rownames(ca_country_df))
rownames(ea_country_df) <- seq_along(rownames(ea_country_df))
rownames(sa_country_df) <- seq_along(rownames(sa_country_df))


# Now the formatttable trans.
na_country_df$`pub_2012` = apply(na_country_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
wa_country_df$`pub_2012` = apply(wa_country_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
ca_country_df$`pub_2012` = apply(ca_country_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
ea_country_df$`pub_2012` = apply(ea_country_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
sa_country_df$`pub_2012` = apply(sa_country_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))

na_country_df <- na_country_df[1:5 ,c(1:3, 11, 13, 12)]
wa_country_df <- wa_country_df[1:5,c(1:3, 11, 13, 12)]
ca_country_df <- ca_country_df[1:5,c(1:3, 11, 13, 12)]
ea_country_df <- ea_country_df[1:5,c(1:3, 11, 13, 12)]
sa_country_df <- sa_country_df[1:5,c(1:3, 11, 13, 12)]

colnames(na_country_df) <- c("Country", "2011","    ","2020","Rel. growth rate (2011-2020)", "Total num. of pub. (2011-2020)")
colnames(wa_country_df) <- c("Country", "2011","    ","2020","Rel. growth rate (2011-2020)", "Total num. of pub. (2011-2020)")
colnames(ca_country_df) <- c("Country", "2011","    ","2020","Rel. growth rate (2011-2020)", "Total num. of pub. (2011-2020)")
colnames(ea_country_df) <- c("Country", "2011","    ","2020","Rel. growth rate (2011-2020)", "Total num. of pub. (2011-2020)")
colnames(sa_country_df) <- c("Country", "2011","    ","2020","Rel. growth rate (2011-2020)", "Total num. of pub. (2011-2020)")

bg = function(start, end, color, ...) {
  paste("linear-gradient(90deg,transparent ",percent(start),",",
        color, percent(start), ",", color, percent(end),
        ", transparent", percent(end),")")
} 
color_bar2 <-  function (color = "lightgray", fun = "proportion", ...) {
    fun <- match.fun(fun)
    formatter("span", style = function(x) style(display = "inline-block",
                `unicode-bidi` = "plaintext", 
                "background" = bg(1-fun(as.numeric(x), ...), 1, color), "width"="100%" ))
}
gen_formattable <- function(df){
    out <- as.htmlwidget(formattable(df,
      align = c("l",rep("r", NCOL(na_country_df) - 1)), 
      list(`Country` = formatter("span", style = ~ style(color = "grey", font.weight = "bold")),
      ##`Rel. growth rate (2011-2020)` = color_tile("#DeF7E9", "#71CA97")
      `Rel. growth rate (2011-2020)` = color_tile("#f5f5f5", "lightpink"),
      `Total num. of pub. (2011-2020)` = color_bar2("lightblue")
      )))
    out$dependencies <- c(out$dependencies, htmlwidgets:::widget_dependencies("sparkline", "sparkline"))

  return( out)                                    
}

na_table <- gen_formattable(na_country_df)
wa_table <- gen_formattable(wa_country_df)
ca_table <- gen_formattable(ca_country_df)
ea_table <- gen_formattable(ea_country_df)
sa_table <- gen_formattable(sa_country_df)

## out <- as.htmlwidget(formattable(na_country_df,
##   align = c("l",rep("r", NCOL(na_country_df) - 1)), 
##   list(`Country` = formatter("span", style = ~ style(color = "grey", font.weight = "bold")),
##     `Rel. growth rate (2011-2020)` = color_tile("#DeF7E9", "#71CA97")
##   )                                    
## ))
## 
## 
## out$dependencies = c(out$dependencies, htmlwidgets:::widget_dependencies("sparkline", "sparkline"))
## out

saveRDS(na_table, "./04_visualisation/04_tables/na_table.Rds")
saveRDS(wa_table, "./04_visualisation/04_tables/wa_table.Rds")
saveRDS(ca_table, "./04_visualisation/04_tables/ca_table.Rds")
saveRDS(ea_table, "./04_visualisation/04_tables/ea_table.Rds")
saveRDS(sa_table, "./04_visualisation/04_tables/sa_table.Rds")
