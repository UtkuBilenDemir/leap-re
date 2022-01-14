library(reticulate)
library(plotly)
pd <- import("pandas")

cou_table <- pd$read_pickle("./01_data/0201_tables/02_country_table.pickle")

cou_table <- cou_table[order(cou_table$tot_pub, decreasing = TRUE),]
cou_table <- cou_table[1:15, c("au_off_names", "tot_pub", "au_regions")]

afr_cou_plot <- plot_ly( cou_table
        ,x=~reorder(au_off_names,tot_pub, showlegend=TRUE)
        ,textfont=list(color="white")
        , type = 'bar'
        , y = ~tot_pub
        , orientation = "v"
        ,color=~au_regions
        ,colors = c("#5EBB9F", "#B997AF", "#C9A38D","#E2BA56", "#939393")
        ,marker = list( line = list(color = 'rgb(8,48,107)',
                                  width = 1.5))

          ) %>% layout(
           xaxis = list(title = " ", tickangle = 305),
           yaxis = list(title = "Number of pub.",side = 'left', title = '', showgrid = FALSE, zeroline = TRUE))%>% 
           config(displaylogo = FALSE)%>% 
    config(displayModeBar = T)  %>% 
    layout(legend = list(x = 0.1, y = 0.9))
  
saveRDS(afr_cou_plot, "./04_visualisation/01_bar_graphs/02_regions/afr_cou_plot.Rds")


afr_cou_plot %>%
  config(
    toImageButtonOptions = list(
      format = "svg"
    )
  )
