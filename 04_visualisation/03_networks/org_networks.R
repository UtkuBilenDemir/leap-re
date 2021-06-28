library(dplyr)
library(reticulate)
library(visNetwork)
pd <- import("pandas")

source_python("./../bibliometry_module/88_supplementary_methods/gen_network_df.py")

M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0606_org_prop.pickle")


# We are still testing with Norhtern Africa
# Create a df with only Egypt collab.
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

egypt_df <- M_06[which(M_06$ID %in% egypt_indexes_un),]

egypt_df <- apply(egypt_df, 2, as.character)


saveRDS(egypt_df, "./01_data/0203_country_dfs/egypt_df.Rds")
write.csv(egypt_df, "./01_data/0203_country_dfs/egypt_df.csv")

#################### GO to network_method.py

# Load and vis
egypt.nodes <- read.csv("./04_visualisation/03_networks/egypt_nodes.csv")
egypt.edges <- read.csv("./04_visualisation/03_networks/egypt_edges.csv")

egypt.edges.rm <- egypt.edges$value < 20
egypt.edges <- egypt.edges[!egypt.edges.rm, ]

pres_nodes <- c(egypt.edges$to, egypt.edges$from)
egypt.nodes <- egypt.nodes[which(egypt.nodes$id %in% pres_nodes),]

egypt_net <- visNetwork(egypt.nodes, egypt.edges, height = "500px", width = "100%") %>% 
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

egypt_net  
  
  
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
