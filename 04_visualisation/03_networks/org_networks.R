library(dplyr)
library(reticulate)
library(visNetwork)
pd <- import("pandas")

source_python("./../bibliometry_module/88_supplementary_methods/gen_network_df.py")

M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0608_org_proper.pickle")
## M_06 <- readRDS("./01_data/02_bibliometrix/0607_org_oty.Rds")

r = 0
for (i in seq_along(unique(M_06$ID))) {
   indexes <- M_06$ID == unique(M_06$ID)[i]
   print(r)
   if ((any( M_06[indexes, "org_prop" ] == "Covenant University") ==TRUE & any( M_06[indexes, "org_prop" ] == "University of Ibadan")==TRUE)) {
   r <- r+1
   }
}
check <- c("Covenant University", "University of Ibadan")
r

# We are still testing with Norhtern Africa
# Create a df with only Egypt collab.
      egypt_indexes_un <- unique(M_06[M_06$au_off_country == "Egypt", "ID"])
    morocco_indexes_un <- unique(M_06[M_06$au_off_country == "Morocco", "ID"])
    algeria_indexes_un <- unique(M_06[M_06$au_off_country == "Algeria", "ID"])
 eg_mor_alg_indexes_un <- unique(M_06[M_06$au_off_country %in% c("Algeria", "Egypt", "Algeria"), "ID"])
    nigeria_indexes_un <- unique(M_06[M_06$au_off_country == "Nigeria", "ID"])
      ghana_indexes_un <- unique(M_06[M_06$au_off_country == "Ghana", "ID"])
    senegal_indexes_un <- unique(M_06[M_06$au_off_country == "Senegal", "ID"])
   cameroon_indexes_un <- unique(M_06[M_06$au_off_country == "Cameroon", "ID"])
demrepcongo_indexes_un <- unique(M_06[M_06$au_off_country == "Dem. Rep. Congo", "ID"])
   ethiopia_indexes_un <- unique(M_06[M_06$au_off_country == "Ethiopia", "ID"])
      kenya_indexes_un <- unique(M_06[M_06$au_off_country == "Kenya", "ID"])
   tanzania_indexes_un <- unique(M_06[M_06$au_off_country == "Tanzania", "ID"])
         sa_indexes_un <- unique(M_06[M_06$au_off_country == "South Africa", "ID"])
   zimbabwe_indexes_un <- unique(M_06[M_06$au_off_country == "Zimbabwe", "ID"])
 sen_gha_ni_indexes_un <- unique(M_06[M_06$au_off_country %in% c("Senegal", "Ghana", "Nigeria") , "ID"])
eth_ken_tan_indexes_un <- unique(M_06[M_06$au_off_country %in% c("Ethiopia", "Kenya", "Tanzania"), "ID"])
con_cam_gab_indexes_un <- unique(M_06[M_06$au_off_country %in% c("Dem. Rep. Congo", "Cameroon", "Gabon"), "ID"])
west_east_central_indexes_un <- unique(M_06[M_06$au_off_country %in% c("Dem. Rep. Congo", "Cameroon", "Gabon", "Ethiopia", "Kenya", "Tanzania", "Senegal", "Ghana", "Nigeria"), "ID"])



      egypt_df <- M_06[which(M_06$ID %in%       egypt_indexes_un),]
    morocco_df <- M_06[which(M_06$ID %in%     morocco_indexes_un),]
    algeria_df <- M_06[which(M_06$ID %in%     algeria_indexes_un),]
 eg_mor_alg_df <- M_06[which(M_06$ID %in%     eg_mor_alg_indexes_un),]
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
 sen_gha_ni_df <- M_06[which(M_06$ID %in%     sen_gha_ni_indexes_un),]
eth_ken_tan_df <- M_06[which(M_06$ID %in%     eth_ken_tan_indexes_un),]
con_cam_gab_df <- M_06[which(M_06$ID %in%     con_cam_gab_indexes_un),]
west_east_central_df <- M_06[which(M_06$ID %in%     west_east_central_indexes_un),]
    
      egypt_df <- apply(      egypt_df, 2, as.character)
    morocco_df <- apply(    morocco_df, 2, as.character)
    algeria_df <- apply(    algeria_df, 2, as.character)
 eg_mor_alg_df <- apply( eg_mor_alg_df, 2, as.character)
    nigeria_df <- apply(    nigeria_df, 2, as.character)
      ghana_df <- apply(      ghana_df, 2, as.character)
    senegal_df <- apply(    senegal_df, 2, as.character)
 sen_gha_ni_df <- apply(    sen_gha_ni_df, 2, as.character)
eth_ken_tan_df <- apply(    eth_ken_tan_df, 2, as.character)
con_cam_gab_df <- apply(    con_cam_gab_df, 2, as.character)
west_east_central_df <- apply(    west_east_central_df, 2, as.character)



   cameroon_df <- apply(   cameroon_df, 2, as.character)
demrepcongo_df <- apply(demrepcongo_df, 2, as.character)
   ethiopia_df <- apply(   ethiopia_df, 2, as.character)
      kenya_df <- apply(      kenya_df, 2, as.character)
   tanzania_df <- apply(   tanzania_df, 2, as.character)
         sa_df <- apply(         sa_df, 2, as.character)
   zimbabwe_df <- apply(   zimbabwe_df, 2, as.character)


saveRDS(      egypt_df, "./01_data/0203_country_dfs/egypt_df.Rds")
saveRDS(    morocco_df, "./01_data/0203_country_dfs/morocco_df.Rds")
saveRDS(    algeria_df, "./01_data/0203_country_dfs/algeria_df.Rds")
saveRDS(    eg_mor_alg_df, "./01_data/0203_country_dfs/eg_mor_alg_df.Rds")
saveRDS(    nigeria_df, "./01_data/0203_country_dfs/nigeria_df.Rds")
saveRDS(      ghana_df, "./01_data/0203_country_dfs/ghana_df.Rds")
saveRDS(    senegal_df, "./01_data/0203_country_dfs/senegal_df.Rds")
saveRDS(    sen_gha_ni_df, "./01_data/0203_country_dfs/sen_gha_ni_df.Rds")
saveRDS(    eth_ken_tan_df, "./01_data/0203_country_dfs/eth_ken_tan_df.Rds")
saveRDS(    con_cam_gab_df, "./01_data/0203_country_dfs/con_cam_gab_df.Rds")
saveRDS(    west_east_central_df, "./01_data/0203_country_dfs/west_east_central_df.Rds")

saveRDS(   cameroon_df, "./01_data/0203_country_dfs/cameroon_df.Rds")
saveRDS(demrepcongo_df, "./01_data/0203_country_dfs/demrepcongo_df.Rds")
saveRDS(   ethiopia_df, "./01_data/0203_country_dfs/ethiopia_df.Rds")
saveRDS(      kenya_df, "./01_data/0203_country_dfs/kenya_df.Rds")
saveRDS(   tanzania_df, "./01_data/0203_country_dfs/tanzania_df.Rds")
saveRDS(         sa_df, "./01_data/0203_country_dfs/sa_df.Rds")
saveRDS(   zimbabwe_df, "./01_data/0203_country_dfs/zimbabwe_df.Rds")

write.csv(      egypt_df, "./01_data/0203_country_dfs/egypt_df.csv")
write.csv(    morocco_df, "./01_data/0203_country_dfs/morocco_df.csv")
write.csv(    algeria_df, "./01_data/0203_country_dfs/algeria_df.csv")
write.csv(    eg_mor_alg_df, "./01_data/0203_country_dfs/eg_mor_alg_df.csv")
write.csv(    nigeria_df, "./01_data/0203_country_dfs/nigeria_df.csv")
write.csv(      ghana_df, "./01_data/0203_country_dfs/ghana_df.csv")
write.csv(    senegal_df, "./01_data/0203_country_dfs/senegal_df.csv")
write.csv(    sen_gha_ni_df, "./01_data/0203_country_dfs/sen_gha_ni_df.csv")
write.csv(    eth_ken_tan_df, "./01_data/0203_country_dfs/eth_ken_tan_df.csv")
write.csv(    con_cam_gab_df, "./01_data/0203_country_dfs/con_cam_gab_df.csv")
write.csv(    west_east_central_df, "./01_data/0203_country_dfs/west_east_central_df.csv")

write.csv(   cameroon_df, "./01_data/0203_country_dfs/cameroon_df.csv")
write.csv(demrepcongo_df, "./01_data/0203_country_dfs/demrepcongo_df.csv")
write.csv(   ethiopia_df, "./01_data/0203_country_dfs/ethiopia_df.csv")
write.csv(      kenya_df, "./01_data/0203_country_dfs/kenya_df.csv")
write.csv(   tanzania_df, "./01_data/0203_country_dfs/tanzania_df.csv")
write.csv(         sa_df, "./01_data/0203_country_dfs/sa_df.csv")
write.csv(   zimbabwe_df, "./01_data/0203_country_dfs/zimbabwe_df.csv")

#################### GO to network_method.py
#################### GO to network_method.py
#################### GO to network_method.py
#################### GO to network_method.py
#################### GO to network_method.py
#################### GO to network_method.py
#################### GO to network_method.py
#################### GO to network_method.py
#################### GO to network_method.py
#################### GO to network_method.py
#################### GO to network_method.py

# Load and vis
      egypt.nodes <- read.csv("./04_visualisation/03_networks/egypt_nodes.csv")
    morocco.nodes <- read.csv("./04_visualisation/03_networks/morocco_nodes.csv")
    algeria.nodes <- read.csv("./04_visualisation/03_networks/algeria_nodes.csv")
    eg_mor_alg.nodes <- read.csv("./04_visualisation/03_networks/eg_mor_alg_nodes.csv")
    nigeria.nodes <- read.csv("./04_visualisation/03_networks/nigeria_nodes.csv")
      ghana.nodes <- read.csv("./04_visualisation/03_networks/ghana_nodes.csv")
    senegal.nodes <- read.csv("./04_visualisation/03_networks/senegal_nodes.csv")
    sen_gha_ni.nodes <- read.csv("./04_visualisation/03_networks/sen_gha_ni_nodes.csv")
    eth_ken_tan.nodes <- read.csv("./04_visualisation/03_networks/eth_ken_tan_nodes.csv")
    con_cam_gab.nodes <- read.csv("./04_visualisation/03_networks/con_cam_gab_nodes.csv")
    west_east_central.nodes <- read.csv("./04_visualisation/03_networks/west_east_central_nodes.csv")

   cameroon.nodes <- read.csv("./04_visualisation/03_networks/cameroon_nodes.csv")
demrepcongo.nodes <- read.csv("./04_visualisation/03_networks/demrepcongo_nodes.csv")
   ethiopia.nodes <- read.csv("./04_visualisation/03_networks/ethiopia_nodes.csv")
      kenya.nodes <- read.csv("./04_visualisation/03_networks/kenya_nodes.csv")
   tanzania.nodes <- read.csv("./04_visualisation/03_networks/tanzania_nodes.csv")
         sa.nodes <- read.csv("./04_visualisation/03_networks/south_a_nodes.csv")
   zimbabwe.nodes <- read.csv("./04_visualisation/03_networks/zimbabwe_nodes.csv")

      egypt.edges <- read.csv("./04_visualisation/03_networks/egypt_edges.csv")
    morocco.edges <- read.csv("./04_visualisation/03_networks/morocco_edges.csv")
    algeria.edges <- read.csv("./04_visualisation/03_networks/algeria_edges.csv")
    eg_mor_alg.edges <- read.csv("./04_visualisation/03_networks/eg_mor_alg_edges.csv")
    nigeria.edges <- read.csv("./04_visualisation/03_networks/nigeria_edges.csv")
      ghana.edges <- read.csv("./04_visualisation/03_networks/ghana_edges.csv")
    senegal.edges <- read.csv("./04_visualisation/03_networks/senegal_edges.csv")
    sen_gha_ni.edges <- read.csv("./04_visualisation/03_networks/sen_gha_ni_edges.csv")
    eth_ken_tan.edges <- read.csv("./04_visualisation/03_networks/eth_ken_tan_edges.csv")
    con_cam_gab.edges <- read.csv("./04_visualisation/03_networks/con_cam_gab_edges.csv")
    west_east_central.edges <- read.csv("./04_visualisation/03_networks/west_east_central_edges.csv")

   cameroon.edges <- read.csv("./04_visualisation/03_networks/cameroon_edges.csv")
demrepcongo.edges <- read.csv("./04_visualisation/03_networks/demrepcongo_edges.csv")
   ethiopia.edges <- read.csv("./04_visualisation/03_networks/ethiopia_edges.csv")
      kenya.edges <- read.csv("./04_visualisation/03_networks/kenya_edges.csv")
   tanzania.edges <- read.csv("./04_visualisation/03_networks/tanzania_edges.csv")
         sa.edges <- read.csv("./04_visualisation/03_networks/south_a_edges.csv")
   zimbabwe.edges <- read.csv("./04_visualisation/03_networks/zimbabwe_edges.csv")

head(west_east_central.nodes)


      egypt.edges.rm <-       egypt.edges$value < 20
    morocco.edges.rm <-     morocco.edges$value < 15 
    algeria.edges.rm <-     algeria.edges$value < 15 
    eg_mor_alg.edges.rm <-     eg_mor_alg.edges$value < 20 
 sen_gha_ni.edges.rm <-     sen_gha_ni.edges$value < 20 
eth_ken_tan.edges.rm <-     eth_ken_tan.edges$value < 20 
con_cam_gab.edges.rm <-     con_cam_gab.edges$value < 20 
#west_east_central.edges$value <- west_east_central.edges$value + 3
west_east_central.edges.rm <-     west_east_central.edges$value < 15
   cameroon.edges.rm <-    cameroon.edges$value < 5
demrepcongo.edges.rm <- demrepcongo.edges$value < 5
   ethiopia.edges.rm <-    ethiopia.edges$value < 5
      kenya.edges.rm <-       kenya.edges$value < 5 
   tanzania.edges.rm <-    tanzania.edges$value < 5 
         sa.edges.rm <-          sa.edges$value < 20
   zimbabwe.edges.rm <-    zimbabwe.edges$value < 20

      egypt.edges <-       egypt.edges[!egypt.edges.rm, ]
    morocco.edges <-     morocco.edges[!morocco.edges.rm, ]
    algeria.edges <-     algeria.edges[!algeria.edges.rm, ]
    eg_mor_alg.edges <-     eg_mor_alg.edges[!eg_mor_alg.edges.rm, ]
##    nigeria.edges <-     nigeria.edges[!nigeria.edges.rm, ]
##      ghana.edges <-       ghana.edges[!ghana.edges.rm, ]
##     senegal.edges <-     senegal.edges[!senegal.edges.rm, ]
sen_gha_ni.edges <-     sen_gha_ni.edges[!sen_gha_ni.edges.rm, ]
eth_ken_tan.edges <-     eth_ken_tan.edges[!eth_ken_tan.edges.rm, ]
con_cam_gab.edges <-     con_cam_gab.edges[!con_cam_gab.edges.rm, ]
west_east_central.edges <-     west_east_central.edges[!west_east_central.edges.rm, ]
    cameroon.edges <-    cameroon.edges[!cameroon.edges.rm, ]
 demrepcongo.edges <- demrepcongo.edges[!demrepcongo.edges.rm, ]
ethiopia.edges <-    ethiopia.edges[!ethiopia.edges.rm, ]
       kenya.edges <-       kenya.edges[!kenya.edges.rm, ]
    tanzania.edges <-    tanzania.edges[!tanzania.edges.rm, ]
         sa.edges <-          sa.edges[!sa.edges.rm, ]
   zimbabwe.edges <-    zimbabwe.edges[!zimbabwe.edges.rm, ]



##      egypt.edges.nodes <-       egypt.edges.nodes[      egypt.edges.nodes$id %in% unique(c(      egypt.edges.edges$from,       egypt.edges$to)), ]
##    morocco.edges.nodes <-     morocco.edges.nodes[    morocco.edges.nodes$id %in% unique(c(    morocco.edges.edges$from,     morocco.edges$to)), ]
##    algeria.edges.nodes <-     algeria.edges.nodes[    algeria.edges.nodes$id %in% unique(c(    algeria.edges.edges$from,     algeria.edges$to)), ]
##    eg_mor_alg.edges.nodes <-     eg_mor_alg.edges.nodes[    eg_mor_alg.edges.nodes$id %in% unique(c(    eg_mor_alg.edges.edges$from,     eg_mor_alg.edges$to)), ]
##
## sen_gha_ni.edges.nodes <-  sen_gha_ni.edges.nodes[ sen_gha_ni.edges.nodes$id %in% unique(c( sen_gha_ni.edges.edges$from,  sen_gha_ni.edges$to)), ]
##eth_ken_tan.edges.nodes <- eth_ken_tan.edges.nodes[eth_ken_tan.edges.nodes$id %in% unique(c(eth_ken_tan.edges.edges$from, eth_ken_tan.edges$to)), ]
##con_cam_gab.edges.nodes <- con_cam_gab.edges.nodes[con_cam_gab.edges.nodes$id %in% unique(c(con_cam_gab.edges.edges$from, con_cam_gab.edges$to)), ]
##west_east_central.nodes <- west_east_central.nodes[west_east_central.nodes$id %in% unique(c(west_east_central.edges$from, west_east_central$to)), ]
##   cameroon.edges.nodes <-    cameroon.edges.nodes[   cameroon.edges.nodes$id %in% unique(c(   cameroon.edges.edges$from,    cameroon.edges$to)), ]
##demrepcongo.edges.nodes <- demrepcongo.edges.nodes[demrepcongo.edges.nodes$id %in% unique(c(demrepcongo.edges.edges$from, demrepcongo.edges$to)), ]
##   ethiopia.edges.nodes <-    ethiopia.edges.nodes[   ethiopia.edges.nodes$id %in% unique(c(   ethiopia.edges.edges$from,    ethiopia.edges$to)), ]
##      kenya.edges.nodes <-       kenya.edges.nodes[      kenya.edges.nodes$id %in% unique(c(      kenya.edges.edges$from,       kenya.edges$to)), ]
##   tanzania.edges.nodes <-    tanzania.edges.nodes[   tanzania.edges.nodes$id %in% unique(c(   tanzania.edges.edges$from,    tanzania.edges$to)), ]
##         sa.edges.nodes <-          sa.edges.nodes[         sa.edges.nodes$id %in% unique(c(         sa.edges.edges$from,          sa.edges$to)), ]
##   zimbabwe.edges.nodes <-    zimbabwe.edges.nodes[   zimbabwe.edges.nodes$id %in% unique(c(   zimbabwe.edges.edges$from,    zimbabwe.edges$to)), ]

      egypt_pres_nodes <- c(      egypt.edges$to,       egypt.edges$from)
    morocco_pres_nodes <- c(    morocco.edges$to,     morocco.edges$from)
    algeria_pres_nodes <- c(    algeria.edges$to,     algeria.edges$from)
    eg_mor_alg_pres_nodes <- c(    eg_mor_alg.edges$to,     eg_mor_alg.edges$from)
    nigeria_pres_nodes <- c(    nigeria.edges$to,     nigeria.edges$from)
      ghana_pres_nodes <- c(      ghana.edges$to,       ghana.edges$from)
    senegal_pres_nodes <- c(    senegal.edges$to,     senegal.edges$from)
    sen_gha_ni_pres_nodes <- c(    sen_gha_ni.edges$to,     sen_gha_ni.edges$from)
    eth_ken_tan_pres_nodes <- c(    eth_ken_tan.edges$to,     eth_ken_tan.edges$from)
    con_cam_gab_pres_nodes <- c(    con_cam_gab.edges$to,     con_cam_gab.edges$from)
    west_east_central_pres_nodes <- c(    west_east_central.edges$to,     west_east_central.edges$from)

   cameroon_pres_nodes <- c(   cameroon.edges$to,    cameroon.edges$from)
demrepcongo_pres_nodes <- c(demrepcongo.edges$to, demrepcongo.edges$from)
   ethiopia_pres_nodes <- c(   ethiopia.edges$to,    ethiopia.edges$from)
      kenya_pres_nodes <- c(      kenya.edges$to,       kenya.edges$from)
   tanzania_pres_nodes <- c(   tanzania.edges$to,    tanzania.edges$from)
         sa_pres_nodes <- c(         sa.edges$to,          sa.edges$from)
   zimbabwe_pres_nodes <- c(   zimbabwe.edges$to,    zimbabwe.edges$from)


      egypt.nodes <-       egypt.nodes[which(      egypt.nodes$id %in%      egypt_pres_nodes),]
    morocco.nodes <-     morocco.nodes[which(    morocco.nodes$id %in%    morocco_pres_nodes),]
    algeria.nodes <-     algeria.nodes[which(    algeria.nodes$id %in%    algeria_pres_nodes),]
    eg_mor_alg.nodes <-     eg_mor_alg.nodes[which(    eg_mor_alg.nodes$id %in%    eg_mor_alg_pres_nodes),]
    nigeria.nodes <-     nigeria.nodes[which(    nigeria.nodes$id %in%    nigeria_pres_nodes),]
      ghana.nodes <-       ghana.nodes[which(      ghana.nodes$id %in%      ghana_pres_nodes),]
    senegal.nodes <-     senegal.nodes[which(    senegal.nodes$id %in%    senegal_pres_nodes),]
    sen_gha_ni.nodes <-     sen_gha_ni.nodes[which(    sen_gha_ni.nodes$id %in%    sen_gha_ni_pres_nodes),]
    eth_ken_tan.nodes <-     eth_ken_tan.nodes[which(    eth_ken_tan.nodes$id %in%    eth_ken_tan_pres_nodes),]
    con_cam_gab.nodes <-     con_cam_gab.nodes[which(    con_cam_gab.nodes$id %in%    con_cam_gab_pres_nodes),]
    west_east_central.nodes <-     west_east_central.nodes[which(    west_east_central.nodes$id %in%    west_east_central_pres_nodes),]
    
   cameroon.nodes <-    cameroon.nodes[which(   cameroon.nodes$id %in%   cameroon_pres_nodes),]
demrepcongo.nodes <- demrepcongo.nodes[which(demrepcongo.nodes$id %in% demrepcongo_pres_nodes),]
   ethiopia.nodes <-    ethiopia.nodes[which(   ethiopia.nodes$id %in%   ethiopia_pres_nodes),]
      kenya.nodes <-       kenya.nodes[which(      kenya.nodes$id %in%      kenya_pres_nodes),]
   tanzania.nodes <-    tanzania.nodes[which(   tanzania.nodes$id %in%   tanzania_pres_nodes),]
         sa.nodes <-          sa.nodes[which(         sa.nodes$id %in%         sa_pres_nodes),]
   zimbabwe.nodes <-    zimbabwe.nodes[which(   zimbabwe.nodes$id %in%   zimbabwe_pres_nodes),]

vis_reg_net <- function(nodes, edges, height = "1000px", width = "100%", nn=20){
  vis <- visNetwork(nodes, edges, height = height, width = width, footer=list(text = paste0("*Collaborations with fewer than ", nn, " co-publications have been removed"))) %>%
  visOptions(highlightNearest = TRUE) %>%
  visLayout(randomSeed = 123, improvedLayout = TRUE) %>%  
  visGroups(groupname = "Northern Africa", color = "#a6761d") %>%
  ##visGroups(groupname = "Northern Africa", color = "#C9A38D") %>%
  visGroups(groupname = "Western Africa", color = "#666666") %>%
  ##visGroups(groupname = "Western Africa", color = "#939393") %>%
  visGroups(groupname = "Central Africa", color = "#1b9e77") %>%
  ##visGroups(groupname = "Central Africa", color = "#5EBB9F") %>%
  visGroups(groupname = "Eastern Africa", color = "#7570b3") %>%
  ##visGroups(groupname = "Eastern Africa", color = "#B997AF") %>%
  visGroups(groupname = "Southern Africa", color = "#e6ab02") %>%
  ##visGroups(groupname = "Southern Africa", color = "#E2BA56") %>%
  visGroups(groupname = "EU-27", color = "lightblue") %>%
  visGroups(groupname = "Saudi Arabia", shape = "icon", icon = list(opacity=0.3, color="#0F8554", code = "f111")) 
  #visGroups(groupname = "United Arab Emirates", shape = "icon", icon = list(code = "f111", size = 75)) %>%
  #visGroups(groupname = "United States", shape = "icon", icon = list(code = "f111", size = 75)) %>%
  #visGroups(groupname = "Spain", shape = "icon", icon = list(code = "f111", size = 75)) %>%
  #visGroups(groupname = "Japan", shape = "icon", icon = list(code = "f111", size = 75)) %>%
  #visGroups(groupname = "China", shape = "icon", icon = list(code = "f111", size = 75)) %>%
  #visGroups(groupname = "India", shape = "icon", icon = list(code = "f111", size = 75)) %>%
  col_col <- c("#E58606","#5D69B1","#52BCA3","#99C945","#CC61B0","#24796C","#DAA51B","#2F8AC4","#764E9F","#ED645A","#CC3A8E","#A5AA99")
  for (i in seq_along(unique(nodes$group))) {
    print(unique(nodes$group)[i])
    vis <- vis %>% 
    visGroups(groupname = unique(nodes$group)[i], shape = "icon", icon = list(color=col_col[i],code = "f111")) 
  }

  vis <- vis %>%
  visGroups(groupname = "Egypt", shape = "icon", icon = list(color="#9e6788", code = "f111")) %>%
  visGroups(groupname = "Algeria", shape = "icon", icon = list(color="#2F8AC4", code = "f111")) %>%
  visGroups(groupname = "Morocco", shape = "icon", icon = list(color="#6c9685", code = "f111")) %>%
  visGroups(groupname = "United Kingdom", shape = "icon", icon = list(color="#A06177", code = "f111")) %>%
  visGroups(groupname = "South Africa", shape = "icon", icon = list(color="#EDAD08", code = "f111")) %>%
  visGroups(groupname = "Cameroon", shape = "icon", icon = list(color="#9e6788", code = "f111")) %>%
  visGroups(groupname = "Ethiopia", shape = "icon", icon = list(color="#2F8AC4", code = "f111")) %>%
  visGroups(groupname = "Gabon", shape = "icon", icon = list(color="#6c9685", code = "f111")) %>%
  visGroups(groupname = "Nigeria", shape = "icon", icon = list(color="#764E9F", code = "f111")) %>%
  visGroups(groupname = "Belgium", shape = "icon", icon = list(color="#b3aa31", code = "f111")) %>%
  visGroups(groupname = "United Kingdom", shape = "icon", icon = list(color="#ff7676", code = "f111")) %>%

  visEdges(color=list(opacity=0.5)) %>%
  visNodes(
      shape = "dot",
      size=log(nodes$value),
      print(log(nodes$value)),
      color = list(
        background = "#0085AF",
        border = "#013848",
        highlight = "#FF8000",
color=list(opacity=0.5)
      ),
      shadow = list(enabled = TRUE, size = 10)
  ) %>%  visPhysics(solver = "forceAtlas2Based", forceAtlas2Based = list(gravitationalConstant = -30)) %>%
 visLegend(useGroups = TRUE, ncol=1)
  return(vis)
}



#egypt_net <- visNetwork(egypt.nodes, egypt.edges, height = "500px", width = "100%") %>% 
#  visOptions(highlightNearest = TRUE) %>%
#  visOptions(selectedBy = "group") %>%
#  visLayout(randomSeed = 123) %>%  
#  visGroups(groupname = "Northern Africa", color ="#BF9983") %>%
#  visGroups(groupname = "EU-27", color = "lightblue") %>%
#   visNodes(
#    shape = "dot",
#    color = list(
#      background = "#0085AF",
#      border = "#013848",
#      highlight = "#FF8000"
#    ),
#    shadow = list(enabled = TRUE, size = 10)
#  )

      egypt.nodes$font.size <- log(      egypt.nodes$value) * 4.2 
    morocco.nodes$font.size <- log(    morocco.nodes$value) * 3.5 
    algeria.nodes$font.size <- log(    algeria.nodes$value) * 4
    algeria.nodes$node.size <- log(    algeria.nodes$value) * 4
    eg_mor_alg.nodes$font.size <- log(    eg_mor_alg.nodes$value) * 5 
    nigeria.nodes$font.size <- log(    nigeria.nodes$value) * 5
      ghana.nodes$font.size <- log(      ghana.nodes$value) * 5
    senegal.nodes$font.size <- log(    senegal.nodes$value) * 5
    sen_gha_ni.nodes$font.size <- log(    sen_gha_ni.nodes$value) * 5
    eth_ken_tan.nodes$font.size <- log(    eth_ken_tan.nodes$value) * 5
    con_cam_gab.nodes$font.size <- log(    con_cam_gab.nodes$value) * 5
    west_east_central.nodes$font.size <- log(    west_east_central.nodes$value) * 5
   cameroon.nodes$font.size <- log(   cameroon.nodes$value) * 5
demrepcongo.nodes$font.size <- log(demrepcongo.nodes$value) * 5
   ethiopia.nodes$font.size <- log(   ethiopia.nodes$value) * 5
      kenya.nodes$font.size <- log(      kenya.nodes$value) * 5
   tanzania.nodes$font.size <- log(   tanzania.nodes$value) * 5
         sa.nodes$font.size <- log(         sa.nodes$value) * 5
   zimbabwe.nodes$font.size <- log(   zimbabwe.nodes$value) * 5

egypt.nodes$label <- gsub("University", "Uni.",egypt.nodes$label )
egypt.nodes$label <- gsub("Technology", "Tech.",egypt.nodes$label )
egypt.nodes$label <- gsub("Institute", "Inst.",egypt.nodes$label )
egypt.nodes$label <- gsub("Economics", "Econ.",egypt.nodes$label )
egypt.nodes$label <- gsub("Research", "Res.",egypt.nodes$label )
egypt.nodes$label <- gsub("Technological", "Tech.",egypt.nodes$label )
egypt.nodes$label <- gsub("Science", "Sci.",egypt.nodes$label )
egypt.nodes$label <- gsub("Centre", "CTR",egypt.nodes$label )

trun_org_name <- function(org_nodes, rm_list) {
  for (i in seq_along(rm_list[,1])) {
     org_nodes$label <- gsub(rm_list[i, 1], rm_list[i,2], org_nodes$label )
  }
  return(org_nodes$label)
}

to_trun <- c(
"University",
"Advanced",
"Foundation",
"Polytechnique",
"Technology",
"Institute",
"Economics",
"Research",
"Technological",
"Science",
"Centre"
)

to_swap <- c(
"Uni.",
"Adv.",
"Fou.",
"Poly.",
"Tech.",
"Inst.",
"Econ.",
"Res.",
"Tech.",
"Sci.",
"CTR"
)

m_list <- as.data.frame(cbind(to_trun, to_swap))
ncol(m_list)

            egypt.nodes$label  <- trun_org_name(egypt.nodes, m_list )
          morocco.nodes$label  <- trun_org_name(          morocco.nodes, m_list )
          algeria.nodes$label  <- trun_org_name(          algeria.nodes, m_list )
west_east_central.nodes$label  <- trun_org_name(west_east_central.nodes, m_list )
               sa.nodes$label  <- trun_org_name(               sa.nodes, m_list )

# Null elements
sa.nodes <- sa.nodes[-c(2), ]
# id 11
sa.edges["from"] == 11
sa.nodes[2, "id" ]


## west_east_central.nodes[west_east_central.nodes$label == sa.nodes[2, "label" ],]


##west_east_central.nodes[24,]
##west_east_central.nodes <- west_east_central.nodes[-c(24),]
##west_east_central.nodes <- west_east_central.nodes[west_east_central.nodes$id %in% unique(c(west_east_central.edges$from, west_east_central.edges$to)), ]
##west_east_central.nodes[west_east_central.nodes$label == "UKOLN", "label"] = "UCL"

west_east_central.nodes <- west_east_central.nodes[!(west_east_central.nodes$label %in% c("Smithsonian Tropical Research Institute", "Smithsonian Tropical Research Institute", "University of Florida")), ]  
sa.nodes <- sa.nodes[!(sa.nodes$label == "De Beers (South Africa)"), ]  
sa.nodes <- sa.nodes[!(sa.nodes$label == "Rhodes Uni."), ]  
morocco.nodes <- morocco.nodes[!(morocco.nodes$label == "Maroc Numeric Cluster"), ]  

sa.nodes[west_east_central.nodes$label == "CSIR", "label"] = "UCL"

egypt.nodes[which(egypt.nodes$label == "Chungbuk National Uni."), "label"] <- "JeonBuk National University"
# Eliminate anomalies 
rownames(west_east_central.nodes) <- NULL
west_east_central.nodes <- west_east_central.nodes[-c(2), ]

rownames(west_east_central.nodes) <- NULL
west_east_central.nodes <- west_east_central.nodes[-c(19, 35, 28,37, 16, 17), ]
rownames(west_east_central.nodes) <- NULL

rownames(egypt.nodes) <- NULL
egypt.nodes <- egypt.nodes[-c(21),]


west_east_central.nodes[which(west_east_central.nodes$label == "UKOLN"), "label"] <- "UCL"
# Eliminate anomalies 
#west_east_central.nodes <- west_east_central.nodes[-c(5, 26, 18), ]
   unique(egypt.nodes$group)
   egypt.nodes$shape <- "dot"
   egypt.nodes$color.opacity<-0.3
      egypt_net <- vis_reg_net(      egypt.nodes,       egypt.edges, nn=20) 
    morocco_net <- vis_reg_net(    morocco.nodes,     morocco.edges, nn=15)
    algeria_net <- vis_reg_net(    algeria.nodes,     algeria.edges, nn=15)
    eg_mor_alg_net <- vis_reg_net(    eg_mor_alg.nodes,     eg_mor_alg.edges, nn=20)
    nigeria_net <- vis_reg_net(    nigeria.nodes,     nigeria.edges)
      ghana_net <- vis_reg_net(      ghana.nodes,       ghana.edges)
    senegal_net <- vis_reg_net(    senegal.nodes,     senegal.edges)
    sen_gha_ni_net <- vis_reg_net(    sen_gha_ni.nodes,     sen_gha_ni.edges, nn=20)
    eth_ken_tan_net <- vis_reg_net(    eth_ken_tan.nodes,     eth_ken_tan.edges, nn=20)
    con_cam_gab_net <- vis_reg_net(    con_cam_gab.nodes,     con_cam_gab.edges, nn=20)
    west_east_central_net <- vis_reg_net(    west_east_central.nodes,     west_east_central.edges, nn=15)
   cameroon_net <- vis_reg_net(   cameroon.nodes,    cameroon.edges, nn=5)
demrepcongo_net <- vis_reg_net(demrepcongo.nodes, demrepcongo.edges, nn=5)
   ethiopia_net <- vis_reg_net(   ethiopia.nodes,    ethiopia.edges, nn=5)
      kenya_net <- vis_reg_net(      kenya.nodes,       kenya.edges, nn=5)
   tanzania_net <- vis_reg_net(   tanzania.nodes,    tanzania.edges, nn=5)
         sa_net <- vis_reg_net(         sa.nodes,          sa.edges, nn=20)
   zimbabwe_net <- vis_reg_net(   zimbabwe.nodes,    zimbabwe.edges, nn=20)




unique(egypt.nodes$group)





  ## %>%
  ## visLegend(width = 0.1, position = "right", main = "Group")
 ## visLegend(addNodes = list(
 ## list(label = "Northern Africa", shape = "icon", 
 ##      icon = list(code = "dot", size = 25)),
 ## list(label = "User", shape = "icon", 
 ##      icon = list(code = "dot", size = 50, color = "red"))), 
 ## useGroups = FALSE)

saveRDS(      egypt_net, "./04_visualisation/03_networks/01_outputs/egypt_net.Rds")
saveRDS(    morocco_net, "./04_visualisation/03_networks/01_outputs/morocco_net.Rds")
saveRDS(    algeria_net, "./04_visualisation/03_networks/01_outputs/algeria_net.Rds")
saveRDS(west_east_central_net, "./04_visualisation/03_networks/01_outputs/west_east_central_net.Rds")
saveRDS(sa_net, "./04_visualisation/03_networks/01_outputs/south_a_net.Rds")

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

egypt_net             <- readRDS("./04_visualisation/03_networks/01_outputs/egypt_net.Rds")
morocco_net           <- readRDS("./04_visualisation/03_networks/01_outputs/morocco_net.Rds")
algeria_net           <- readRDS("./04_visualisation/03_networks/01_outputs/algeria_net.Rds")
west_east_central_net <- readRDS("./04_visualisation/03_networks/01_outputs/west_east_central_net.Rds")
sa_net                <- readRDS("./04_visualisation/03_networks/01_outputs/south_a_net.Rds")

