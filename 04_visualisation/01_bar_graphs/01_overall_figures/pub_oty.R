## # Testing stacked barplot with line
## 
## library(canvasXpress)
##  vals = c(5,10,25,40,45,50,
##  + 95,80,75,70,55,40,
##  + 25,30,45,60,65,70)
##  vars = c("V1","V2","V3")
##  smps = c("S1","S2","S3","S4","S5","S6")
##  data = as.data.frame(matrix(vals, nrow = 4, ncol = 6, byrow = TRUE, dimnames = list(vars, smps)))
##  valx = c("Lev:1","Lev:2","Lev:3","Lev:1","Lev:2","Lev:3",
##   "Lev:A","Lev:B","Lev:A","Lev:B","Lev:A","Lev:B",
##   "Lev:X","Lev:X","Lev:Y","Lev:Y","Lev:Z","Lev:Z",
##  + 5,10,15,20,25,30,
##  + 8,16,24,32,40,48,
##  + 10,20,30,40,50,60)
##  varx = c("Factor1","Factor2","Factor3","Factor4","Factor5","Factor6")
##  datx = as.data.frame(matrix(valx, nrow = 6, ncol = 6, byrow = TRUE, dimnames = list(varx, smps)))
##  valz = c("Desc:1","Desc:2","Desc:3","Desc:4",
##   "Desc:A","Desc:B","Desc:A","Desc:B",
##   "Desc:X","Desc:X","Desc:Y","Desc:Y",
##  + 5,10,15,20,
##  + 8,16,24,32,
##  + 10,20,30,40)
##  smpz = c("Annt1","Annt2","Annt3","Annt4","Annt5","Annt6")
##  datz = as.data.frame(matrix(valz, nrow = 4, ncol = 6, byrow = FALSE, dimnames = list(vars, smpz)))
##  canvasXpress(
##    data = data,
##    smpAnnot = datx,
##    varAnnot = datz,
##    graphOrientation = "vertical",
##    graphType = "StackedLine",
##    lineThickness = 3,
##    lineType = "spline",
##    showDataValues = TRUE,
##    showTransition = FALSE,
##    smpTitle = "Collection of Samples",
##    smpTitleFontStyle = "italic",
##    subtitle = "Random Data",
##    theme = "CanvasXpress",
##    title = "Stacked-Line Graphs",
##    xAxis = list("V1","V2"),
##    xAxis2 = list("V3","V4")
##  )
## 
## 
## 
## data
## datx
## datz
## 
## 
## 
## 
## 
## library(canvasXpress)
## library(data.table)
## library(reticulate)
## 
## pd <- import("pandas")
## # Using deprecated df, change it
## M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0606_org_prop.pickle")
## 
## 
## library(plotly)
## 
## 
## 
## #####################################################

# Let's assume we are analysing ngrams for Cairo Univ.
M_06 <- read_pickle_file("./01_data/02_bibliometrix/0608_org_proper.pickle")

M_02 <- read.csv("./01_data/02_bibliometrix/02_bib_dataframe_noab.csv", sep="|")

colnames(M_02)


abs_rel_oty <- as.data.frame(cbind(c(2011:2020), c(1147,
                                    1398,
                                    1793,
                                    2347,
                                    2802,
                                    3392,
                                    3960,
                                    4525,
                                    4906,
                                    4835)))
colnames(abs_rel_oty) <- c("Year", "# of pub.")
abs_rel_oty["Relative growth"] <- abs_rel_oty$`# of pub.`/abs_rel_oty$`# of pub.`[1]
rownames(abs_rel_oty) <-  abs_rel_oty$Year

abs_rel_plt <- plot_ly( abs_rel_oty,
         textposition = 'auto'
         ,x=~Year
  ) %>% 
  add_trace(
          #, color= col_wachs[1]
          textfont=list(color="white")
          , xaxis=~Year
          , type = 'bar'
          , y = ~`# of pub.`
          , name = 'Number of pub.'
          , marker= list(color = "#924E3C")
          #, text = ~`# of pub.`
          ) %>%
    add_trace(y = ~`Relative growth`
  
          ,xaxis=~Year
    , name = 'Relative growth' 
    # , text = data$AT_copub, textposition = 'auto'
    # , color= col_wachs[2]
    , type = "scatter"
    , mode = "lines+markers"
    , yaxis = "y2"
    , line = list( width=3,color = '#C48919')
    , marker=list(color = '#C48919')
    ) %>% layout(
      #title = 'New York Wind and Temperature Measurements for September 1973',
           xaxis = list(~Year,title = ""),
           yaxis = list(side = 'left', title = '', showgrid = FALSE, zeroline = TRUE),
           yaxis2 = list(side = 'right', overlaying = "y", title = '', showgrid = FALSE, zeroline = FALSE)) %>% config(displaylogo = FALSE)%>% 
    config(displayModeBar = T) %>% 
    layout(legend = list(x = 0.1, y = 0.9))
  





saveRDS(abs_rel_plt, "./01_data/03_visualisations/abs_rel_plt.Rds")
