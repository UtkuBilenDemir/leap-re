library(canvasXpress)
pd <- import("pandas")

require("reticulate")
M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0604_au_regions.pickle")

# Create a df for northern Africa
colnames(M_06)

gen_region_df <- function(df, region, region_colname="au_regions", id_colname="ID") {
  indexes <- unique(df[df[region_colname] == region, id_colname])
  ## out_indexes <- sapply(df[id_colname], "%in%" ,unique(indexes))
  out_indexes <- vector()
  print(indexes)
  for (i in df[id_colname]) {
    if(i %in% indexes){
      out_indexes <- c(out_indexes, i)
    }
  }

  return(out_indexes)
}


length(na_df)

na_df <- gen_region_df(M_06, "Northern Africa")
na_df
unique(M_06["au_regions"])

na_df

na_bool <- M_06$au_regions == "Northern Africa"
indexes_un <- unique(M_06[na_bool, "ID"])

na_indexes <-  vector()
for(i in M_06["ID"][,1]){
  print(i)
  if (i %in% indexes_un){
    na_indexes <- c(na_indexes, i)
  }
}

na_df <- M_06[na_indexes,]
na_df$au_regions

length(unique(M_06[na_bool,"ID"]))
length(unique(na_df[,"ID"]))
