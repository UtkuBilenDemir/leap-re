library(reticulate)
library(dplyr)
pd <- import("pandas")

M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0606_org_prop.pickle")
wos <- readRDS("./../bibliometry_module/00_data/research_areas/wos_dictionary.Rds")

library(canvasXpress)
 vals = c(67837,4676305,833285,7604467,559846,491775,21262641,9059651,5500510,313973000,4657542,16715999,33487208,8210281,2691158,5250275,82329758,306694,10414336,4203200,4798491,62262000,64057792,127078679,79218,4213418,7061200,388190,7233701,58126212,40525002,48508972,531640,28686633,2005692,10737428,10707924,727785,309156,405165,1310000,3971020,1299371,10211904,3418085,5463046,3494382,3555179,2231503,284589,40131,16601707,87476,38482919,40913584,9905596,85632,140041247,4489409,26814843,15399437,198739269,3360474,25715819,20796,76805524,650702,4253877,4017095,481267,111211789,1514993,1284264,22215421,4884887,45644023,90739,6310434,7204687,8238672,1338612970,9648533,672180,160267,1990876,72660,49052489,104574,31129225,396334,29546963,66429284,14573101,9650054,7379339,65905410,10640,2108665,34178188,6342948,2825928,2066718,944720,4613414,307899,3639453,6995655,64522,3041142,120898,10486339,219998,2967004,1859203,772298,7185218,4615807,240271522,45700395,1123913,97976603,21324791,429474,13276517,107434,218519,34859364,4550368,83082869,149229090,112850,9775246,4012809,1201542,4320748,691141,7792854,6057263,27606007,86967524,5891199,595613,25946220,11862740,212679,6834942,23832495,1166079220,20617068,176242949,23822783,18879301,2130819,39002772,3129486,48137741,5431747,156050883,7349145,13711597,14494293,10329208,10625176,41048532,8791832,12619600,9035536,752438,28563377,15746232,10473282,6440053,28400000,32369558,12666987,21669278,6019877,85237338,1533964,10057975,1782893,20653556,15306252,68692542,3441790,4511488,8988091,14268711)
 vars = c("population")
 smps = c("Bermuda","Norway","Qatar","Switzerland","Macao SAR, China","Luxembourg","Australia","Sweden","Denmark","United States","Singapore","Netherlands","Canada","Austria","Kuwait","Finland","Germany","Iceland","Belgium","Ireland","United Arab Emirates","United Kingdom","France","Japan","Andorra","New Zealand","Hong Kong SAR, China","Brunei Darussalam","Israel","Italy","Spain","Korea, Rep.","Cyprus","Saudi Arabia","Slovenia","Greece","Portugal","Bahrain","Bahamas, The","Malta","Trinidad and Tobago","Puerto Rico","Estonia","Czech Republic","Oman","Slovak Republic","Uruguay","Lithuania","Latvia","Barbados","St. Kitts and Nevis","Chile","Seychelles","Poland","Argentina","Hungary","Antigua and Barbuda","Russian Federation","Croatia","Venezuela, RB","Kazakhstan","Brazil","Panama","Malaysia","Palau","Turkey","Equatorial Guinea","Costa Rica","Lebanon","Suriname","Mexico","Gabon","Mauritius","Romania","Turkmenistan","Colombia","Grenada","Libya","Bulgaria","Azerbaijan","China","Belarus","Montenegro","St. Lucia","Botswana","Dominica","South Africa","St. Vincent and the Grenadines","Iraq","Maldives","Peru","Iran, Islamic Rep.","Ecuador","Dominican Republic","Serbia","Thailand","Tuvalu","Namibia","Algeria","Jordan","Jamaica","Macedonia, FYR","Fiji","Bosnia and Herzegovina","Belize","Albania","Paraguay","Marshall Islands","Mongolia","Tonga","Tunisia","Samoa","Armenia","Kosovo","Guyana","El Salvador","Georgia","Indonesia","Ukraine","Swaziland","Philippines","Sri Lanka","Cabo Verde","Guatemala","Micronesia, Fed. Sts.","Vanuatu","Morocco","West Bank and Gaza","Egypt, Arab Rep.","Nigeria","Kiribati","Bolivia","Congo, Rep.","Timor-Leste","Moldova","Bhutan","Honduras","Papua New Guinea","Uzbekistan","Vietnam","Nicaragua","Solomon Islands","Sudan","Zambia","Sao Tome and Principe","Lao PDR","Ghana","India","Cote d'Ivoire","Pakistan","Yemen, Rep.","Cameroon","Lesotho","Kenya","Mauritania","Myanmar","Kyrgyz Republic","Bangladesh","Tajikistan","Senegal","Cambodia","Chad","South Sudan","Tanzania","Benin","Zimbabwe","Haiti","Comoros","Nepal","Burkina Faso","Rwanda","Sierra Leone","Afghanistan","Uganda","Mali","Mozambique","Togo","Ethiopia","Guinea-Bissau","Guinea","Gambia, The","Madagascar","Niger","Congo, Dem. Rep.","Liberia","Central African Republic","Burundi","Malawi")
 data = as.data.frame(matrix(vals, nrow = 1, ncol = 188, byrow = TRUE, dimnames = list(vars, smps)))
 valx = c("BMU","NOR","QAT","CHE","MAC","LUX","AUS","SWE","DNK","USA","SGP","NLD","CAN","AUT","KWT","FIN","DEU","ISL","BEL","IRL","ARE","GBR","FRA","JPN","ADO","NZL","HKG","BRN","ISR","ITA","ESP","KOR","CYP","SAU","SVN","GRC","PRT","BHR","BHS","MLT","TTO","PRI","EST","CZE","OMN","SVK","URY","LTU","LVA","BRB","KNA","CHL","SYC","POL","ARG","HUN","ATG","RUS","HRV","VEN","KAZ","BRA","PAN","MYS","PLW","TUR","GNQ","CRI","LBN","SUR","MEX","GAB","MUS","ROU","TKM","COL","GRD","LBY","BGR","AZE","CHN","BLR","MNE","LCA","BWA","DMA","ZAF","VCT","IRQ","MDV","PER","IRN","ECU","DOM","SRB","THA","TUV","NAM","DZA","JOR","JAM","MKD","FJI","BIH","BLZ","ALB","PRY","MHL","MNG","TON","TUN","WSM","ARM","KSV","GUY","SLV","GEO","IDN","UKR","SWZ","PHL","LKA","CPV","GTM","FSM","VUT","MAR","WBG","EGY","NGA","KIR","BOL","COG","TMP","MDA","BTN","HND","PNG","UZB","VNM","NIC","SLB","SDN","ZMB","STP","LAO","GHA","IND","CIV","PAK","YEM","CMR","LSO","KEN","MRT","MMR","KGZ","BGD","TJK","SEN","KHM","TCD","SSD","TZA","BEN","ZWE","HTI","COM","NPL","BFA","RWA","SLE","AFG","UGA","MLI","MOZ","TGO","ETH","GNB","GIN","GMB","MDG","NER","COD","LBR","CAF","BDI","MWI",
 + "North America","Europe","Asia","Europe","Asia","Europe","Oceania","Europe","Europe","North America","Asia","Europe","North America","Europe","Asia","Europe","Europe","Europe","Europe","Europe","Asia","Europe","Europe","Asia","Europe","Oceania","Asia","Asia","Asia","Europe","Europe","Asia","Asia","Asia","Europe","Europe","Europe","Asia","North America","Europe","North America","North America","Europe","Europe","Asia","Europe","South America","Europe","Europe","North America","North America","South America","Seven seas","Europe","South America","Europe","North America","Europe","Europe","South America","Asia","South America","North America","Asia","Oceania","Asia","Africa","North America","Asia","South America","North America","Africa","Seven seas","Europe","Asia","South America","North America","Africa","Europe","Asia","Asia","Europe","Europe","North America","Africa","North America","Africa","North America","Asia","Seven seas","South America","Asia","South America","North America","Europe","Asia","Oceania","Africa","Africa","Asia","North America","Europe","Oceania","Europe","North America","Europe","South America","Oceania","Asia","Oceania","Africa","Oceania","Asia","Europe","South America","North America","Asia","Asia","Europe","Africa","Asia","Asia","Africa","North America","Oceania","Oceania","Africa","Asia","Africa","Africa","Oceania","South America","Africa","Asia","Europe","Asia","North America","Oceania","Asia","Asia","North America","Oceania","Africa","Africa","Africa","Asia","Africa","Asia","Africa","Asia","Asia","Africa","Africa","Africa","Africa","Asia","Asia","Asia","Asia","Africa","Asia","Africa","Africa","Africa","Africa","Africa","North America","Africa","Asia","Africa","Africa","Africa","Asia","Africa","Africa","Africa","Africa","Africa","Africa","Africa","Africa","Africa","Africa","Africa","Africa","Africa","Africa","Africa",
 + 106140,103630,92200,88120,76270,75990,64540,61610,61310,55200,55150,51890,51630,49670,49300,48420,47640,46350,47260,46550,44600,43430,42960,42000,43270,41070,40320,37320,35320,34270,29440,27090,26370,25140,23580,22680,21360,21060,20980,21000,20070,19310,19030,18370,16870,17750,16350,15430,15280,15310,14920,14910,14100,13690,13480,13340,13300,13220,12980,12500,11850,11530,11130,11120,11110,10830,10210,10120,10030,9950,9870,9720,9630,9520,8020,7970,7910,7820,7620,7590,7400,7340,7320,7260,7240,6930,6800,6610,6500,6410,6360,7120,6090,6040,5820,5780,5720,5630,5490,5160,5150,5150,4870,4760,4350,4450,4400,4390,4280,4260,4230,4060,4020,3990,3940,3920,3720,3630,3560,3550,3500,3460,3450,3430,3200,3160,3070,3060,3050,2970,2950,2870,2720,2680,2560,2370,2270,2240,2090,1890,1870,1830,1710,1680,1670,1660,1590,1570,1450,1400,1300,1350,1330,1290,1270,1270,1250,1080,1080,1050,1020,980,970,920,890,840,820,790,730,700,700,700,680,670,650,600,570,550,550,470,500,440,410,380,370,320,270,250,
 + 3,4,5,6,7,8,10,11,12,14,15,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194)
 varx = c("ISO3","continent","GNI","Id")
 datx = as.data.frame(matrix(valx, nrow = 4, ncol = 188, byrow = TRUE, dimnames = list(varx, smps)))
canvasXpress(
  data = data,
  smpAnnot = datx,
  colorBy = "GNI",
  decorations = list(
    marker = list(
      list(
        baseline = "middle",
        color = "red",
        x = 0.65,
        sample = "Norway",
        variable = "population",
        y = 0.7,
        align = "center",
        text = "Norway is the countrywith the largest GNIaccording to 2014 census"
      ),
      list(
        align = "center",
        text = "China is the country withthe largest populationaccording to 2014 census",
        y = 0.1,
        sample = "China",
        x = 0.15,
        variable = "population",
        baseline = "middle",
        color = "red"
      )
    )
  ),
  graphType = "Treemap",
  showDecorations = FALSE,
  showTransition = TRUE,
  theme = "CanvasXpress",
  title = "Population colored by Gross National Income 2014",
  afterRender = list(
    list(
      "setDimensions",
      list(613,613,TRUE)
    ),
    list(
      "groupSamples",
      list(
        list("continent"),
        "raw",
        NULL,
        NULL,
        NULL,
        NULL,
        NULL
      ),
      list(),
      1624817414852
    )
  )
)

simple_df  <- M_06[c("ID", "res_areas", "res_domains")]
head(simple_df)

explode(simple_df, "res_areas")
library(tidyr)
library(dplyr)   
simple_df_ex <- simple_df %>%
     separate_rows("res_areas", sep=";")

simple_df_ex_dom <- simple_df %>%
     separate_rows("res_domains", sep=";")

simple_df_ex$res_areas <- trimws(simple_df_ex$res_areas) 

colnames(wos) <- "domain"
simple_df_ex$res_domains <- wos[simple_df_ex$res_areas, "domain"]

colnames(simple_df_ex)

areas_un <- unique(simple_df_ex$res_areas)
areas_freq <- rep(0, length(areas_un))
for (i in seq_along(areas_un)) {
    indexes <- areas_un[i] == simple_df_ex$res_areas
    areas_freq[i] <- length(unique(simple_df_ex$ID[indexes]))
}

areas_un 
rm.50 <- areas_freq < 500 

areas_un <- areas_un[!rm.50]
areas_freq <- areas_freq[!rm.50]


area_data <- as.data.frame(matrix(areas_freq, nrow = 1, byrow = TRUE, dimnames = list("# of pub.", areas_un)))
area_data

area_datx <- as.data.frame(matrix(wos[areas_un, "domain"], nrow = 1, byrow = TRUE, dimnames = list("Research Domains", areas_un)))

names(area_data)
names(area_datx)

area_data["Research Domains", ] <- area_datx
saveRDS(area_data, "./04_visualisation/res_area_canvasdf.Rds")


 canvasXpress(
   data = area_data,
   smpAnnot = area_datx,
   colorBy = "Research Domains",
   ## decorations = list(
   ##   ## marker = list(
   ##   ##   list(
   ##   ##     baseline = "middle",
   ##   ##     color = "red",
   ##   ##     x = 0.65,
   ##   ##     sample = "Norway",
   ##   ##     variable = "population",
   ##   ##     y = 0.7,
   ##   ##     align = "center",
   ##   ##     text = "Norway is the countrywith the largest GNIaccording to 2014 census"
   ##   ##   ),
   ##   ##   list(
   ##   ##     align = "center",
   ##   ##     text = "China is the country withthe largest populationaccording to 2014 census",
   ##   ##     y = 0.1,
   ##   ##     sample = "China",
   ##   ##     x = 0.15,
   ##   ##     variable = "population",
   ##   ##     baseline = "middle",
   ##   ##     color = "red"
   ##   ##   )
   ##   ## )
   ## ),
   minTextSize = 1,
   fontSize=2,
   graphType = "Treemap",
   showDecorations = TRUE,
   showLegend =FALSE,
   showTransition = TRUE,
   theme = "CanvasXpress",
   title = "Population colored by Gross National Income 2014",
   afterRender = list(
     list(
       "setDimensions",
       list(1000,1000,TRUE)
     ),
     list(
       "groupSamples",
       list(
         list("Research Domains")
       )
       ##,
       ##list(),
       ##1624817414852
     )
   )
 )



library(plotly)

fig <- plot_ly(
  type="treemap",
  ## labels=c("Eve", "Cain", "Seth", "Enos", "Noam", "Abel", "Awan", "Enoch", "Azura"),
  labels=simple_df_ex$res_areas,
  parents=simple_df_ex$res_domains
)
fig

simple_df_ex















library(canvasXpress)
 vals = c(3.5,1.2,0.8,0.6,0.5,1.7,1.1,0.8,0.3,0.7,0.6,0.1,0.5,0.4,0.3)
 vars = c("Sales")
 smps = c("Sales1","Sales2","Sales3","Sales4","Sales5","Sales6","Sales7","Sales8","Sales9","Sales10","Sales11","Sales12","Sales13","Sales14","Sales15")
 data = as.data.frame(matrix(vals, nrow = 1, ncol = 15, byrow = TRUE, dimnames = list(vars, smps)))
 valx = c("1st","1st","1st","1st","1st","1st","2nd","2nd","2nd","3rd","3rd","3rd","4th","4th","4th",
 + "Jan","Feb","Feb","Feb","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec",
 + "","Week 1","Week 2","Week 3","Week 4","","","","","","","","","","",
 + "red","blue","green","grey","red","blue","green","grey","red","blue","green","grey","red","blue","green")
 varx = c("Quarter","Month","Week","Color")
 datx = as.data.frame(matrix(valx, nrow = 4, ncol = 15, byrow = TRUE, dimnames = list(varx, smps)))
 canvasXpress(
   data = data,
   smpAnnot = datx,
   circularArc = 360,
   circularRotate = 0,
   circularType = "sunburst",
   colorBy = "Mont",
   colorScheme = "Bootstrap",
   graphType = "Circular",
   hierarchy = list("Month"),
   showTransition = FALSE,
   title = "Simple Donnut",
   transitionStep = 50,
   transitionTime = 1500
 )

data
datx

domains_un <- unique(simple_df_ex$res_domains)
domains_freq <- rep(0, length(domains_un))
for (i in seq_along(domains_un)) {
    indexes <- domains_un[i] == simple_df_ex$res_domains
    domains_freq[i] <- length(unique(simple_df_ex$ID[indexes]))
}

domain_data <- as.data.frame(matrix(domains_freq, nrow = 1, byrow = TRUE, dimnames = list("# of pub.", domains_un)))
domain_data

domain_datx <- as.data.frame(matrix(domains_un, nrow = 1, byrow = TRUE, dimnames = list("Research Domains", domains_un)))


library(canvasXpress)
canvasXpress(
   data = domain_data,
   smpAnnot = domain_datx,
   ## circularArc = 360,
   ## circularRotate = 0,
   ## circularType = "sunburst",
   ## colorBy = "",
   colorScheme = "Bootstrap",
   graphType = "Circular",
   ## hierarchy = list("Month"),
   showTransition = FALSE,
   title = "Simple Donnut"
   ## transitionStep = 50,
   ## transitionTime = 1500
 )


library(treemap)
library(d3treeR)

# example 1 from ?treemap
data(GNI2010)
d3tree2(
   treemap(
     GNI2010
     ,index=c("continent", "iso3")
     ,vSize="population"
     ,vColor="GNI"
     ,type="value"
   )
   , rootname = "World"
)

?treemap





library(canvasXpress)
 vals = c(76.3,167.6,
 + 58.6,163.8,
 + 59.5,160,
 + 60.3,164.5,
 + 53.9,162.6,
 + 78.8,176,
 + 74.9,172.1,
 + 62.3,170.2,
 + 89.6,178,
 + 59.8,167,
 + 47.3,152.4,
 + 102.5,177.8)
 vars = c("Jax","Finley","Eloise","Elena","Ember","Owen","Ezra","Knox","Mateo","Charlie","Rosalie","Marcus")
 smps = c("Weight","Height")
 data = as.data.frame(matrix(vals, nrow = 12, ncol = 2, byrow = TRUE, dimnames = list(vars, smps)))
 valz = c(104.3,85.4,86.7,86.8,72.6,100,100,101.2,108.8,85.9,78,116.7,
 + 94.3,68.3,74.7,69.8,58,92,79.7,71.8,89.5,69.1,60.4,113.2,
 + 100.4,94,100,93.7,90.2,98,98.4,87.6,106,94.1,87,107.9,
 + 35,31,42,23,37,22,25,30,24,20,25,28,
 + "Male","Female","Female","Female","Female","Male","Male","Male","Male","Female","Female","Male",
 + "Moderate","Intense","Moderate","Intense","Low","Intense","Moderate","Moderate","Moderate","Low","Intense","Intense",
 + "Blond","Black","Black","Blond","Brown","Brown","Red","Blond","Blond","Brown","Brown","Red")
 smpz = c("Chest","Waist","Hip","Age","Gender","Exercise","Hair")
 datz = as.data.frame(matrix(valz, nrow = 12, ncol = 7, byrow = FALSE, dimnames = list(vars, smpz)))
 canvasXpress(
   data = data,
   varAnnot = datz,
   graphType = "Scatter2D",
   showTransition = FALSE,
   theme = "CanvasXpress",
   afterRender = list(
     list(
       "setDimensions",
       list(613,613,TRUE)
     ),
     list(
       "createDOE",
       list(NULL,NULL,NULL),
       list(),
       1624835630213
     )
   )
 )