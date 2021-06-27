library(visNetwork)


nodes <- read.csv("./04_visualisation/03_networks/88_network_method/test_nodes.csv")
edges <- read.csv("./04_visualisation/03_networks/88_network_method/test_edges.csv")


sum(edges$value < 10)
edges_10 <- edges[!(edges$value <30),]

new_nodes <- nodes[nodes$id %in% c(edges$from[1:50], edges$to[1:50]), ]

visNetwork(nodes, edges_10, height = "500px", width = "100%") %>% 
  visOptions(highlightNearest = TRUE) %>%
  visLayout(randomSeed = 123)

edges




