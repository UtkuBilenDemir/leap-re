## M_04 <- read.csv(file = "01_data/02_bibliometrix/04_bib_dataframe_seperated-aff.csv")
M_04 <- readRDS(file = "01_data/02_bibliometrix/04_dataframe_seperated-aff.Rds")
rownames(M_04rds) <- c()

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

##################################################################
##                 Identify African Countries                 ##
##################################################################

african_countries <- c("NIGERIA"
,"ETHIOPIA"
,"EGYPT"
,"DEM REP CONGO" 
,"TANZANIA"
,"SOUTH AFRICA"
,"KENYA"
,"UGANDA"
,"ALGERIA"
,"SUDAN"
,"MOROCCO"
,"ANGOLA"
,"MOZAMBIQUE"
,"GHANA"
,"MADAGASCAR"
,"CAMEROON"
,"COTE IVOIRE"
,"NIGER"
,"BURKINA FASO"
,"MALI"
,"MALAWI"
,"ZAMBIA"
,"SENEGAL"
,"CHAD"
,"SOMALIA"
,"ZIMBABWE"
,"GUINEA"
,"GUINEA BISSAU"
,"EQUAT GUINEA"
,"RWANDA"
,"BENIN"
,"BURUNDI"
,"TUNISIA"
,"SOUTH SUDAN" ,"TOGO"
,"SIERRA LEONE"
,"LIBYA"
,"REP CONGO"
,"LIBERIA"
,"CENT AFR REPUBL"
,"MAURITANIA"
,"ERITREA"
,"NAMIBIA"
,"GAMBIA"
,"BOTSWANA"
,"GABON"
,"LESOTHO"
,"MAURITIUS"
,"ESWATINI"
,"DJIBOUTI"
,"COMOROS"
,"CAPE VERDE"
,"SAO TOME PRIN"
,"SEYCHELLES")

# Define if an African country
is_african <- ifelse(M_04$Country %in% african_countries, TRUE, FALSE )
M_04$African <- is_african

# Tag countries with unsd African regions
unsd_regions <- data.frame(row.names = african_countries, unsd_region = rep("", length(african_countries)) )
unsd <- c("Northern Africa", "Eastern Africa", "Middle Africa", "Southern Africa", "Western Africa" )

unsd_regions["ALGERIA",] <- unsd[1]
unsd_regions["EGYPT",] <- unsd[1]
unsd_regions["LIBYA",] <- unsd[1]
unsd_regions["MOROCCO",] <- unsd[1]
unsd_regions["SUDAN",] <- unsd[1]
unsd_regions["TUNISIA",] <- unsd[1]
unsd_regions["WESTERN SAHARA",] <- unsd[1]


unsd_regions["BURUNDI",] <- unsd[2]
unsd_regions["COMOROS",] <- unsd[2]
unsd_regions["DJIBOUTI",] <- unsd[2]
unsd_regions["ERITREA",] <- unsd[2]
unsd_regions["ETHIOPIA",] <- unsd[2]
unsd_regions["KENYA",] <- unsd[2]
unsd_regions["MADAGASCAR",] <- unsd[2]
unsd_regions["MALAWI",] <- unsd[2]
unsd_regions["MAURITIUS",] <- unsd[2]
unsd_regions["MAYOTTE",] <- unsd[2]
unsd_regions["MOZAMBIQUE",] <- unsd[2]
unsd_regions["REUNION",] <- unsd[2]
unsd_regions["RWANDA",] <- unsd[2]
unsd_regions["SEYCHELLES",] <- unsd[2]
unsd_regions["SOMALIA",] <- unsd[2]
unsd_regions["SOUTH SUDAN",] <- unsd[2]
unsd_regions["UGANDA",] <- unsd[2]
unsd_regions["TANZANIA",] <- unsd[2]
unsd_regions["ZAMBIA",] <- unsd[2]
unsd_regions["ZIMBABWE",] <- unsd[2]

unsd_regions["ANGOLA",] <- unsd[3]
unsd_regions["CAMEROON",] <- unsd[3]
unsd_regions["CENT AFR REPUBL",] <- unsd[3]
unsd_regions["CHAD",] <- unsd[3]
unsd_regions["REP CONGO",] <- unsd[3]
unsd_regions["DEM REP CONGO",] <- unsd[3]
unsd_regions["EQUAT GUINEA",] <- unsd[3]
unsd_regions["GABON",] <- unsd[3]
unsd_regions["SAO TOME PRIN",] <- unsd[3]


unsd_regions["BOTSWANA",] <- unsd[4]
unsd_regions["ESWATINI",] <- unsd[4]
unsd_regions["LESOTHO",] <- unsd[4]
unsd_regions["NAMIBIA",] <- unsd[4]
unsd_regions["SOUTH AFRICA",] <- unsd[4]



unsd_regions["BENIN",] <- unsd[5]
unsd_regions["BURKINA FASO",] <- unsd[5]
unsd_regions["CAPE VERDE",] <- unsd[5]
unsd_regions["COTE IVOIRE",] <- unsd[5]
unsd_regions["GAMBIA",] <- unsd[5]
unsd_regions["GHANA",] <- unsd[5]
unsd_regions["GUINEA",] <- unsd[5]
unsd_regions["GUINEA BISSAU",] <- unsd[5]
unsd_regions["LIBERIA",] <- unsd[5]
unsd_regions["MALI",] <- unsd[5]
unsd_regions["MAURITANIA",] <- unsd[5]
unsd_regions["NIGER",] <- unsd[5]
unsd_regions["NIGERIA",] <- unsd[5]
unsd_regions["SAINT HELENA",] <- unsd[5]
unsd_regions["SENEGAL",] <- unsd[5]
unsd_regions["SIERRA LEONE",] <- unsd[5]
unsd_regions["TOGO",] <- unsd[5]


UNSD_reg <- unsd_regions[M_04$Country, ]

M_04$UNSD_reg <- UNSD_reg


saveRDS(M_04, file = "01_data/02_bibliometrix/05_dataframe_seperated-aff_-_cou_cleaned.Rds")
saveRDS(unsd_regions, file = "01_data/02_bibliometrix/unsd_regions_dict.Rds")

# TODO: Decide which further variables will be cleaned next
# TODO: Consider openrefine (and its rrefine connection)