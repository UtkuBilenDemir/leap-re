library(plotly)
library(reticulate)
library(dplyr)
pd <- import("pandas")

M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0608_org_proper.pickle")
M_06_old <- pd$read_pickle("./01_data/02_bibliometrix/0606_org_prop.pickle")
class(M_06)
# Create a column with organisaiton 
unique(M_06$org_prop)
colnames(M_06)

M_06$org_prop[which(lapply(M_06$org_prop, length) != 1)]

## org_name <- rep("", lengtH(unique(M_06$org_prop)))
## org_freq <- rep("", lengtH(unique(M_06$org_prop)))
## org_cou <- rep("", lengtH(unique(M_06$org_prop)))
M_06$org_prop <- unlist(M_06$org_prop)
org_df <- data.frame()
org_un <- unique(M_06$org_prop)
for (i in seq_along(org_un)) {
    print(unique(M_06$org_prop)[i])
    org_df <- rbind(org_df, M_06[M_06$org_prop == org_un[i][[1]], ][1, c("org_prop", "org_freq_prop", "au_off_country", "au_regions")])

    ## indexes <- unique(M_06$org_prop)[i][[1]] == M_06$org_prop
    ## org_name <- c(org_name, unique(M_06$org_prop)[i])
    ## org_freq <- c(org_freq, unlist(M_06$org_freq_prop)[indexes][1])
    ## org_cou <- c(org_cou, M_06$au_off_country[indexes][1][[1]][1])
}
head(org_df, 50)
org_df_so <- org_df[order(as.numeric(org_df$org_freq_prop), decreasing = TRUE),]

library(data.table)

org_df_so$org_prop <- as.vector(org_df_so$org_prop)
org_df_so$org_freq_prop <- as.vector(org_df_so$org_freq_prop)
org_df_so$au_off_country <- as.vector(org_df_so$au_off_country)


org_df_so_t <- as.data.frame(matrix(org_df_so$org_freq_prop, nrow = 1, byrow = TRUE, dimnames = list("# of pub.", org_df_so$org_prop)))

datx = as.data.frame(matrix(valx, nrow = 2, ncol = 8, byrow = TRUE, dimnames = list(varx, smps)))

org_df_so_t[2,] <-org_df_so$au_off_country
rownames(org_df_so_t)[2] <- "Country"
library(canvasXpress)
Country <- org_df_so_t["Country",1:15]
org_mv_barplot <-  canvasXpress(
   data = org_df_so_t[,1:15 ],
   smpAnnot = org_df_so_t[,1:15 ],
   graphOrientation = "horizontal",
   graphType = "Bar",
   showLegend = TRUE,
   colorBy = "Country",
   ## smpLabelRotate = 90,
   smpTitle = "Samples",
   theme = "CanvasXpress",
   title = "Bar Graph Title",
   xAxisTitle = "Value"
 )



saveRDS(org_df_so, "./01_data/0201_tables/org_freq_df.Rds")
saveRDS(org_mv_barplot, "./04_visualisation/01_bar_graphs/01_overall_figures/org_mv.Rds")

org_df_so$org_prop <- as.character(unlist(org_df_so$org_prop))
org_df_so_red <- org_df_so[1:15,]
org_df_so_red$org_prop <- unlist(org_df_so_red$org_prop)
org_df_so_red$org_prop[6] <- "Ren. En. Development Center"
org_df_so_red$org_freq_prop <- as.numeric(org_df_so_red$org_freq_prop)
org_df_so_red$org_prop <- factor(org_df_so_red$org_prop, levels = c(as.character(org_df_so_red$org_prop)))
org_df_so_red$au_off_country <- factor(org_df_so_red$au_off_country, levels = c(as.character(unique(org_df_so_red$au_off_country))))

org_mv_barplot <- plot_ly( org_df_so_red
         ,y=~reorder(org_prop,org_freq_prop)
  ) %>% 
  add_trace(
          #, color= col_wachs[1]
          textfont=list(color="white")
          , type = 'bar'
          , x = ~org_freq_prop
          , orientation = "h"
          #, name = 'Number of pub.'
          , color = ~au_off_country
          ,colors = "Set2"
          ,marker = list( line = list(color = 'rgb(8,48,107)',
                                  width = 1.5))
          #, marker= list(color = "#924E3C")
          #, text = ~`# of pub.`
          ) %>% layout(
      #title = 'New York Wind and Temperature Measurements for September 1973',
           xaxis = list(title = "Number of pub."),
           yaxis = list(side = 'left', title = '', showgrid = FALSE, zeroline = TRUE))%>% config(displaylogo = FALSE)%>% 
    config(displayModeBar = T)  %>% 
    layout(legend = list(x = 0.9, y = 0.1))
  



saveRDS(org_mv_barplot, "./04_visualisation/01_bar_graphs/01_overall_figures/org_mv_barplot.Rds")



