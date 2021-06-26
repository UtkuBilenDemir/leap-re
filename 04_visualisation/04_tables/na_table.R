library(formattable)
library(sparkline)
library(dplyr)
library(formattable)
library(tidyr)
library(data.table)
library(htmltools)

#  Start na table
pd <- import("pandas")

require("reticulate")
M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0604_au_regions.pickle")

# Create a df with only northern africa collab.
na_indexes_un <- unique(M_06[M_06$au_regions == "Northern Africa", "ID"])
na_df <- M_06[which(M_06$ID %in% na_indexes_un),]

# only the northern african affiliations
na_df_au <- M_06[M_06$au_regions == "Northern Africa", ]

# Create a country table
na_countries <- unique(na_df_au$au_off_country)
na_country_df <-  data.frame()
for (i in seq_along(na_countries)) {
    cou_row <- M_06[M_06$au_off_country == na_countries[i],][1,]
    cou_row[, 97] <- round(cou_row[, 97], digits=2) 
    na_country_df <- rbind(na_country_df, cou_row[, c(101, 87:96, 86, 97)])
}
na_country_df <- na_country_df[order(na_country_df$cou_tot_pub, decreasing = TRUE),]
rownames(na_country_df) <- seq_along(rownames(na_country_df))


# Now the formatttable trans.
na_country_df$`pub_2012` = apply(na_country_df[, 2:11], 1, FUN = function(x) as.character(htmltools::as.tags(sparkline(as.numeric(x), type = "line"))))
na_country_df <- na_country_df[,c(1:3, 11, 13, 12)]

colnames(na_country_df) <- c("Country", 
                            "2011",
                            "2011-2020",
                            "2020",
                            "Rel. growth rate (2011-2020)",
                            "Total num. of pub. (2011-2020)"
)

out <- as.htmlwidget(formattable(na_country_df,
  align = c("l",rep("r", NCOL(na_country_df) - 1)), 
  list(`Country` = formatter("span", style = ~ style(color = "grey", font.weight = "bold")),
    `Rel. growth rate (2011-2020)` = color_tile("#DeF7E9", "#71CA97")
  )                                    
))


out$dependencies = c(out$dependencies, htmlwidgets:::widget_dependencies("sparkline", "sparkline"))
out

saveRDS(out, "./04_visualisation/04_tables/table_test.Rds")
