library(reticulate)
pd <- import("pandas")

M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0608_org_proper.pickle")

## unsd_regions <- readRDS(file = "01_data/02_bibliometrix/unsd_regions_dict.Rds")
unsd_regions <- pd$read_pickle("./01_data/0201_tables/02_country_table.pickle")
rownames(M_06) <- c()

