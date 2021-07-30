library(reticulate)
library(kableExtra)
library(formattable)
library(magrittr)
pd <- import("pandas")

M_06 <- pd$read_pickle("./01_data/02_bibliometrix/0608_org_proper.pickle")

# Create org df
cairo_df <- M_06[M_06$org_prop == "Cairo University", ]

# Unique res areas from the org
cairo_res_area_un <- str_split(cairo_df$res_area, ";") 
cairo_res_area_un <- unique(trimws(unlist(cairo_res_area_un)))

# Get the corresponding domains and pub freqs
cairo_domain <- rep("", length(cairo_res_area_un)) 
cairo_area <- rep("", length(cairo_res_area_un))
cairo_area_freq <- rep("", length(cairo_res_area_un))

for (i in seq_along(cairo_res_area_un)) {
    indexes <- which(sapply(cairo_res_area_un[i] , grepl, cairo_df$res_area))
    domain <-  unique(unlist(cairo_df[cairo_df$res_area == cairo_res_area_un[i], "res_domains"]))
    if (length(domain) == 0) {
        domain <- "na"
    }
    freq <- length(unique(cairo_df[indexes, "ID"]))
    cairo_domain[i] <- as.character(domain)
    cairo_area[i] <-  cairo_res_area_un[i]
    cairo_area_freq[i] <-  freq

}

cairo_table <- as.data.frame(cbind(cairo_domain, cairo_area, cairo_area_freq))
cairo_table$cairo_area_freq <-  as.numeric(cairo_table$cairo_area_freq)
rownames(cairo_table) <- c()
cairo_table <- cairo_table[order(cairo_table$cairo_area_freq, decreasing = TRUE),]

# Some of the res domains aren't defined
cairo_table[cairo_table$cairo_area == "Green & Sustainable Science & Technology" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Thermodynamics" , "cairo_domain" ] <- "Physical Sciences"
cairo_table[cairo_table$cairo_area == "Computer Science, Information Systems" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Instruments & Instrumentation" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Materials Science, Coatings & Films" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Engineering, Manufacturing" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Metallurgy & Metallurgical Engineering" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Biochemistry & Molecular Biology" , "cairo_domain" ] <- "Physical Sciences"
cairo_table[cairo_table$cairo_area == "Physics, Atomic, Molecular & Chemical" , "cairo_domain" ] <- "Physical Sciences"
cairo_table[cairo_table$cairo_area == "Engineering, Industrial" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Chemistry, Applied" , "cairo_domain" ] <- "Physical Sciences"
cairo_table[cairo_table$cairo_area == "Operations Research & Management Science" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Engineering, Multidisciplinary" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Marine & Freshwater Biology" , "cairo_domain" ] <- "Physical Sciences"
cairo_table[cairo_table$cairo_area == "Computer Science, Software Engineering" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Mechanics" , "cairo_domain" ] <- "Technology"
cairo_table[cairo_table$cairo_area == "Mathematics" , "cairo_domain" ] <- "Physical Sciences"
cairo_table[cairo_table$cairo_area == "Crystallography" , "cairo_domain" ] <- "Physical Sciences"


# Do we need to? Yes, we do
# Remove areas with fewer than 0.05% of the total pub
cairo_thresh <- length(unique(cairo_df$ID)) * 0.005
cairo_table$cairo_area_freq <- as.numeric(cairo_table$cairo_area_freq)
cairo_table <- cairo_table[!(cairo_table$cairo_area_freq < cairo_thresh), ]
cairo_table <- cairo_table[order(cairo_table$cairo_area_freq, decreasing = TRUE), ]
rownames(cairo_table) <- c()
formattable(cairo_table)

# Maybe??
## collapse(cairo_table, cairo_domain)
## 
## kbl(mtcars[1:10, 1:6], caption = "Group Rows") %>%
##   kable_paper("striped", full_width = F) %>%
##   pack_rows("Group 1", 4, 7) %>%
##   pack_rows("Group 2", 8, 10)



######################################## TEST
nrow(cairo_table)
length(cairo_domain)
length(cairo_area )
length(cairo_area_freq)
length(cairo_res_area_un)



# Engineering problem ---> Ditch the sole "Engineering", it is just a confusing extra level
cairo_table <- cairo_table[ -c(which(cairo_table$cairo_area == "Engineering")),]
## en_indexes <- sapply("Engineering", grepl, M_06$res_area)
## en_df <- M_06[en_indexes, ]
## strict_en_indexes <- en_df$res_area == "Engineering"
## en_df[strict_en_indexes, c("res_areas") ]
## which(strict_en_indexes)


library(plotly)

fig <- plot_ly(
  type="treemap",
  labels=c("Eve", "Cain", "Seth", "Enos", "Noam", "Abel", "Awan", "Enoch", "Azura"),
  parents=c("", "Eve", "Eve", "Seth", "Seth", "Eve", "Eve", "Awan", "Eve")
)
fig



# TESTS
library(plotly)

labels = c("Eve", "Cain", "Seth", "Enos", "Noam", "Abel", "Awan", "Enoch", "Azura")
parents = c("", "Eve", "Eve", "Seth", "Seth", "Eve", "Eve", "Awan", "Eve")

fig <- plot_ly(
  type='treemap',
  labels=labels,
  parents=parents,
  values= c(10, 14, 12, 10, 2, 6, 6, 1, 4),
  textinfo="label+value+percent parent+percent entry+percent root",
  domain=list(column=0))

fig <- fig %>% add_trace(
  type='treemap',
  branchvalues="total",
  labels=labels,
  parents=parents,
  values=c(65, 14, 12, 10, 2, 6, 6, 1, 4),
  textinfo="label+value+percent parent+percent entry",
  outsidetextfont=list(size=20, color= "darkblue"),
  marker=list(line= list(width=2)),
  pathbar=list(visible= FALSE),
  domain=list(column=1))

fig <- fig %>% layout(
  grid=list(columns=2, rows=1),
  margin=list(l=0, r=0, b=0, t=0))

fig

# domains and domain freqs

cairo_domains_un <- unlist(unique(cairo_table$cairo_domain))
cairo_domain_freq <- rep(0, length(cairo_domains_un))

for (i in seq_along(cairo_domains_un)) {
    cairo_domain_freq[i] <- length(unique(unlist(cairo_df["ID"][[1]])[which(lapply(cairo_domains_un[i], grepl, unlist(cairo_df$res_domains))[[1]])]))
}
cairo_ek <- as.data.frame(cbind(rep("", length(cairo_domains_un)), cairo_domains_un, cairo_domain_freq))
names(cairo_ek) <- names(cairo_table)
cairo_table <- rbind(cairo_table, cairo_ek)


fig <- plot_ly(
  type='treemap',
  branchvalues="total",
  tiling=list(packing="squarify"),
  labels=unlist(cairo_table$cairo_area),
  parents=unlist(cairo_table$cairo_domain),
  values= as.numeric(unlist(cairo_table$cairo_area_freq)),
  marker=list(line= list(width=2)),
  textfont=list(size=25),
  textinfo="label+value+percent parent+percent entry",
  domain=list(column=0),
  margin=list(l=0, r=0, b=0, t=0))
  
fig

 %>% layout(uniformtext=list(minsize=35
#, mode='hide'
))


unnest_tokens()
