library(tidytext)
library(reticulate)
library(dplyr)
library(tidyr)
library(tidylo)
library(tidygraph)
library(ggraph)
library(widyr)
library(visNetwork)

M_06_ex <- readRDS("./01_data/02_bibliometrix/res_area_exp_07_ngrams.Rds")


M_06_ex$un_bigrams <- sapply(FUN=gsub,  " pv ", " photovoltaic_energy ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "pv", "photovoltaic_energy", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " oxide_nano ", " oxide_nanoparticle ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " sensor_network ", " sensor_networks ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " al_solar ", " ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " ethiopia ", " ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " southern_africa ", " ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " modeling ", " ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " modeling/simulation ", " ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " temperature ", " ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " efficiency ", " ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " performance ", " ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " simulation ", " ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " component ", " ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " addis_ababa ", " ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " 25th_anniversary ", " ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " tropical_forest ", " tropical_forests ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " carbon_stock ", " carbon_stocks ", M_06_ex$un_bigrams, fixed=TRUE)

M_06_ex$text <- M_06_ex$un_bigrams
cairo_df <- M_06_ex[M_06_ex$org_prop == "Cairo University",]
redec_df <- M_06_ex[M_06_ex$org_prop == "Renewable Energy Development Center",]
moham_df <- M_06_ex[M_06_ex$org_prop == "Mohammed V University",]
coven_df <- M_06_ex[M_06_ex$org_prop == "Covenant University",]
unini_df <- M_06_ex[M_06_ex$org_prop == "University of Nigeria",]
yaoun_df <- M_06_ex[M_06_ex$org_prop == "Université de Yaoundé I",]
addis_df <- M_06_ex[M_06_ex$org_prop == "Addis Ababa University",]
mekel_df <- M_06_ex[M_06_ex$org_prop == "Mekelle University",]
kwazu_df <- M_06_ex[M_06_ex$org_prop == "University of KwaZulu-Natal", ]
capet_df <- M_06_ex[M_06_ex$org_prop == "University of Cape Town",]
stell_df <- M_06_ex[M_06_ex$org_prop == "Stellenbosch University",]

gen_word_net <- function(word_df, nn = 20) {
  words <- word_df %>%
    unnest_tokens(word, text) %>%
    filter(!word %in% c(stop_words$word, 
                        "na", 
                        "NA",
                        "nan", 
                        "NAN", 
                        "system", 
                        "systems",
                        "algeria",
                        "nigeria",
                        "africa",
                        "bio",
                        "cameroon",
                        "ulti",
                        "multi")) 
    print(1)
  words %>% 
   pairwise_count(word, res_domains, sort = TRUE)%>% 
   filter(item1 == "nan") 
  cor <- words %>%
    add_count(word) %>%
    filter(n > nn) %>%
    select(-n) %>%
    pairwise_cor(word, res_domains, sort=TRUE)
    print(2)
  net <- cor %>%
    filter(correlation > .5) %>%
    as_tbl_graph()
    print(3)

  edges <- net %>% activate(edges) %>% as.data.frame()
  nodes <- net %>% activate(nodes) %>% as.data.frame()
  colnames(edges)[3] <- "value"
  print(colnames(edges))
  nodes$id <- 1:length(nodes$name)
  colnames(nodes)[1] <- "label"
  nodes <- nodes[,c(2,1)]
  nodes$font.size <-30  

  return(list(nodes, edges))
}

cairo_net <- gen_word_net(cairo_df, 25)
redec_net <- gen_word_net(redec_df, 40)
#moham_net <- gen_word_net(moham_df, 45)
moham_net <- gen_word_net(moham_df, 45)
coven_net <- gen_word_net(coven_df, 14)
unini_net <- gen_word_net(unini_df, 8)
yaoun_net <- gen_word_net(yaoun_df, 11)
addis_net <- gen_word_net(addis_df, 10)
mekel_net <- gen_word_net(mekel_df, 9)
#kwazu_net <- gen_word_net(kwazu_df, 40)
kwazu_net <- gen_word_net(kwazu_df, 20)
#capet_net <- gen_word_net(capet_df, 45)
capet_net <- gen_word_net(capet_df, 27)
#stell_net <- gen_word_net(stell_df, 45)
stell_net <- gen_word_net(stell_df, 30)


gen_ngram_network <- function(net_df) {
  out_net <- visNetwork(net_df[[1]], net_df[[2]], width = "1000px", height = "1000px") %>%
    visOptions(highlightNearest = TRUE) %>%
    visLayout(randomSeed = 123, improvedLayout = TRUE) %>%
    visNodes(
        shape = "text",
        color = list(
          background = "#0085AF",
          border = "#fdb462",
          highlight = "#FF8000"
        ),
        shadow = list(enabled = TRUE, size = 10)
    ) %>%   visIgraphLayout(layout = "layout_with_fr")  %>%
    visEdges(color=list(opacity=0.3))  
    #%>%
    # visIgraphLayout(layout = 'layout.davidson.harel')
    return(out_net)

}


cairo_ngram_network_plot <- gen_ngram_network(cairo_net)
redec_ngram_network_plot <- gen_ngram_network(redec_net)
moham_ngram_network_plot <- gen_ngram_network(moham_net)
coven_ngram_network_plot <- gen_ngram_network(coven_net)
unini_ngram_network_plot <- gen_ngram_network(unini_net)
yaoun_ngram_network_plot <- gen_ngram_network(yaoun_net)
addis_ngram_network_plot <- gen_ngram_network(addis_net)
mekel_ngram_network_plot <- gen_ngram_network(mekel_net)
kwazu_ngram_network_plot <- gen_ngram_network(kwazu_net)
capet_ngram_network_plot <- gen_ngram_network(capet_net)
stell_ngram_network_plot <- gen_ngram_network(stell_net)


saveRDS(cairo_ngram_network_plot, "./04_visualisation/06_ngrams/cairo_ngram_network_plot.Rds")
saveRDS(redec_ngram_network_plot, "./04_visualisation/06_ngrams/redec_ngram_network_plot.Rds")
saveRDS(moham_ngram_network_plot, "./04_visualisation/06_ngrams/moham_ngram_network_plot.Rds")
saveRDS(coven_ngram_network_plot, "./04_visualisation/06_ngrams/coven_ngram_network_plot.Rds")
saveRDS(unini_ngram_network_plot, "./04_visualisation/06_ngrams/unini_ngram_network_plot.Rds")
saveRDS(yaoun_ngram_network_plot, "./04_visualisation/06_ngrams/yaoun_ngram_network_plot.Rds")
saveRDS(addis_ngram_network_plot, "./04_visualisation/06_ngrams/addis_ngram_network_plot.Rds")
saveRDS(mekel_ngram_network_plot, "./04_visualisation/06_ngrams/mekel_ngram_network_plot.Rds")
saveRDS(kwazu_ngram_network_plot, "./04_visualisation/06_ngrams/kwazu_ngram_network_plot.Rds")
saveRDS(capet_ngram_network_plot, "./04_visualisation/06_ngrams/capet_ngram_network_plot.Rds")
saveRDS(stell_ngram_network_plot, "./04_visualisation/06_ngrams/stell_ngram_network_plot.Rds")






sum(is.na(yaoun_df$un_bigrams))
