library(reticulate)
library(dplyr)
library(plotly)
library(dplyr)


pd <- import("pandas")

M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0606_org_prop.pickle")
wos <- readRDS("./../bibliometry_module/00_data/research_areas/wos_dictionary.Rds")

# EXPLODED DATAFRAME
M_06_ex <- readRDS(M_06_ex, file = "./01_data/02_bibliometrix/res_area_exp_069999_res_oty.Rds")


# Followings are simpler approaches
simple_df  <- M_06[c("ID", "res_areas", "res_domains")]

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

area_data["Research Domains", ] <- area_datx
saveRDS(area_data, "./04_visualisation/res_area_canvasdf.Rds")



domains_un <- unique(simple_df_ex$res_domains)
domains_freq <- rep(0, length(domains_un))
for (i in seq_along(domains_un)) {
    indexes <- domains_un[i] == simple_df_ex$res_domains
    domains_freq[i] <- length(unique(simple_df_ex$ID[indexes]))
}

## domain_data <- as.data.frame(matrix(domains_freq, nrow = 1, byrow = TRUE, dimnames = list("# of pub.", domains_un)))
## domain_data



domains_df <- as.data.frame(cbind(res_domains = domains_un, num_pub=as.numeric(domains_freq)))
areas_df <- as.data.frame(cbind(res_areas = areas_un, num_pub=as.numeric(areas_freq)))

areas_df <- areas_df[order(as.numeric(areas_df$num_pub), decreasing = TRUE),]
rownames(areas_df) <- c()
# Remove NA row
domains_df <- domains_df[-c(4),]

indexes <- vector()
# Add oty
for (i in seq_along(areas_df["res_areas"][,1])) {
  ind <- which(as.vector(areas_df["res_areas"])[i,] == M_06_ex["res_areas"])[1]
  print(ind)
  indexes <- c(indexes, ind)
}
areas_df <- cbind(areas_df , M_06_ex[indexes, 118:128])


### Control if freqs ok --> dinally
sum(areas_df[1, 3:12])





domains_df$domain_colors <- c("#66c2a5", 
                              "#8da0cb",
                              "#fc8d62",
                              "#e5c494",
                              "#ffd92f" )

res_domains_pie <- domains_df %>% 
  plot_ly(labels = ~res_domains, values = ~num_pub,
  textinfo='percent+value',
  marker = list(colors = domains_df$domain_colors,
                      line = list(color='#000000', width=2)
                      )) %>% 
  add_pie(hole = 0.6)
res_domains_pie <- res_domains_pie %>% 
  layout(title = "",  showlegend = T)
res_domains_pie


fig2 <- plot_ly(
  y = areas_un,
  x = areas_freq,
  color=wos[areas_un, "domain"],
  type = "bar"
)

 # FOUND IT
fig <- domains_df %>%
    plot_ly(
    ## width = 800,
    ## height = 500
    ) %>%
  add_trace(labels = ~res_domains,
    values = ~num_pub,
    type="pie",
    domain = list(row = 1, column = 1)) %>% 
  add_trace(y = areas_un[1:5],
  x = areas_freq[1:5],
  color=wos[areas_un,][1:5],
  type = "bar",
  domain = list(row = 2, column = 1))  %>% layout(title = "test", showlegend = T,
                      grid=list(rows=2, columns=1),
                      xaxis = list(
                        ##showgrid = FALSE,
                        ## zeroline = FALSE, 
                        ## showticklabels = FALSE
                        ),
                      yaxis = list(
                        #showgrid = FALSE, 
                        #zeroline = FALSE, 
                        #showticklabels = FALSE)
                        ))

fig
areas_df <- as.data.frame(areas_df, stringsAsFactors = FALSE)

areas_df$num_pub <- as.numeric(areas_df$num_pub)
areas_df$res_areas <- factor(data$res_areas, levels = unique(areas_df$res_areas)[order(areas_df$num_pub, decreasing = TRUE)])

areas_df["res_domains"] <- wos[areas_df$res_areas, ]
areas_df["colors"] <-  NA
for (i in seq_along(areas_df$res_domains)) {
  areas_df[i, "colors"] <- domains_df$domain_colors[ domains_df$res_domains == areas_df$res_domains[i]]
}

areas_df
fig <- areas_df[1:10,] %>%
    plot_ly(
    ## width = 800,
    ## height = 500
    marker = list( line = list(color='#000000', width=2))
    ) %>%
  add_trace(x = ~res_areas,
    y = ~num_pub,
    type="bar",

    color=~res_domains,
    colors= c(
                              "#fc8d62",
                              "#8da0cb",
                              "#66c2a5" 
                              ),
    #domain = list(row = 1, column = 1)
    domain = list(row = 1, column = 1)
    ) %>%
layout(
     title = "",
     xaxis = list(title = "",
     categoryorder = "array",
     categoryarray = ~res_areas),
     yaxis =list(title="Number of publications"), shareY=F) 
for (i in 1:10) {
  fig <- fig %>% add_trace(transpose(areas_df),     
x = 2011:2020,
    y = transpose(areas_df)[3:12, i],
    name = areas_df$res_areas[i],
    type="scatter",
    mode="lines",
domain = list(row = 2, column = 1)
)

}
fig %>% layout(title = "test", showlegend = T,
                      grid=list(rows=2, columns=1),
                      shareY=FALSE,
                      xaxis = list(
                        ##showgrid = FALSE,
                        ## zeroline = FALSE, 
                        ## showticklabels = FALSE
                        ),
                      yaxis = list(
                        #showgrid = FALSE, 
                        #zeroline = FALSE, 
                        #showticklabels = FALSE)
                        ))

library(data.table)     
transpose(areas_df)     
   





saveRDS(res_domains_pie, "./04_visualisation/05_treemaps/res_domains_pie.Rds")

# GENERAL template
a <- areas_df[1:5,] %>% plot_ly %>% add_trace(x = ~res_areas,
    y = ~num_pub,
    type="bar",

    color=~res_domains,
    colors= c(
                              "#fc8d62",
                              "#8da0cb",
                              "#66c2a5" 
                              )
    #domain = list(row = 1, column = 1)
    )

b <- areas_df[1:5,] %>% plot_ly(showlegend = FALSE)

for (i in 1:5) {
  b <- b %>% add_trace(transpose(areas_df),     
x = 2011:2020,
    y = as.numeric(transpose(areas_df)[3:12, i]),
    name = areas_df$res_areas[i],
    type="scatter",
    mode="lines"
    )

}

b

test_res_areas_bar_line <- subplot(b,a, nrows=2, shareX = FALSE, shareY = FALSE)  %>% layout(legend = list(x = 0, y = 1))
saveRDS(test_res_areas_bar_line, "./04_visualisation/01_bar_graphs/01_overall_figures/test_res_areas_bar_line.Rds")






library(canvasXpress)
 vals = c(5,10,25,40,45,50,
 + 95,80,75,70,55,40,
 + 25,30,45,60,65,70,
 + 55,40,35,30,15,1)
 vars = c("V1","V2","V3","V4")
 smps = c("S1","S2","S3","S4","S5","S6")
 data = as.data.frame(matrix(vals, nrow = 4, ncol = 6, byrow = TRUE, dimnames = list(vars, smps)))
 valx = c("Lev:1","Lev:2","Lev:3","Lev:1","Lev:2","Lev:3",
  "Lev:A","Lev:B","Lev:A","Lev:B","Lev:A","Lev:B",
  "Lev:X","Lev:X","Lev:Y","Lev:Y","Lev:Z","Lev:Z",
 + 5,10,15,20,25,30,
 + 8,16,24,32,40,48,
 + 10,20,30,40,50,60)
 varx = c("Factor1","Factor2","Factor3","Factor4","Factor5","Factor6")
 datx = as.data.frame(matrix(valx, nrow = 6, ncol = 6, byrow = TRUE, dimnames = list(varx, smps)))
 valz = c("Desc:1","Desc:2","Desc:3","Desc:4",
  "Desc:A","Desc:B","Desc:A","Desc:B",
  "Desc:X","Desc:X","Desc:Y","Desc:Y",
 + 5,10,15,20,
 + 8,16,24,32,
 + 10,20,30,40)
 smpz = c("Annt1","Annt2","Annt3","Annt4","Annt5","Annt6")
 datz = as.data.frame(matrix(valz, nrow = 4, ncol = 6, byrow = FALSE, dimnames = list(vars, smpz)))
 canvasXpress(
   data = areas_df[, c(1, 3:12)],
   smpAnnot = areas_df[, c(1, 3:12)],
   varAnnot = datz,
   fontStyle = "bold italic",
   graphOrientation = "vertical",
   graphType = "Bar",
   legendFontStyle = "italic",
   plotByVariable = TRUE,
   smpLabelFontStyle = "italic",
   smpLabelInterval = 2,
   smpLabelRotate = 45,
   smpTitle = "Sample Title",
   theme = "CanvasXpress",
   title = "Random data set",
   xAxis2Show = FALSE
 )


library(plotly)
library(dplyr)

fig <- ggplot2::diamonds
fig <- fig %>% count(cut, clarity)
fig <- fig %>% plot_ly(x = ~cut, y = ~n, color = ~clarity)

fig




fig <- areas_df[1:5,]
## fig <- fig %>% count(cut, clarity)
fig <- fig %>% plot_ly(x = ~res_areas, y = areas_df[1:5,3:12], color = ~res_domains)

library(data.table)
data_t <- transpose(areas_df[1:5, c(1, 3:12)])
library(plotly)
colnames(data_t) <- data_t[1,]
data_t <- data_t[-c(1), ]
data_t <- cbind(years=2011:2020, data_t)
rownames(data_t) <- c()

x <- c(1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012)
roW <- c(219, 146, 112, 127, 124, 180, 236, 207, 236, 263, 350, 430, 474, 526, 488, 537, 500, 439)
China <- c(16, 13, 10, 11, 28, 37, 43, 55, 56, 88, 105, 156, 270, 299, 340, 403, 549, 499)
data <- data.frame(x, roW, China)

for (i in 1:ncol(data_t)) {
  data_t[,i] <- as.numeric(data_t[,i])
}


colnames(data_t)
fig <- plot_ly(data_t, x = ~years, y = ~`Energy & Fuels`, type = 'bar',
        marker = list(color = 'rgb(55, 83, 109)'))
fig <- fig %>% add_trace(y = ~`Engineering, Electrical & Electronic`, name = '', marker = list(color = 'rgb(26, 118, 255)'))

fig
as.numeric(data_t$`Energy & Fuels`)




fig <- plot_ly(data_t, type="bar")
for (i in 2:ncol(data_t)) {
  fig <- fig %>%
    add_trace(x=data_t["years"], y=data_t[,i], name=colnames(data_t)[i])
}
fig <- fig %>% add_trace(y = ~China, name = 'China', marker = list(color = 'rgb(26, 118, 255)'))
