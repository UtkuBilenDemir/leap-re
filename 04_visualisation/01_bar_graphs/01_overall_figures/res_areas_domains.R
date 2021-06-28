area_data <- readRDS("./04_visualisation/res_area_canvasdf.Rds")

area_data <- area_data[, order(as.numeric(area_data["# of pub.", ]), decreasing = TRUE)]

area_data_barplot <-  canvasXpress(
   data = area_data[,1:15 ],
   smpAnnot = area_data[,1:15 ],
   graphOrientation = "vertical",
   graphType = "Bar",
   showLegend = TRUE,
   colorBy = "Research Domains",
   smpLabelRotate = 45,
   smpTitle = "Samples",
   theme = "CanvasXpress",
   title = "Bar Graph Title",
   xAxisTitle = "Value"
 )
area_data_barplot


saveRDS(area_data_barplot, "./04_visualisation/01_bar_graphs/01_overall_figures/res_areas_barplot.Rds")
