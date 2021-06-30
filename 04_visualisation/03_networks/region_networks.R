library(dplyr)
library(reticulate)
library(visNetwork)
pd <- import("pandas")

source_python("./../bibliometry_module/88_supplementary_methods/gen_network_df.py")

M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0608_org_proper.pickle")

M_06 <- as.data.frame(M_06)
unique(M_06$au_off_country)

length(unique(M_06$ID[M_06["au_off_country"] == "South Africa"]))
## M_06 <- readRDS("./01_data/02_bibliometrix/0607_org_oty.Rds")
# We are still testing with Norhtern Africa
# Create a df with only northern africa collab.
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

na_df <- apply(na_df,2,as.character)
wa_df <- apply(wa_df,2,as.character)
ca_df <- apply(ca_df,2,as.character)
ea_df <- apply(ea_df,2,as.character)
sa_df <- apply(sa_df,2,as.character)

write.csv(na_df, "./01_data/0202_region_dfs/na_df.csv")
write.csv(wa_df, "./01_data/0202_region_dfs/wa_df.csv")
write.csv(ca_df, "./01_data/0202_region_dfs/ca_df.csv")
write.csv(ea_df, "./01_data/0202_region_dfs/ea_df.csv")
write.csv(sa_df, "./01_data/0202_region_dfs/sa_df.csv")

saveRDS(na_df, "./01_data/0202_region_dfs/na_df.Rds")
saveRDS(wa_df, "./01_data/0202_region_dfs/wa_df.Rds")
saveRDS(ca_df, "./01_data/0202_region_dfs/ca_df.Rds")
saveRDS(ea_df, "./01_data/0202_region_dfs/ea_df.Rds")
saveRDS(sa_df, "./01_data/0202_region_dfs/sa_df.Rds")

# Make it a df for further investigation
na_df <- as.data.frame(na_df)
wa_df <- as.data.frame(wa_df)
ca_df <- as.data.frame(ca_df)
ea_df <- as.data.frame(ea_df)
sa_df <- as.data.frame(sa_df)
## table(na_df$res_domain)
## table(wa_df$res_domains)

M_06 <- apply(M_06,2,as.character)
write.csv(M_06, "./01_data/02_bibliometrix/0607_org_oty.csv")

####################
#################### GO to network_method.py

# Load and vis
na.nodes <- read.csv("./04_visualisation/03_networks/na_nodes.csv")
wa.nodes <- read.csv("./04_visualisation/03_networks/wa_nodes.csv")
ca.nodes <- read.csv("./04_visualisation/03_networks/ca_nodes.csv")
ea.nodes <- read.csv("./04_visualisation/03_networks/ea_nodes.csv")
sa.nodes <- read.csv("./04_visualisation/03_networks/sa_nodes.csv")

na.edges <- read.csv("./04_visualisation/03_networks/na_edges.csv")
wa.edges <- read.csv("./04_visualisation/03_networks/wa_edges.csv")
ca.edges <- read.csv("./04_visualisation/03_networks/ca_edges.csv")
ea.edges <- read.csv("./04_visualisation/03_networks/ea_edges.csv")
sa.edges <- read.csv("./04_visualisation/03_networks/sa_edges.csv")

na.edges.rm <- na.edges$value < 25
wa.edges.rm <- wa.edges$value < 25
ca.edges.rm <- ca.edges$value < 25
ea.edges.rm <- ea.edges$value < 25
sa.edges.rm <- sa.edges$value < 25

na.edges <- na.edges[!na.edges.rm, ]
wa.edges <- wa.edges[!wa.edges.rm, ]
ca.edges <- ca.edges[!ca.edges.rm, ]
ea.edges <- ea.edges[!ea.edges.rm, ]
sa.edges <- sa.edges[!sa.edges.rm, ]

na_res_nodes <- c(na.edges$to, na.edges$from)
wa_res_nodes <- c(wa.edges$to, wa.edges$from)
ca_res_nodes <- c(ca.edges$to, ca.edges$from)
ea_res_nodes <- c(ea.edges$to, ea.edges$from)
sa_res_nodes <- c(sa.edges$to, sa.edges$from)

na.nodes <- na.nodes[which(na.nodes$id %in% na_res_nodes),]
wa.nodes <- wa.nodes[which(wa.nodes$id %in% wa_res_nodes),]
ca.nodes <- ca.nodes[which(ca.nodes$id %in% ca_res_nodes),]
ea.nodes <- ea.nodes[which(ea.nodes$id %in% ea_res_nodes),]
sa.nodes <- sa.nodes[which(sa.nodes$id %in% sa_res_nodes),]

vis_reg_net <- function(nodes, edges, height = "1000px", width = "100%"){
  vis <- visNetwork(nodes, edges, height = height, width = width) %>%
  visOptions(highlightNearest = TRUE) %>%
  visLayout(randomSeed = 123, improvedLayout = TRUE
  ) %>%  
  ##visGroups(groupname = "Northern Africa", color = "#a6761d") %>%
  visGroups(groupname = "Northern Africa", color = "#C9A38D") %>%
  ## visGroups(groupname = "Western Africa", color = "#666666") %>%
  visGroups(groupname = "Western Africa", color = "#939393") %>%
  ##visGroups(groupname = "Central Africa", color = "#1b9e77") %>%
  visGroups(groupname = "Central Africa", color = "#5EBB9F") %>%
  ## visGroups(groupname = "Eastern Africa", color = "#7570b3") %>%
  visGroups(groupname = "Eastern Africa", color = "#B997AF") %>%
  ##visGroups(groupname = "Southern Africa", color = "#e6ab02") %>%
  visGroups(groupname = "Southern Africa", color = "#E2BA56") %>%
  visGroups(groupname = "EU-27", color = "lightblue") %>%
  ##visGroups(groupname = "EU-27", color = "#3194F7") %>%
  ##visGroups(groupname = "Other", color = "#a6d854") %>%
  visNodes(
      shape = "dot",
      color = list(
        background = "#0085AF",
        border = "#013848",
        highlight = "#FF8000"
      ),
      shadow = list(enabled = TRUE, size = 10)
  )%>% 
  #%>%   visIgraphLayout(layout = "layout_with_fr")
  visPhysics(solver = "forceAtlas2Based",forceAtlas2Based = list(gravitationalConstant = -30))
 
  return(vis)
}

na.nodes

na.nodes$font.size <- log(na.nodes$value) * 5
wa.nodes$font.size <- log(wa.nodes$value) * 5
ca.nodes$font.size <- log(ca.nodes$value) * 5
ea.nodes$font.size <- log(ea.nodes$value) * 5
sa.nodes$font.size <- log(sa.nodes$value) * 5

na_net <- vis_reg_net(na.nodes, na.edges)
wa_net <- vis_reg_net(wa.nodes, wa.edges)
ca_net <- vis_reg_net(ca.nodes, ca.edges)
ea_net <- vis_reg_net(ea.nodes, ea.edges)
sa_net <- vis_reg_net(sa.nodes, sa.edges)


## na_net <- visNetwork(na.nodes, na.edges, height = "500px", width = "100%") %>% 
##   visOptions(highlightNearest = TRUE) %>%
##   visOptions(selectedBy = "group") %>%
##   visLayout(randomSeed = 123) %>%  
##   visGroups(groupname = "Northern Africa", color ="#BF9983") %>%
##   visGroups(groupname = "EU-27", color = "lightblue") %>%
##    visNodes(
##     shape = "dot",
##     color = list(
##       background = "#0085AF",
##       border = "#013848",
##       highlight = "#FF8000"
##     ),
##     shadow = list(enabled = TRUE, size = 10)
##   )
## 
## na_net  
##   
##   
##   ## %>%
##   ## visLegend(width = 0.1, position = "right", main = "Group")
##  ## visLegend(addNodes = list(
##  ## list(label = "Northern Africa", shape = "icon", 
##  ##      icon = list(code = "dot", size = 25)),
##  ## list(label = "User", shape = "icon", 
##  ##      icon = list(code = "dot", size = 50, color = "red"))), 
##  ## useGroups = FALSE)

saveRDS(na_net, "./04_visualisation/03_networks/01_outputs/na_net.Rds")
saveRDS(wa_net, "./04_visualisation/03_networks/01_outputs/wa_net.Rds")
saveRDS(ca_net, "./04_visualisation/03_networks/01_outputs/ca_net.Rds")
saveRDS(ea_net, "./04_visualisation/03_networks/01_outputs/ea_net.Rds")
saveRDS(sa_net, "./04_visualisation/03_networks/01_outputs/sa_net.Rds")

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


visSave(na_net, "./04_visualisation/03_networks/test_net.hmtl", selfcontained = TRUE, background = "white")
