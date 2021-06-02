library(bannerCommenter)
M_05 <- readRDS(file = "01_data/02_bibliometrix/05_dataframe_seperated-aff_-_cou_cleaned.Rds")
unsd_regions <- readRDS(file = "01_data/02_bibliometrix/unsd_regions_dict.Rds")
rownames(M_05) <- c()

## country <- as.data.frame(table(M_05$Country[M_05$African]))
u_afr_cou <- unique(M_05$Country[M_05$African])
country_name <- rep(length(u_afr_cou))
pub <- rep(length(u_afr_cou))
unsd <- rep(length(u_afr_cou))
for(i in 1:length(u_afr_cou)){
  country_name[i] <- u_afr_cou[i]
  pub[i] <- length(unique(M_05$ID[M_05$Country == u_afr_cou[i]]))
  unsd[i] <- M_05$UNSD_reg[M_05$Country == u_afr_cou[i]][1]
}

country_data = as.data.frame(matrix(pub, nrow = 1, byrow = TRUE, dimnames = list("# of Publications", country_name)))
datx = as.data.frame(matrix(unsd, nrow = 1, byrow = TRUE, dimnames = list("UNSD Region", country_name)))
country_data_sorted <- sort(country_data, decreasing=TRUE)
datx_sorted <-  as.data.frame(matrix(unsd_regions[colnames(country_data_sorted),], nrow = 1, byrow = TRUE, dimnames = list("UNSD Region", colnames(country_data_sorted))))

afr_cou_plt <- canvasXpress(
  data = country_data_sorted[,1:15],
  smpAnnot = datx_sorted[,1:15],
  axisTitleFontStyle = "italic",
  smpLabelRotate = 30,
  colorBy = "UNSD Region",
  colorScheme = "canvasXpress",
  decorationScaleFontFactor = 1.3,
  graphOrientation = "vertical",
  graphType = "Bar",
  legendBox = TRUE,
  showFunctionNamesAfterRender = FALSE,
  title = "Most visible 15 African countries in RE-related                           \npublications between 2011-2020",
  xAxis2Show = FALSE,
  theme = "wallStreetJournal",
   legendPosition = "top-right"
  
)


saveRDS(afr_cou_plt, file = "01_data/03_visualisations/afr_cou_plt.Rds")
?canvasXpress
