library(reticulate)
library(dplyr)
library(plotly)
library(dplyr)


pd <- import("pandas")

M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0608_org_proper.pickle")
wos <- readRDS("./../bibliometry_module/00_data/research_areas/wos_dictionary.Rds")

# EXPLODED DATAFRAME
M_06_ex <- readRDS("./01_data/02_bibliometrix/res_area_exp_069999_res_oty.Rds")
colnames(M_06_ex)

# individual university dfs
cairo_df <- M_06_ex[M_06_ex$org_prop == "Cairo University",]
redec_df <- M_06_ex[M_06_ex$org_prop == "Renewable Energy Development Center",]
moham_df <- M_06_ex[M_06_ex$org_prop == "Mohammed V University",]
coven_df <- M_06_ex[M_06_ex$org_prop == "Covenant University",]
unini_df <- M_06_ex[M_06_ex$org_prop == "University of Nigeria",]
yaoun_df <- M_06_ex[M_06_ex$org_prop == "Université de Yaoundé I",]
addis_df <- M_06_ex[M_06_ex$org_prop == "Addis Ababa University",]
mekel_df <- M_06_ex[M_06_ex$org_prop == "Mekelle University",]
kwazu_df <- M_06_ex[M_06_ex$org_prop == "University of KwaZulu-Natal",]
capet_df <- M_06_ex[M_06_ex$org_prop == "University of Cape Town",]
stell_df <- M_06_ex[M_06_ex$org_prop == "Stellenbosch University",]

# unique ras
cairo_ra_un <- unique(cairo_df$res_areas)
redec_ra_un <- unique(redec_df$res_areas)
moham_ra_un <- unique(moham_df$res_areas)
coven_ra_un <- unique(coven_df$res_areas)
unini_ra_un <- unique(unini_df$res_areas)
yaoun_ra_un <- unique(yaoun_df$res_areas)
addis_ra_un <- unique(addis_df$res_areas)
mekel_ra_un <- unique(mekel_df$res_areas)
kwazu_ra_un <- unique(kwazu_df$res_areas)
capet_ra_un <- unique(capet_df$res_areas)
stell_ra_un <- unique(stell_df$res_areas)

# unique ra_freqs | DO WE NEED IT?
## cairo_ra_freq <- rep(0, length(cairo_ra_un))
gen_ra_freq <- function(df, ra_un) {
  ra_freq <- rep(0, length(ra_un))
  for (i in seq_along(ra_un)) {
    print(unlist(df[df$res_areas == ra_un[i], "ID"]))
    ra_freq[i] <- length(unique(unlist(df[df$res_areas == ra_un[i], "ID"])))
  }
  return(ra_freq)
}
# cairo_df
cairo_ra_freq <- gen_ra_freq(cairo_df, cairo_ra_un)
redec_ra_freq <- gen_ra_freq(redec_df, redec_ra_un)
moham_ra_freq <- gen_ra_freq(moham_df, moham_ra_un)
coven_ra_freq <- gen_ra_freq(coven_df, coven_ra_un)
unini_ra_freq <- gen_ra_freq(unini_df, unini_ra_un)
yaoun_ra_freq <- gen_ra_freq(yaoun_df, yaoun_ra_un)
addis_ra_freq <- gen_ra_freq(addis_df, addis_ra_un)
mekel_ra_freq <- gen_ra_freq(mekel_df, mekel_ra_un)
kwazu_ra_freq <- gen_ra_freq(kwazu_df, kwazu_ra_un)
capet_ra_freq <- gen_ra_freq(capet_df, capet_ra_un)
stell_ra_freq <- gen_ra_freq(stell_df, stell_ra_un)
# df of res areas and freqs
cairo_ra_df <- as.data.frame(cbind(cairo_ra_un, ra_freq=as.numeric(cairo_ra_freq)))
redec_ra_df <- as.data.frame(cbind(redec_ra_un, ra_freq=as.numeric(redec_ra_freq)))
moham_ra_df <- as.data.frame(cbind(moham_ra_un, ra_freq=as.numeric(moham_ra_freq)))
coven_ra_df <- as.data.frame(cbind(coven_ra_un, ra_freq=as.numeric(coven_ra_freq)))
unini_ra_df <- as.data.frame(cbind(unini_ra_un, ra_freq=as.numeric(unini_ra_freq)))
yaoun_ra_df <- as.data.frame(cbind(yaoun_ra_un, ra_freq=as.numeric(yaoun_ra_freq)))
addis_ra_df <- as.data.frame(cbind(addis_ra_un, ra_freq=as.numeric(addis_ra_freq)))
mekel_ra_df <- as.data.frame(cbind(mekel_ra_un, ra_freq=as.numeric(mekel_ra_freq)))
kwazu_ra_df <- as.data.frame(cbind(kwazu_ra_un, ra_freq=as.numeric(kwazu_ra_freq)))
capet_ra_df <- as.data.frame(cbind(capet_ra_un, ra_freq=as.numeric(capet_ra_freq)))
stell_ra_df <- as.data.frame(cbind(stell_ra_un, ra_freq=as.numeric(stell_ra_freq)))

# sort those
cairo_ra_df <- cairo_ra_df[order(as.numeric(cairo_ra_df$ra_freq), decreasing = TRUE), ]
redec_ra_df <- redec_ra_df[order(as.numeric(redec_ra_df$ra_freq), decreasing = TRUE), ]
moham_ra_df <- moham_ra_df[order(as.numeric(moham_ra_df$ra_freq), decreasing = TRUE), ]
coven_ra_df <- coven_ra_df[order(as.numeric(coven_ra_df$ra_freq), decreasing = TRUE), ]
unini_ra_df <- unini_ra_df[order(as.numeric(unini_ra_df$ra_freq), decreasing = TRUE), ]
yaoun_ra_df <- yaoun_ra_df[order(as.numeric(yaoun_ra_df$ra_freq), decreasing = TRUE), ]
addis_ra_df <- addis_ra_df[order(as.numeric(addis_ra_df$ra_freq), decreasing = TRUE), ]
mekel_ra_df <- mekel_ra_df[order(as.numeric(mekel_ra_df$ra_freq), decreasing = TRUE), ]
kwazu_ra_df <- kwazu_ra_df[order(as.numeric(kwazu_ra_df$ra_freq), decreasing = TRUE), ]
capet_ra_df <- capet_ra_df[order(as.numeric(capet_ra_df$ra_freq), decreasing = TRUE), ]
stell_ra_df <- stell_ra_df[order(as.numeric(stell_ra_df$ra_freq), decreasing = TRUE), ]

cairo_ra_df <- cairo_ra_df[1:5, ]
redec_ra_df <- redec_ra_df[1:5, ]
moham_ra_df <- moham_ra_df[1:5, ]
coven_ra_df <- coven_ra_df[1:5, ]
unini_ra_df <- unini_ra_df[1:5, ]
yaoun_ra_df <- yaoun_ra_df[1:5, ]
addis_ra_df <- addis_ra_df[1:5, ]
mekel_ra_df <- mekel_ra_df[1:5, ]
kwazu_ra_df <- kwazu_ra_df[1:5, ]
capet_ra_df <- capet_ra_df[1:5, ]
stell_ra_df <- stell_ra_df[1:5, ]

rownames(cairo_ra_df )<- c()
rownames(redec_ra_df )<- c()
rownames(moham_ra_df )<- c()
rownames(coven_ra_df )<- c()
rownames(unini_ra_df )<- c()
rownames(yaoun_ra_df )<- c()
rownames(addis_ra_df )<- c()
rownames(mekel_ra_df )<- c()
rownames(kwazu_ra_df )<- c()
rownames(capet_ra_df )<- c()
rownames(stell_ra_df )<- c()

gen_ra_oty <- function(df, res_name_un) {
  for(i in seq_along(res_name_un)){
    print(res_name_un[i])
    temp_indexes <- df$res_areas == res_name_un[i][[1]]
    temp_res_df <- df[temp_indexes, ]
    pub_freq <- length(unique(unlist(df[temp_indexes, "ID" ])))
    
    max_year_freq <- length(unique(temp_res_df$ID[temp_res_df$PY == max(df$PY)]))
    min_year_freq <- length(unique(temp_res_df$ID[temp_res_df$PY == min(df$PY)]))
    rel <- max_year_freq/min_year_freq
    #res_rel_pub[temp_indexes] <- rel
    
    # Also create columns with pub. frequencies in each year
    for(year in sort(unique(df$PY), decreasing = FALSE)){
      temp_df <- df[temp_indexes, ]
      temp_year_indexes <- temp_df$PY == year
      year_pub_freq <- length(unique(temp_df$ID[temp_year_indexes]))
      
      year_col_name <- paste0("res_area_pub_", year)
      df[[year_col_name]][temp_indexes] <- year_pub_freq
    }
  }
  return(df)
}

cairo_oty_df <- gen_ra_oty(cairo_df, cairo_ra_un)
redec_oty_df <- gen_ra_oty(redec_df, redec_ra_un)
moham_oty_df <- gen_ra_oty(moham_df, moham_ra_un)
coven_oty_df <- gen_ra_oty(coven_df, coven_ra_un)
unini_oty_df <- gen_ra_oty(unini_df, unini_ra_un)
yaoun_oty_df <- gen_ra_oty(yaoun_df, yaoun_ra_un)
addis_oty_df <- gen_ra_oty(addis_df, addis_ra_un)
mekel_oty_df <- gen_ra_oty(mekel_df, mekel_ra_un)
kwazu_oty_df <- gen_ra_oty(kwazu_df, kwazu_ra_un)
capet_oty_df <- gen_ra_oty(capet_df, capet_ra_un)
stell_oty_df <- gen_ra_oty(stell_df, stell_ra_un)

## test_df$res_area_pub_2019
cairo_df_adv <- as.data.frame(cairo_oty_df)
redec_df_adv <- as.data.frame(redec_oty_df)
moham_df_adv <- as.data.frame(moham_oty_df)
coven_df_adv <- as.data.frame(coven_oty_df)
unini_df_adv <- as.data.frame(unini_oty_df)
yaoun_df_adv <- as.data.frame(yaoun_oty_df)
addis_df_adv <- as.data.frame(addis_oty_df)
mekel_df_adv <- as.data.frame(mekel_oty_df)
kwazu_df_adv <- as.data.frame(kwazu_oty_df)
capet_df_adv <- as.data.frame(capet_oty_df)
stell_df_adv <- as.data.frame(stell_oty_df)

## colnames(cairo_df_adv)
# We need a proper df with variables being res areas

gen_org_ra_table <- function(df,df_adv, ra_un_colname) {
  out <- data.frame(Years=2011:2020)
  for (i in seq_along(unlist(df[ra_un_colname]))) {
    print(i)
    res_index <- which(df_adv$res_areas == df[i, ra_un_colname])[1]
    out <- cbind(out, as.numeric(df_adv[res_index, 118:127]) )
  }
  colnames(out)[2:ncol(out)] <- unlist(df[ra_un_colname])
  colnames(out)[1] <- "Years"
  return(out)
}

cairo_ra_table <- gen_org_ra_table(cairo_ra_df, cairo_df_adv, "cairo_ra_un")
redec_ra_table <- gen_org_ra_table(redec_ra_df, redec_df_adv, "redec_ra_un")
moham_ra_table <- gen_org_ra_table(moham_ra_df, moham_df_adv, "moham_ra_un")
coven_ra_table <- gen_org_ra_table(coven_ra_df, coven_df_adv, "coven_ra_un")
unini_ra_table <- gen_org_ra_table(unini_ra_df, unini_df_adv, "unini_ra_un")
yaoun_ra_table <- gen_org_ra_table(yaoun_ra_df, yaoun_df_adv, "yaoun_ra_un")
addis_ra_table <- gen_org_ra_table(addis_ra_df, addis_df_adv, "addis_ra_un")
mekel_ra_table <- gen_org_ra_table(mekel_ra_df, mekel_df_adv, "mekel_ra_un")
kwazu_ra_table <- gen_org_ra_table(kwazu_ra_df, kwazu_df_adv, "kwazu_ra_un")
capet_ra_table <- gen_org_ra_table(capet_ra_df, capet_df_adv, "capet_ra_un")
stell_ra_table <- gen_org_ra_table(stell_ra_df, stell_df_adv, "stell_ra_un")


cairo_ra_table

# Grouped barchart trial

library(plotly)
ifelse(moham_ra_table[,2]/moham_ra_table[1,2], moham_ra_table[,2]/moham_ra_table[2,2])

gen_grouped_barchart <- function(df, colrange = 3:6) {

  plt_col <- c("#80b1d3", "#fb8072", "#b3de69", "#fdb462", "#bc80bd")
  plot <- plot_ly(df, x=~Years, y=df[,2], type="bar", name=colnames(df)[2], color = plt_col[1], text = df[,2], textposition = 'outside', textfont = list(color="black") )
  line_plot <- plot_ly(df, x=~Years, y=df[,2]/df[1,2], name=colnames(df)[2], type="scatter", mode="lines+markers", line = list(width = 3), color = plt_col[1] , showlegend = FALSE)
  for (i in colrange ) {
    plot <- plot %>% add_trace(y=df[,i], name=colnames(df)[i], color = plt_col[i-1], text = df[,i])
    line_plot <- line_plot %>% add_trace(y=df[,i]/df[1,i], name=colnames(df)[i], mode="lines+markers", line = list(width = 3),color = plt_col[i-1])
  }
  plot <- plot %>% layout(barmode="group") 
  return(subplot(plot, line_plot, nrows=2, shareX = TRUE) %>% layout(legend = list(x = 0.05, y = 1, bgcolor= 'rgba(0,0,0,0)')))
}

cairo_ra_barline <- gen_grouped_barchart(cairo_ra_table)
redec_ra_barline <- gen_grouped_barchart(redec_ra_table)
moham_ra_barline <- gen_grouped_barchart(moham_ra_table)
coven_ra_barline <- gen_grouped_barchart(coven_ra_table)
unini_ra_barline <- gen_grouped_barchart(unini_ra_table)
yaoun_ra_barline <- gen_grouped_barchart(yaoun_ra_table)
addis_ra_barline <- gen_grouped_barchart(addis_ra_table)
mekel_ra_barline <- gen_grouped_barchart(mekel_ra_table)
kwazu_ra_barline <- gen_grouped_barchart(kwazu_ra_table)
capet_ra_barline <- gen_grouped_barchart(capet_ra_table)
stell_ra_barline <- gen_grouped_barchart(stell_ra_table)

saveRDS(cairo_ra_barline, "./04_visualisation/01_bar_graphs/02_regions/cairo_ra_barline.Rds")
saveRDS(redec_ra_barline, "./04_visualisation/01_bar_graphs/02_regions/redec_ra_barline.Rds")
saveRDS(moham_ra_barline, "./04_visualisation/01_bar_graphs/02_regions/moham_ra_barline.Rds")
saveRDS(coven_ra_barline, "./04_visualisation/01_bar_graphs/02_regions/coven_ra_barline.Rds")
saveRDS(unini_ra_barline, "./04_visualisation/01_bar_graphs/02_regions/unini_ra_barline.Rds")
saveRDS(yaoun_ra_barline, "./04_visualisation/01_bar_graphs/02_regions/yaoun_ra_barline.Rds")
saveRDS(addis_ra_barline, "./04_visualisation/01_bar_graphs/02_regions/addis_ra_barline.Rds")
saveRDS(mekel_ra_barline, "./04_visualisation/01_bar_graphs/02_regions/mekel_ra_barline.Rds")
saveRDS(kwazu_ra_barline, "./04_visualisation/01_bar_graphs/02_regions/kwazu_ra_barline.Rds")
saveRDS(capet_ra_barline, "./04_visualisation/01_bar_graphs/02_regions/capet_ra_barline.Rds")
saveRDS(stell_ra_barline, "./04_visualisation/01_bar_graphs/02_regions/stell_ra_barline.Rds")
