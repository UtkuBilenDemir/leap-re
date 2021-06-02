library(canvasXpress)
library(data.table)
M_05 <- readRDS(file = "01_data/02_bibliometrix/05_dataframe_seperated-aff_-_cou_cleaned.Rds")
rownames(M_05) <- c()
# Following one is better because 1ID = 1Publication here
M_02 <- readRDS(file = "01_data/02_bibliometrix/02_bib_dataframe_noab.Rds")
rownames(M_02) <- c()

# Total number of publications
tot_pub <- length(unique(M_02$ID))
print(paste0("Total number of publications: ", as.character(tot_pub)))
sprintf("Total number of publications: %d", tot_pub)

# Absolute and relative growth over the years
abs_rel_oty <- as.data.frame(table(M_02$PY))
abs_rel_oty.cumul_sum <- cumsum(abs_rel_oty$Freq)
abs_rel_oty.cumul_growth <- abs_rel_oty.cumul_sum / nrow(abs_rel_oty)
abs_rel_oty$relative_growth <- abs_rel_oty.cumul_growth / abs_rel_oty.cumul_growth[1]

# We need to transpose the dataframe
t_abs_rel_oty <- transpose(abs_rel_oty)
colnames(t_abs_rel_oty) <- rownames(abs_rel_oty)
rownames(t_abs_rel_oty) <- colnames(abs_rel_oty)
colnames(t_abs_rel_oty) <- abs_rel_oty$Var1

abs_rel_plt <- canvasXpress(
  data = t_abs_rel_oty,
  ## smpAnnot = "Var1",
  ## varAnnot = datz,
  graphOrientation = "vertical",
  graphType = "BarLine",
  
  colorScheme = "Wall Street",
  ## legendColumns = 2,
  ## legendPosition = "bottom",
  lineThickness = 2,
  ## lineType = "spline",
  ## showTransition = FALSE,
  smpLabelRotate = 45,
  ## smpTitle = "Collection of Samples",
  ## subtitle = "Random Data",
  #theme = "CanvasXpress",
  title = "Absolute numbers and relative growth of RE-related publications from African countries between 2011-2020",
  xAxis = "Freq",
  xAxisTitle = "# of pub.",
  xAxis2 = "relative_growth",
  xAxis2Title = "(Cumulative) Relative growth ",
  ## xAxis2TickFormat = "%.0f T",
  ## xAxisTickFormat = "%.0f M"
  afterRender = list(
    list(
      "setDimensions",
      list(613,613,TRUE)
    ),
    list(
      "changeTheme",
      list("wallStreetJournal",NULL),
      list(),
      1622600413487
    )
  )
)


saveRDS(abs_rel_plt, file = "01_data/03_visualisations/abs_rel_plt.Rds")
