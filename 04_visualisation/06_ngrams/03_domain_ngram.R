library(reticulate)
library(tidytext)
library(stringr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(plotly)
library(formattable)

pd <- import("pandas")
M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0608_org_proper.pickle")
M_06_ex <- readRDS("./01_data/02_bibliometrix/res_area_exp_07_ngrams.Rds")
wos_dict <- readRDS("./../bibliometry_module/00_data/research_areas/wos_dictionary.Rds")


str_split(trimws(str_split(M_06_ex$DE[300], ";")[[1]]), " ")

paste0(sapply(FUN=gsub," ", "_", trimws(str_split(M_06_ex$DE[300], ";")[[1]]), fixed = TRUE), collapse=" ")

M_06_ex$prop_keyword <- M_06_ex$DE %>%
  sapply(FUN=gsub, "; ", "|", ., fixed=TRUE) %>%
  sapply(FUN=gsub, " ", "_", ., fixed=TRUE) %>%
  sapply(FUN=gsub, "|", " ", ., fixed=TRUE) 

unique_keyword_df <- data.frame(text=unlist(unique(M_06_ex["TI"])),row.names = NULL, check.rows = FALSE, check.names = TRUE, stringsAsFactors = default.stringsAsFactors())

unique_keyword_df_bigrams <- unique_keyword_df %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

unique_keyword_df_bigrams %>%
  count(bigram, sort = TRUE)

unique_keyword_df_bigrams <- unique_keyword_df_bigrams  %>%  
  separate(bigram, into = c("word1", "word2"), sep = " ")

unique_keyword_df_bigrams <- unique_keyword_df_bigrams %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word) %>%
  unite(bigram, c(word1, word2), sep = " ")

unique_keyword_df_bigrams <- unique_keyword_df_bigrams %>% count(bigram, sort = TRUE)

# Lose the renewable energy bigram
class(unique_keyword_df_bigrams)
unique_keyword_df_bigrams <- unique_keyword_df_bigrams[-c(1), ]

# Merge the identified keywords with the already existing ones
unique_keyword_df_bigrams <- unique_keyword_df_bigrams[1:20000,]
M_06_ex$bigram <- " "
for (i in seq_along(unique_keyword_df_bigrams$bigram)) { 
  print(paste0(i/length(unique_keyword_df_bigrams$bigram), " is completed"))
  keyword <- unique_keyword_df_bigrams$bigram[i]
  match_indexes <- which(grepl(keyword, tolower(M_06_ex$TI)))
  keyword <- gsub(" ", "_", keyword)
  M_06_ex$bigram[match_indexes] <- M_06_ex$bigram[match_indexes] %>%
    sapply(FUN = paste, ., keyword, collapse = " ")
  if (i %% 1000 == 0) {
    print(M_06_ex$bigram[match_indexes[length(match_indexes)]])
  }
}


head(M_06_ex$bigram)
head(M_06_ex$prop_keyword, 100)
M_06_ex$un_bigrams <- paste0(tolower(M_06_ex$prop_keyword),
                            " ",
                            trimws(M_06_ex$bigram))
M_06_ex$un_bigrams <- trimws(M_06_ex$un_bigrams)

# Make bigrams unique in each pub
for (i in seq_along(M_06_ex$un_bigrams)) {
  bg <- M_06_ex$un_bigrams[i]
  bg <- paste(unique(str_split(bg, " "))[[1]], collapse = " ") 
  M_06_ex$un_bigrams[i] <- bg
}
M_06_ex$un_bigrams[300]

#------------------------------------------------------
# 3 Goals:
# * bigram network for the orgs
# * most visible bigrams barchart for domain analysis
# * relative growth of the mv bigrams
#------------------------------------------------------

# Clear the plurals
keyword_collection <- paste(M_06_ex$un_bigrams, collapse=" ")
keyword_list <- str_split(keyword_collection, " ")
keyword_list <- unlist(keyword_list)
keyword_list <- unique(keyword_list)

keyword_list <- keyword_list[-c(which(keyword_list == "s"))]

for (i in seq_along(M_06_ex$un_bigrams)) {
  if (i%%500 == 0) {
    print(paste0(i/length(M_06_ex$un_bigrams), " is completed"))
  }
  sep_keywords <- str_split(M_06_ex$un_bigrams[i], " ")
  for (j in seq_along(sep_keywords)) {
    if (paste0(sep_keywords[j], "s") %in% keyword_list) {
      match_keyword <- keyword_list[which(paste0(sep_keywords[j], "s") == keyword_list)]
      print(paste0(sep_keywords[j], " ::: ", match_keyword))
      M_06_ex$un_bigrams[i] <- gsub(M_06_ex$un_bigrams[i], paste0(" ",M_06_ex$un_bigrams[i], " "), paste0(" ",match_keyword, " "))
    }
  }
}


# Clean the keywords
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "pv_system", "photovoltaic_system", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "south_africa ", "", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "south_african ", "", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "solar_cell ", "solar_cells ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "solar_cellss ", "solar_cells ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "solar_cellsss ", "solar_cells ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "photovoltaic_system ", "photovoltaic_energy/systems ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "photovoltaic_systems ", "photovoltaic_energy/systems ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "photovoltaic ", "photovoltaic_energy/systems ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "wind_turbine ", "wind_turbines ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " modeling ", " modeling-simulation ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " simulation ", " modeling-simulation ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "modeling/simulation", " modeling/simulation ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " modeling-modeling-modeling-modeling-modeling-simulation ", " modeling-simulation ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " modeling-modeling-modeling-modeling-simulation ", " modeling-simulation ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "energy ", "", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "fuel_cell ", "fuel_cells ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "mppt", "MPPT", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "optimization ", "", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "renewable_energy ", "", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " thin_film ", " thin_films ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "  ", " ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  "   ", " ", M_06_ex$un_bigrams, fixed=TRUE)
M_06_ex$un_bigrams <- sapply(FUN=gsub,  " numerical modeling-modeling-modeling-modeling-simulation  ", " numerical_modelling ", M_06_ex$un_bigrams, fixed=TRUE)
## sa_indexes <- which(grepl("south_africa", M_06_ex$un_bigrams))
## al_indexes <- which(grepl("al_energy", M_06_ex$un_bigrams))
## M_06_ex$un_bigrams[al_indexes[3000]]
## M_06_ex$ID[al_indexes[3000]]
## gsub("south_africa ", "", M_06_ex$un_bigrams[sa_indexes[1]])

M_06_ex$un_bigrams <- M_06_ex$un_bigrams %>% sapply(FUN=paste0, " ",., " ")

unique_bigrams <- unique(M_06_ex$un_bigrams)
all_unique_bigrams <- paste(unique_bigrams, collapse = " ")
all_unique_bigrams <- str_split(all_unique_bigrams, " ")
all_unique_bigrams <- table(all_unique_bigrams)
head(sort(all_unique_bigrams, decreasing = TRUE), 50)





# domain dfs
ps_df <- M_06_ex[M_06_ex$prop_domain == "Physical Sciences", ]
te_df <- M_06_ex[M_06_ex$prop_domain == "Technology", ]
ls_df <- M_06_ex[M_06_ex$prop_domain == "Life Sciences & Biomedicine", ]
ss_df <- M_06_ex[M_06_ex$prop_domain %in% c("Social Sciences" , "Arts & Humanities"), ]

# Create dfs with keyword and years
ps_keyword_df <- as.data.frame(cbind(ID=ps_df$ID, bigrams=ps_df$un_bigrams, year=ps_df$PY) )
te_keyword_df <- as.data.frame(cbind(ID=te_df$ID, bigrams=te_df$un_bigrams, year=te_df$PY) )
ls_keyword_df <- as.data.frame(cbind(ID=ls_df$ID, bigrams=ls_df$un_bigrams, year=ls_df$PY) )
ss_keyword_df <- as.data.frame(cbind(ID=ss_df$ID, bigrams=ss_df$un_bigrams, year=ss_df$PY) )
colnames(ps_keyword_df)[2] <- "bigrams"
colnames(te_keyword_df)[2] <- "bigrams"
colnames(ls_keyword_df)[2] <- "bigrams"
colnames(ss_keyword_df)[2] <- "bigrams"

# 1 ID 1 publication df
collapse_bigram_df <- function(df) {
  new_df <- data.frame()
  un_ids <- unique(df$ID)
  for (i in seq_along(un_ids)) {
    print(paste0(i/length(un_ids), " is completed"))
    new_line <- df[which(df$ID == un_ids[i])[1], ]
    new_df <- rbind(new_df, new_line)
  }
  return (new_df)
}

ps_un_keyword_df <- collapse_bigram_df(ps_keyword_df)
te_un_keyword_df <- collapse_bigram_df(te_keyword_df)
ls_un_keyword_df <- collapse_bigram_df(ls_keyword_df)
ss_un_keyword_df <- collapse_bigram_df(ss_keyword_df)

ps_individual_keywords <- paste(ps_un_keyword_df$bigrams, collapse = " ")
te_individual_keywords <- paste(te_un_keyword_df$bigrams, collapse = " ")
ls_individual_keywords <- paste(ls_un_keyword_df$bigrams, collapse = " ")
ss_individual_keywords <- paste(ss_un_keyword_df$bigrams, collapse = " ")

ps_individual_keywords <- str_split(ps_individual_keywords, " ")
te_individual_keywords <- str_split(te_individual_keywords, " ")
ls_individual_keywords <- str_split(ls_individual_keywords, " ")
ss_individual_keywords <- str_split(ss_individual_keywords, " ")

ps_individual_keywords <- sort(table(ps_individual_keywords), decreasing=TRUE)
te_individual_keywords <- sort(table(te_individual_keywords), decreasing=TRUE)
ls_individual_keywords <- sort(table(ls_individual_keywords), decreasing=TRUE)
ss_individual_keywords <- sort(table(ss_individual_keywords), decreasing=TRUE)

ps_individual_keywords <- names(ps_individual_keywords)
te_individual_keywords <- names(te_individual_keywords)
ls_individual_keywords <- names(ls_individual_keywords)
ss_individual_keywords <- names(ss_individual_keywords)

ps_individual_keywords <- ps_individual_keywords[-c(1)]
te_individual_keywords <- te_individual_keywords[-c(1)]
ls_individual_keywords <- ls_individual_keywords[-c(1)]
ss_individual_keywords <- ss_individual_keywords[-c(1)]
#ps_individual_keywords <- ps_individual_keywords[1:300]

gen_keyword_freq_table <- function(individual_keywords, df,
                                  keyword_colname = "bigrams",
                                  id_colname = "ID") {
  #individual_keywords <- unique(individual_keywords[[1]])
  out_freqs <- vector()
  for (i in seq_along(individual_keywords)) {
    print(paste0(i/length(individual_keywords), " is completed"))
    print(i)
    temp_freq <- length(unique(df[grepl(paste0(" ",individual_keywords[i], " "), df[[keyword_colname]], fixed = TRUE), id_colname]))
    if (i%%500 == 0) {
      print(paste0(individual_keywords[i], " ::: ", temp_freq))
    }
    out_freqs <- c(out_freqs, temp_freq)
  }
  names(out_freqs) <- individual_keywords
  return(out_freqs)
}

ps_individual_keywords <- gen_keyword_freq_table(ps_individual_keywords, ps_un_keyword_df)
te_individual_keywords <- gen_keyword_freq_table(te_individual_keywords, te_un_keyword_df)
ls_individual_keywords <- gen_keyword_freq_table(ls_individual_keywords, ls_un_keyword_df)
ss_individual_keywords <- gen_keyword_freq_table(ss_individual_keywords, ss_un_keyword_df)

# COuntinue running
ps_individual_keywords <- sort(ps_individual_keywords, decreasing = TRUE)
te_individual_keywords <- sort(te_individual_keywords, decreasing = TRUE)
ls_individual_keywords <- sort(ls_individual_keywords, decreasing = TRUE)
ss_individual_keywords <- sort(ss_individual_keywords, decreasing = TRUE)
head(ps_individual_keywords, 50)
head(te_individual_keywords, 50)
head(ls_individual_keywords, 50)
head(ss_individual_keywords, 50)

ps_individual_keywords <- as.table(ps_individual_keywords)
te_individual_keywords <- as.table(te_individual_keywords)
ls_individual_keywords <- as.table(ls_individual_keywords)
ss_individual_keywords <- as.table(ss_individual_keywords)

ps_keyword_table <- head(sort(ps_individual_keywords, decreasing = TRUE), 50)
te_keyword_table <- head(sort(te_individual_keywords, decreasing = TRUE), 50)
ls_keyword_table <- head(sort(ls_individual_keywords, decreasing = TRUE), 50)
ss_keyword_table <- head(sort(ss_individual_keywords, decreasing = TRUE), 50)
# ps_keyword_oty_df <- data.frame(keyword=names(ps_keyword_table), num_pub=ps_keyword_table)
ps_keyword_oty_df <- data.frame(keyword=names(ps_individual_keywords), num_pub=ps_individual_keywords)
te_keyword_oty_df <- data.frame(keyword=names(te_individual_keywords), num_pub=te_individual_keywords)
ls_keyword_oty_df <- data.frame(keyword=names(ls_individual_keywords), num_pub=ls_individual_keywords)
ss_keyword_oty_df <- data.frame(keyword=names(ss_individual_keywords), num_pub=ss_individual_keywords)

ps_keyword_oty_df <- ps_keyword_oty_df[order(ps_keyword_oty_df$num_pub.Freq, decreasing = TRUE), ]
te_keyword_oty_df <- te_keyword_oty_df[order(te_keyword_oty_df$num_pub.Freq, decreasing = TRUE), ]
ls_keyword_oty_df <- ls_keyword_oty_df[order(ls_keyword_oty_df$num_pub.Freq, decreasing = TRUE), ]
ss_keyword_oty_df <- ss_keyword_oty_df[order(ss_keyword_oty_df$num_pub.Freq, decreasing = TRUE), ]

rownames(ps_keyword_oty_df) <-  NULL
rownames(te_keyword_oty_df) <-  NULL
rownames(ls_keyword_oty_df) <-  NULL
rownames(ss_keyword_oty_df) <-  NULL

ps_keyword_oty_df <- ps_keyword_oty_df[,c(1,3)]
te_keyword_oty_df <- te_keyword_oty_df[,c(1,3)]
ls_keyword_oty_df <- ls_keyword_oty_df[,c(1,3)]
ss_keyword_oty_df <- ss_keyword_oty_df[,c(1,3)]

ps_keyword_oty_df <- ps_keyword_oty_df[1:100,]
te_keyword_oty_df <- te_keyword_oty_df[1:100,]
ls_keyword_oty_df <- ls_keyword_oty_df[1:100,]
ss_keyword_oty_df <- ss_keyword_oty_df[1:100,]

# Create the year columns
for (i in 2011:2020) {
  ps_keyword_oty_df[[paste0(i)]] <- 0
  te_keyword_oty_df[[paste0(i)]] <- 0
  ls_keyword_oty_df[[paste0(i)]] <- 0
  ss_keyword_oty_df[[paste0(i)]] <- 0
}

calc_oty_keyword_freq <- function(df,
                                  main_df,
                                  keyword_colname = "keyword",
                                  keyword_main_colname = "un_bigrams",
                                  ID_colname = "ID",
                                  year_colname = "PY") {
  for (i in seq_along(df[[keyword_colname]])) {
    print(paste0(i/nrow(df), " is completed"))
    key <- df[i, keyword_colname]
    print(key)
    for (j in 2011:2020) {
      #print(j)
      year_main_df <- main_df[main_df[[year_colname]] == j, ]
      #print(head(year_main_df))
      year_freq <- length(unique((as.vector(year_main_df[grepl(paste0(" ", key, " "), year_main_df[[keyword_main_colname]]), ID_colname])[[1]])))
      print(length(as.vector(year_main_df[grepl(paste0(" ", key, " "), year_main_df[[keyword_main_colname]]), ID_colname])[[1]]))
      df[i, as.character(j)] <- year_freq
    }
  }
  return(df)
}

ps_keyword_oty_df <- calc_oty_keyword_freq(ps_keyword_oty_df, ps_df)
te_keyword_oty_df <- calc_oty_keyword_freq(te_keyword_oty_df, te_df)
ls_keyword_oty_df <- calc_oty_keyword_freq(ls_keyword_oty_df, ls_df)
ss_keyword_oty_df <- calc_oty_keyword_freq(ss_keyword_oty_df, ss_df)

ps_keyword_oty_df_t <- data.frame(rep(0,10))
te_keyword_oty_df_t <- data.frame(rep(0,10))
ls_keyword_oty_df_t <- data.frame(rep(0,10))
ss_keyword_oty_df_t <- data.frame(rep(0,10))
for (i in seq_len(nrow(ps_keyword_oty_df))) {
  ps_keyword_oty_df_t <- cbind(ps_keyword_oty_df_t, matrix(as.vector(ps_keyword_oty_df[i, 3:12])))
  te_keyword_oty_df_t <- cbind(te_keyword_oty_df_t, matrix(as.vector(te_keyword_oty_df[i, 3:12])))
  ls_keyword_oty_df_t <- cbind(ls_keyword_oty_df_t, matrix(as.vector(ls_keyword_oty_df[i, 3:12])))
  ss_keyword_oty_df_t <- cbind(ss_keyword_oty_df_t, matrix(as.vector(ss_keyword_oty_df[i, 3:12])))
}
ps_keyword_oty_df_t <- ps_keyword_oty_df_t[,-c(1)] 
te_keyword_oty_df_t <- te_keyword_oty_df_t[,-c(1)] 
ls_keyword_oty_df_t <- ls_keyword_oty_df_t[,-c(1)] 
ss_keyword_oty_df_t <- ss_keyword_oty_df_t[,-c(1)] 

colnames(ps_keyword_oty_df_t) <- ps_keyword_oty_df$keyword 
colnames(te_keyword_oty_df_t) <- te_keyword_oty_df$keyword 
colnames(ls_keyword_oty_df_t) <- ls_keyword_oty_df$keyword 
colnames(ss_keyword_oty_df_t) <- ss_keyword_oty_df$keyword 

rownames(ps_keyword_oty_df_t) <- colnames(ps_keyword_oty_df)[3:12]
rownames(te_keyword_oty_df_t) <- colnames(te_keyword_oty_df)[3:12]
rownames(ls_keyword_oty_df_t) <- colnames(ls_keyword_oty_df)[3:12]
rownames(ss_keyword_oty_df_t) <- colnames(ss_keyword_oty_df)[3:12]

colnames(ps_keyword_oty_df_t)
colnames(te_keyword_oty_df_t)
colnames(ls_keyword_oty_df_t)
colnames(ss_keyword_oty_df_t)


saveRDS(ps_keyword_oty_df, "./01_data/07_domain_ngram/ps_keywod_oty_df.Rds")
saveRDS(te_keyword_oty_df, "./01_data/07_domain_ngram/te_keywod_oty_df.Rds")
saveRDS(ls_keyword_oty_df, "./01_data/07_domain_ngram/ls_keywod_oty_df.Rds")
saveRDS(ss_keyword_oty_df, "./01_data/07_domain_ngram/ss_keywod_oty_df.Rds")

formattable(ls_keyword_oty_df)

gen_domain_barplot <- function(df, color) {
  plot_ly( df[1:40,]
          ,y=~reorder(keyword,num_pub.Freq)
  ) %>% 
  add_trace(
          textfont=list(color="white")
          , type = 'bar'
          , x = ~num_pub.Freq
          , orientation = "h"
          , marker = list( color = color, line = list(color = 'rgb(8,48,107)',
                                  width = 1.5))
          ) %>% layout(
            xaxis = list(title = "Number of pub."),
            yaxis = list(side = 'left', 
                        title = '', 
                        showgrid = FALSE, 
                        zeroline = TRUE),
                        showlegend=FALSE)%>% 
            config(displaylogo = FALSE)%>% 
            config(displayModeBar = T) %>%
            layout(xaxis = list(title = "", tickangle = -45) )
}

ps_domain_barplot <- gen_domain_barplot(ps_keyword_oty_df, "#8DA0CB")
te_domain_barplot <- gen_domain_barplot(te_keyword_oty_df, "#66C2A5")
ls_domain_barplot <- gen_domain_barplot(ls_keyword_oty_df, "#FC8D62")
ss_domain_barplot <- gen_domain_barplot(ss_keyword_oty_df, "#E5C494")

gen_domain_lineplot <- function(df_t) {
  fig <- plot_ly(df_t[,1:12], type = 'scatter', mode = 'lines') 
  for (i in 1:12) {
    fig <- fig %>% 
      add_trace(x=rownames(df_t), y = df_t[, i], name=colnames(df_t)[i], mode = 'lines+markers') %>%
      layout(legend = list(x=0.1, y=0.9))
  }
  return(fig)
}

ps_domain_lineplot <- gen_domain_lineplot(ps_keyword_oty_df_t)
te_domain_lineplot <- gen_domain_lineplot(te_keyword_oty_df_t)
ls_domain_lineplot <- gen_domain_lineplot(ls_keyword_oty_df_t)
ss_domain_lineplot <- gen_domain_lineplot(ss_keyword_oty_df_t)



saveRDS(ps_domain_barplot, "./04_visualisation/06_ngrams/ps_domain_barplot.Rds")
saveRDS(te_domain_barplot, "./04_visualisation/06_ngrams/te_domain_barplot.Rds")
saveRDS(ls_domain_barplot, "./04_visualisation/06_ngrams/ls_domain_barplot.Rds")
saveRDS(ss_domain_barplot, "./04_visualisation/06_ngrams/ss_domain_barplot.Rds")

saveRDS(ps_domain_lineplot, "./04_visualisation/06_ngrams/ps_domain_lineplot.Rds")
saveRDS(te_domain_lineplot, "./04_visualisation/06_ngrams/te_domain_lineplot.Rds")
saveRDS(ls_domain_lineplot, "./04_visualisation/06_ngrams/ls_domain_lineplot.Rds")
saveRDS(ss_domain_lineplot, "./04_visualisation/06_ngrams/ss_domain_lineplot.Rds")


saveRDS(M_06_ex, "./01_data/02_bibliometrix/res_area_exp_07_ngrams.Rds")


# UZUN IS

ps_keyword_oty_df_t %>% tidyr::gather(colnames(ps_keyword_oty_df_t), -rownames(ps_keyword_oty_df_t))


transform(id = as.integer(factor(keyword)))
# Just further trials




ps_keyword_oty_df[1:20,]
new_keyword <- vector()
num_pub_oty <- vector()
year <- vector()
new_pub_freq <- vector()
for (i in seq_along(ps_keyword_oty_df$keyword)) {
  key <- ps_keyword_oty_df$keyword[i]
  new_keyword <- c(new_keyword, rep(key, 10))
  num_pub_oty <- c(num_pub_oty, as.vector(as.numeric( ps_keyword_oty_df[i, 3:12])))
  year <- c(year, colnames(ps_keyword_oty_df)[3:12])
  new_pub_freq <- c(new_pub_freq, rep(ps_keyword_oty_df[i, "num_pub.Freq"], 10))
}
test_df <- as.data.frame(cbind(year, new_keyword, num_pub_oty, new_pub_freq))
head(test_df)

fig <- plot_ly(ps_keyword_oty_df_t[,5:20], x=rownames(ps_keyword_oty_df_t), type = 'scatter', mode = 'lines') 
#fig <- plot_ly(ps_keyword_oty_df_t[,1:20], x=rownames(ps_keyword_oty_df_t), type = 'scatter',  mode = 'none', stackgroup = 'one', groupnorm = 'percent') 
for (i in 5:20) {
  fig <- fig %>% add_trace(y = ps_keyword_oty_df_t[, i],name=colnames(ps_keyword_oty_df_t)[i], mode = 'lines+markers') 
}
fig 

