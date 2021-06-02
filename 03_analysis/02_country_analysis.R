M_05 <- readRDS(file = "01_data/02_bibliometrix/05_dataframe_seperated-aff_-_cou_cleaned.Rds")
rownames(M_05) <- c()

library(canvasXpress)
y=country_t[1:10]
canvasXpress(
  data=y,
  graphOrientation="vertical",
  graphType="Bar",
  showLegend=FALSE,
  smpLabelRotate=45,
  smpTitle="Samples",
  theme="CanvasXpress",
  title="Bar Graph Title",
  renderTo = "svg"
)

country <- as.data.frame(table(M_05$Country))
country

country_t <-  data.frame()
?data.frame
country_t <- rbind(country_t, country$Freq)
colnames(country_t) <- country$Var1
country_t <- sort(country_t, decreasing = TRUE)
rownames(country_t) <- "# of publications"

