## M_04 <- read.csv(file = "01_data/02_bibliometrix/04_bib_dataframe_seperated-aff.csv")
M_04 <- readRDS(file = "01_data/02_bibliometrix/04_dataframe_seperated-aff.Rds")
rownames(M_02rds) <- c()

# USA appears to be always entered with state and zipcode infos,
# we don't need that
unique(M_04$Country)
usa_matched <- unlist(lapply("USA", grepl, M_04$Country))
M_04$Country[usa_matched] <- "USA"

# Drop every NA country without any meaningful affiliation
M_04$Affiliation[M_04$Country == ""]
M_04 <- M_04[-which(M_04$Country == ""), ]
M_04$Country[M_04$Country == "SCH BUSINESS MANAGEMENT"] <- "ENGLAND"
M_04$Affiliation[M_04$Country == "VEGETABLE RES DEPT"]
M_04 <- M_04[-which(M_04$Country == "VEGETABLE RES DEPT"), ]
M_04$Country[M_04$Country == "B P"] <- "ALGERIA"
M_04$Country[M_04$Country == "EL-BUHOUTH ST"] <- "EGYPT"
M_04 <- M_04[-which(M_04$Country == "CTRA"), ]
M_04 <- M_04[-which(M_04$Country == "AVDA"), ]


saveRDS(M_04, file = "01_data/02_bibliometrix/05_dataframe_seperated-aff_-_cou_cleaned.Rds")


# TODO: Decide which further variables will be cleaned next
# TODO: Consider openrefine (and its rrefine connection)