library(dplyr)
library(reticulate)
pd <- import("pandas")

source_python("./../bibliometry_module/88_supplementary_methods/gen_network_df.py")

M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0605_eu_au_regions.pickle")

# We are still testing with Norhtern Africa
# Create a df with only northern africa collab.
na_indexes_un <- unique(M_06[M_06$au_regions == "Northern Africa", "ID"])
wa_indexes_un <- unique(M_06[M_06$au_regions == "Western Africa", "ID"])

na_df <- M_06[which(M_06$ID %in% na_indexes_un),]
wa_df <- M_06[which(M_06$ID %in% wa_indexes_un),]

# only the northern african affiliations
na_df_au <- M_06[M_06$au_regions == "Northern Africa", ]
wa_df_au <- M_06[M_06$au_regions == "Western Africa", ]

na_df <- apply(na_df,2,as.character)
wa_df <- apply(wa_df,2,as.character)

write.csv(na_df, "./01_data/0202_region_dfs/na_df.csv")
write.csv(wa_df, "./01_data/0202_region_dfs/wa_df.csv")

saveRDS(na_df, "./01_data/0202_region_dfs/na_df.Rds")
saveRDS(wa_df, "./01_data/0202_region_dfs/wa_df.Rds")

# Make it a df for further investigation
na_df <- as.data.frame(na_df)
wa_df <- as.data.frame(wa_df)
table(na_df$res_domain)
table(wa_df$res_domains)


na_df
#################### GO to network_method.py

# Load and vis
na.nodes <- read.csv("./04_visualisation/03_networks/na_nodes.csv")
na.edges <- read.csv("./04_visualisation/03_networks/na_edges.csv")

class(na.edges)
na.edges.rm <- na.edges$value < 25
na.edges <- na.edges[!na.edges.rm, ]

pres_nodes <- c(na.edges$to, na.edges$from)
na.nodes <- na.nodes[which(na.nodes$id %in% pres_nodes),]

na_net <- visNetwork(na.nodes, na.edges, height = "500px", width = "100%") %>% 
  visOptions(highlightNearest = TRUE) %>%
  visOptions(selectedBy = "group") %>%
  visLayout(randomSeed = 123) %>%  
  visGroups(groupname = "Northern Africa", color ="#BF9983") %>%
  visGroups(groupname = "EU-27", color = "lightblue") %>%
   visNodes(
    shape = "dot",
    color = list(
      background = "#0085AF",
      border = "#013848",
      highlight = "#FF8000"
    ),
    shadow = list(enabled = TRUE, size = 10)
  )

na_net  
  
  
  ## %>%
  ## visLegend(width = 0.1, position = "right", main = "Group")
 ## visLegend(addNodes = list(
 ## list(label = "Northern Africa", shape = "icon", 
 ##      icon = list(code = "dot", size = 25)),
 ## list(label = "User", shape = "icon", 
 ##      icon = list(code = "dot", size = 50, color = "red"))), 
 ## useGroups = FALSE)

saveRDS(na_net, "./04_visualisation/03_networks/01_outputs/na_net.Rds")

visExport(
  na_net,
  type = "pdf",
  name = "na_net",
  label = paste0("Export as ", "pdf"),
  ##background = "#fff",
  float = "right",
  style = NULL,
  loadDependencies = TRUE,
)
