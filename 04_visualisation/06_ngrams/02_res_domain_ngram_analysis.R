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

M_06 <- M_06 %>% 
        apply(2, as.character) %>%
        as.data.frame(.)
head(M_06)
M_06_rd_ex <- M_06 %>% 
     separate_rows("res_domains", sep=";")


nrow(M_06_rd_ex)
M_06_rd_ex$res_domains <- trimws(M_06_rd_ex$res_domains)

M_06_rd_ex$text <- paste(M_06_rd_ex[, c("DE")] , " ", M_06_rd_ex[, c("TI")])
M_06_ex_bigrams <-   M_06_rd_ex %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

M_06_ex_bigrams %>%
  count(bigram, sort = TRUE)


M_06_separated <- M_06_ex_bigrams %>%  
  separate(bigram, into = c("word1", "word2"), sep = " ")


M_06_united <- M_06_separated %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word) %>%
  unite(bigram, c(word1, word2), sep = " ")

M_06_united %>% count(bigram, sort = TRUE)
