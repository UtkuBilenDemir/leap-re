library(bibliometrix)

file <- "01_data/01_raw_data/wos_02/wos_all2.txt"
M <- convert2df(file, dbsource = "wos", format = "plaintext")
head(M["TC"])


# General analysis results of bibliometrix
results <- biblioAnalysis(M, sep = ";")
# Save bibliometrix results for further exploration
saveRDS(results, file = "02_preprocessing/bib_results.Rds")

# Create IDs for each publication 
M_id <- cbind("ID" = 1:nrow(M), M)
# Save a single object with following (This is the most comprehensive df)
saveRDS(M_id, file = "01_data/02_bibliometrix/01_bib_dataframe.Rds")
## data.copy <- readRDS(file = "data.Rds")
# Save also a cvs
write.table(M_id, file = "01_data/02_bibliometrix/01_bib_dataframe.csv",
            sep = "\t", row.names = F)



# Create a df without the abstracts (severely slowing the processes down)
M_noAB <- M_id[colnames(M_id) != "AB"]

# Save a single object without abstracts
saveRDS(M_noAB, file = "01_data/02_bibliometrix/02_bib_dataframe_noab.Rds")
## data.copy <- readRDS(file = "data.Rds")
# Save also a cvs
write.table(M_noAB, file = "01_data/02_bibliometrix/02_bib_dataframe_noab.csv", sep="|", row.names = F)
