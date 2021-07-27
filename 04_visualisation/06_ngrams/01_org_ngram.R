library(tidytext)
library(reticulate)
library(dplyr)
library(tidyr)
library(tidylo)
library(tidygraph)
library(ggraph)
library(widyr)
library(visNetwork)

pd <- import("pandas")
# Let's assume we are analysing ngrams for Cairo Univ.
M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0608_org_proper.pickle")
abs_df <- read.csv("./01_data/02_bibliometrix/abs_df.csv")
str(abs_df)
# Create org df
cairo_df <- M_06[M_06$org_prop == "Cairo University",]
redec_df <- M_06[M_06$org_prop == "Renewable Energy Development Center",]
moham_df <- M_06[M_06$org_prop == "Mohammed V University",]
coven_df <- M_06[M_06$org_prop == "Covenant University",]
unini_df <- M_06[M_06$org_prop == "University of Nigeria",]
yaoun_df <- M_06[M_06$org_prop == "Université de Yaoundé I",]
addis_df <- M_06[M_06$org_prop == "Addis Ababa University",]
mekel_df <- M_06[M_06$org_prop == "Mekelle University",]
kwazu_df <- M_06[M_06$org_prop == "University of KwaZulu-Natal",]
capet_df <- M_06[M_06$org_prop == "University of Cape Town",]
stell_df <- M_06[M_06$org_prop == "Stellenbosch University",]
physi_df <- M_06["Physical Sciences" %in% M_06$res_domains,]
techn_df <- M_06["Technology" %in% M_06$res_domains,]
lifes_df <- M_06["Life Sciences & Biomedicine" %in% M_06$org_prop,]


# For test purposes, without seperating it into the res domains and just 1 column of keywords
cairo_indexes <- unique(cairo_df$ID)
redec_indexes <- unique(redec_df$ID)
moham_indexes <- unique(moham_df$ID)
coven_indexes <- unique(coven_df$ID)
unini_indexes <- unique(unini_df$ID)
yaoun_indexes <- unique(yaoun_df$ID)
addis_indexes <- unique(addis_df$ID)
mekel_indexes <- unique(mekel_df$ID)
kwazu_indexes <- unique(kwazu_df$ID)
capet_indexes <- unique(capet_df$ID)
stell_indexes <- unique(stell_df$ID)
physi_indexes <- unique(physi_df$ID)
techn_indexes <- unique(techn_df$ID)
lifes_indexes <- unique(lifes_df$ID)

sum(M_06$ID %in% cairo_indexes)
abs_df[cairo_indexes[1], "ID"]


cairo_text_df <- paste0(abs_df[cairo_indexes, "ID"], " ", abs_df[cairo_indexes, "DE"], " ", abs_df[cairo_indexes, "TI"])
redec_text_df <- paste0(abs_df[redec_indexes, "ID"], " ", abs_df[redec_indexes, "DE"], " ", abs_df[redec_indexes, "TI"])
moham_text_df <- paste0(abs_df[moham_indexes, "ID"], " ", abs_df[moham_indexes, "DE"], " ", abs_df[moham_indexes, "TI"])
coven_text_df <- paste0(abs_df[coven_indexes, "ID"], " ", abs_df[coven_indexes, "DE"], " ", abs_df[coven_indexes, "TI"])
unini_text_df <- paste0(abs_df[unini_indexes, "ID"], " ", abs_df[unini_indexes, "DE"], " ", abs_df[unini_indexes, "TI"])
yaoun_text_df <- paste0(abs_df[yaoun_indexes, "ID"], " ", abs_df[yaoun_indexes, "DE"], " ", abs_df[yaoun_indexes, "TI"])
addis_text_df <- paste0(abs_df[addis_indexes, "ID"], " ", abs_df[addis_indexes, "DE"], " ", abs_df[addis_indexes, "TI"])
mekel_text_df <- paste0(abs_df[mekel_indexes, "ID"], " ", abs_df[mekel_indexes, "DE"], " ", abs_df[mekel_indexes, "TI"])
kwazu_text_df <- paste0(abs_df[kwazu_indexes, "ID"], " ", abs_df[kwazu_indexes, "DE"], " ", abs_df[kwazu_indexes, "TI"])
capet_text_df <- paste0(abs_df[capet_indexes, "ID"], " ", abs_df[capet_indexes, "DE"], " ", abs_df[capet_indexes, "TI"])
stell_text_df <- paste0(abs_df[stell_indexes, "ID"], " ", abs_df[stell_indexes, "DE"], " ", abs_df[stell_indexes, "TI"])
physi_text_df <- paste0(abs_df[physi_indexes, "ID"], " ", abs_df[physi_indexes, "DE"], " ", abs_df[physi_indexes, "TI"])
techn_text_df <- paste0(abs_df[techn_indexes, "ID"], " ", abs_df[techn_indexes, "DE"], " ", abs_df[techn_indexes, "TI"])
lifes_text_df <- paste0(abs_df[lifes_indexes, "ID"], " ", abs_df[lifes_indexes, "DE"], " ", abs_df[lifes_indexes, "TI"])

## cairo_text_df <- abs_df[cairo_indexes, "DE"]
cairo_text_df <- as.data.frame(cairo_text_df)
redec_text_df <- as.data.frame(cairo_text_df)
moham_text_df <- as.data.frame(cairo_text_df)
coven_text_df <- as.data.frame(cairo_text_df)
unini_text_df <- as.data.frame(cairo_text_df)
yaoun_text_df <- as.data.frame(cairo_text_df)
addis_text_df <- as.data.frame(cairo_text_df)
mekel_text_df <- as.data.frame(cairo_text_df)
kwazu_text_df <- as.data.frame(cairo_text_df)
capet_text_df <- as.data.frame(cairo_text_df)
stell_text_df <- as.data.frame(cairo_text_df)
physi_text_df <- as.data.frame(physi_text_df)
techn_text_df <- as.data.frame(techn_text_df)
lifes_text_df <- as.data.frame(lifes_text_df)

cairo_text_df$res_areas <- ""
cairo_text_df$res_domains <- ""
for (i in seq_along(cairo_indexes)) {
  cairo_text_df$res_areas[i] <- unique(M_06[cairo_indexes[i] == M_06$ID, "res_areas"])
  cairo_text_df$res_domains[i] <- unique(M_06[cairo_indexes[i] == M_06$ID, "res_domains"])
}
get_areas_domains <- function(df, indexes) {
  df$res_areas <- ""
  df$res_domains <- ""
  for (i in seq_along(indexes)) {
  df$res_areas[i] <- unique(M_06[indexes[i] == M_06$ID, "res_areas"])
  df$res_domains[i] <- unique(M_06[indexes[i] == M_06$ID, "res_domains"])
}
return(df)
}

cairo_text_df <- get_areas_domains(cairo_text_df,cairo_indexes)
redec_text_df <- get_areas_domains(redec_text_df,redec_indexes)
moham_text_df <- get_areas_domains(moham_text_df,moham_indexes)
coven_text_df <- get_areas_domains(coven_text_df,coven_indexes)
unini_text_df <- get_areas_domains(unini_text_df,unini_indexes)
yaoun_text_df <- get_areas_domains(yaoun_text_df,yaoun_indexes)
addis_text_df <- get_areas_domains(addis_text_df,addis_indexes)
mekel_text_df <- get_areas_domains(mekel_text_df,mekel_indexes)
kwazu_text_df <- get_areas_domains(kwazu_text_df,kwazu_indexes)
capet_text_df <- get_areas_domains(capet_text_df,capet_indexes)
stell_text_df <- get_areas_domains(stell_text_df,stell_indexes)
physi_text_df <- get_areas_domains(physi_text_df,physi_indexes)
techn_text_df <- get_areas_domains(techn_text_df,techn_indexes)
lifes_text_df <- get_areas_domains(lifes_text_df,lifes_indexes)






colnames(cairo_text_df) <- c("text", "res_domains", "res_areas")
colnames(redec_text_df) <- c("text", "res_domains", "res_areas")
colnames(moham_text_df) <- c("text", "res_domains", "res_areas")
colnames(coven_text_df) <- c("text", "res_domains", "res_areas")
colnames(unini_text_df) <- c("text", "res_domains", "res_areas")
colnames(yaoun_text_df) <- c("text", "res_domains", "res_areas")
colnames(addis_text_df) <- c("text", "res_domains", "res_areas")
colnames(mekel_text_df) <- c("text", "res_domains", "res_areas")
colnames(kwazu_text_df) <- c("text", "res_domains", "res_areas")
colnames(capet_text_df) <- c("text", "res_domains", "res_areas")
colnames(stell_text_df) <- c("text", "res_domains", "res_areas")
colnames(physi_text_df) <- c("text", "res_domains", "res_areas")
colnames(techn_text_df) <- c("text", "res_domains", "res_areas")
colnames(lifes_text_df) <- c("text", "res_domains", "res_areas")

## cairo_df$DE <- as.vector(unlist(cairo_df$DE))
## what <- cairo_df %>% unnest_tokens(bigram, DE, token = "ngrams", n = 2)
cairo_unnested <- cairo_text_df %>% unnest_tokens(bigram, text, token = "ngrams", n = 2)


## what_freq <- what %>% count(bigram, sort = TRUE)
cairo_word_freq <- cairo_unnested %>% count(bigram, sort = TRUE)
cairo_word_freq[1:50,]

## what_freq <- what_freq %>% separate(bigram, into = c("word1", "word2"), sep = " ")
cairo_word_freq <- cairo_word_freq %>% separate(bigram, into = c("word1", "word2"), sep = " ")

## what_freq <- what_freq %>%
##   filter(!word1 %in% stop_words$word,
##          !word2 %in% stop_words$word) %>%
##   unite(bigram, c(word1, word2), sep = " ")
## what_freq %>% count(bigram, sort = TRUE)

cairo_word_freq <- cairo_word_freq %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word) %>%
  unite(bigram, c(word1, word2), sep = " ")
cairo_word_freq %>% count(bigram, sort = TRUE)





## what_freq %>% 
##   separate(bigram, into = c("word1", "word2"), sep = " ") %>%
##   filter(!word1 %in% stop_words$word) %>%
##   filter(!word2 %in% stop_words$word) %>% 
##   unite(bigram, c(word1, word2), sep = " ")


##what_freq %>%
##  separate(bigram, into = c("word1", "word2"), sep = " ")  %>% 
##  filter(word2 == "street") %>% 
##  count(street = str_c(word1, word2, sep = " "), sort = TRUE)
##
## what_freq %>% 
##   count(book, bigram, sort = TRUE) %>% 
##   bind_log_odds(set = book, feature = bigram, n = n) %>% 
##   group_by(book) %>% 
##   top_n(15) %>% 
##   ungroup() %>%
##   facet_bar(y = bigram, x = log_odds, nrow = 3)

## cairo_word_freq %>% 
##   count(book, bigram, sort = TRUE) %>% 
##   bind_log_odds(set = book, feature = bigram, n = n) %>% 
##   group_by(book) %>% 
##   top_n(15) %>% 
##   ungroup() %>%
##   facet_bar(y = bigram, x = log_odds, nrow = 3)


##   what_freq
## 
## head(what_freq)

##  what_freq %>% 
##   filter(!word1 %in% stop_words$word,
##          !word2 %in% stop_words$word) %>% 
##   count(word1, word2, sort = TRUE) 
## 
## cairo_word_freq %>% 
##   filter(!word1 %in% stop_words$word,
##          !word2 %in% stop_words$word) %>% 
##   count(word1, word2, sort = TRUE) 


 what_freq %>% 
   pairwise_count(word, section, sort = TRUE)
 
 cairo_word_freq %>% 
   pairwise_count(word, section, sort = TRUE)
 head(cairo_word_freq)
 
################################### 
cairo
redec
moham
coven
unini
yaoun
addis
mekel
kwazu
capet
stell



 
cairo_words <- cairo_text_df %>% 
  unnest_tokens(word, text)  %>%
  filter(!word %in% stop_words$word)
redec_words <- redec_text_df %>% 
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)
moham_words <- moham_text_df %>% 
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)
coven_words <- coven_text_df %>% 
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)
unini_words <- unini_text_df %>% 
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)
yaoun_words <- yaoun_text_df %>% 
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)
addis_words <- addis_text_df %>% 
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)
mekel_words <- mekel_text_df %>% 
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)
kwazu_words <- kwazu_text_df %>% 
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)
capet_words <- capet_text_df %>% 
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)
stell_words <- stell_text_df %>% 
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)










 nrow(cairo_words)
 
 cairo_words %>% 
   pairwise_count(word, res_domains, sort = TRUE)%>% 
   filter(item1 == "nan") 
  
cairo_cor <- cairo_words %>% 
  add_count(word) %>% 
  filter(n >= 20) %>% 
  select(-n) %>%
  pairwise_cor(word, res_domains, sort = TRUE)


cairo_net <- cairo_cor %>%
  filter(correlation > .5) %>%
  as_tbl_graph() 
  
gen_word_net <- function(word_df) {
  words <- word_df %>%
    unnest_tokens(word, text) %>%
    filter(!word %in% c(stop_words$word, "na", "NA","nan", "NAN"))
    print(1)
  words %>% 
   pairwise_count(word, res_domains, sort = TRUE)%>% 
   filter(item1 == "nan") 
  cor <- words %>%
    add_count(word) %>%
    filter(n>20) %>%
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
  nodes$id <- 1:length(nodes$name)
  colnames(nodes)[1] <- "label"
  nodes <- nodes[,c(2,1)]
  nodes$font.size <- 45

  return(list(nodes, edges))
}

cairo_net <- gen_word_net(cairo_text_df)
redec_net <- gen_word_net(redec_text_df)
moham_net <- gen_word_net(moham_text_df)
coven_net <- gen_word_net(coven_text_df)
unini_net <- gen_word_net(unini_text_df)
yaoun_net <- gen_word_net(yaoun_text_df)
addis_net <- gen_word_net(addis_text_df)
mekel_net <- gen_word_net(mekel_text_df)
kwazu_net <- gen_word_net(kwazu_text_df)
capet_net <- gen_word_net(capet_text_df)
stell_net <- gen_word_net(stell_text_df)
physi_net <- gen_word_net(physi_text_df)
techn_net <- gen_word_net(techn_text_df)
lifes_net <- gen_word_net(lifes_text_df)


##   %>%
##   ggraph(layout = "fr") +
##   geom_edge_link(aes(edge_alpha = correlation), show.legend = FALSE) +
##   geom_node_point(color = "lightblue", size = 5) +
##   geom_node_text(aes(label = name), repel = TRUE)





## den_nodes <- as.data.frame(cbind(1:nrow(cairo_cor), paste(cairo_cor$item1, cairo_cor$item2) ))
## colnames(den_nodes) <- c("id", "node")
## 
## 
## visNetwork(den_nodes, cairo_net)
## as.data.frame(cairo_net)
## 
## cairo_net[[1]]

## cairo_edges <- cairo_net %>% activate(edges) %>% as.data.frame()
## cairo_nodes <- cairo_net %>% activate(nodes) %>% as.data.frame()
## colnames(cairo_edges)[3] <- "value"
## cairo_nodes$id <- 1:length(cairo_nodes$name)
## colnames(cairo_nodes)[1] <- "label"
## cairo_nodes <- cairo_nodes[,c(2,1)]
## cairo_nodes$font.size <- 45

##visNetwork(cairo_nodes, cairo_edges, height ="1000px") %>%
##  visOptions(highlightNearest = TRUE) %>%
##  visLayout(randomSeed = 123, improvedLayout = TRUE) %>%
##  visNodes(
##      shape = "text",
##      color = list(
##        background = "#0085AF",
##        border = "#fdb462",
##        highlight = "#FF8000"
##      ),
##      shadow = list(enabled = TRUE, size = 10)
##  ) 
##  #%>%   visIgraphLayout(layout = "layout_with_fr")
##

visNetwork(mekel_net[[1]],mekel_net[[2]], height ="1000px") %>%
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
  ) 
  #%>%   visIgraphLayout(layout = "layout_with_fr")





