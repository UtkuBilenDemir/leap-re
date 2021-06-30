# %%  This one is not well structured but corrects the issues with org name matching
import pandas as pd
import pyreadr
#%%
## M_06 = pd.read_pickle("../01_data/02_bibliometrix/0605_eu_au_regions.pickle")
#M_06_old
M_06 = pd.read_csv('../01_data/0688_org_oty.csv', low_memory=False)
# %%
## M_06 =  pyreadr.read_r('../01_data/02_bibliometrix/0607_org_oty.Rds') 

org_df = pd.read_csv("./08_organisation_names/0899_matched_org_df.csv")
org_df_2 = pd.read_pickle("./08_organisation_names/02_org_df.pickle")
# %% Check the matches of specific names

org_df_2.loc[org_df_2["match_name"] == "Constantine 1 University", ["Organisation", "Num_pub"]]


#%%
org_df_2.loc[org_df_2["Organisation"] == "USTHB", "match_name"] = "University of Sciences and Technology Houari Boumediene"
org_df_2.loc[org_df_2["Organisation"] == "CDER", "match_name"] = "Renewable Energy Development Center"
org_df_2.loc[org_df_2["Organisation"] == "CDERECOLE NATL INGENIEURS SFAX", "match_name"] = "Renewable Energy Development CenterUniversity of Sfax"
org_df_2.loc[org_df_2["Organisation"] == "NATL ENGN SCH SFAX", "match_name"] = "National Engineering School of Sfax"
org_df_2.loc[org_df_2["Organisation"] == "NATL SCH ENGINEERS SFAX", "match_name"] = "National Engineering School of Sfax"
org_df_2.loc[org_df_2["Organisation"] == "ENIS", "match_name"] = "National Engineering School of Sfax"
org_df_2.loc[org_df_2["Organisation"] == "FAC SCI SFAX", "match_name"] = "National Engineering School of Sfax"
org_df_2.loc[org_df_2["Organisation"] == "NATL ENGN SCH SFAX ENIS", "match_name"] = "National Engineering School of Sfax"
org_df_2.loc[org_df_2["Organisation"] == "NATL SCH ENGN", "match_name"] = "National Engineering School of Sfax"
org_df_2.loc[org_df_2["Organisation"] == "NATL SCH ENGINEERS", "match_name"] = "National Engineering School of Sfax"
org_df_2.loc[org_df_2["Organisation"] == "ENETCOM", "match_name"] = "National School of Electronics and Telecoms of Sfax"
org_df_2.loc[org_df_2["Organisation"] == "FAC SCI TUNIS", "match_name"] = "Tunis El Manar University"
org_df_2.loc[org_df_2["Organisation"] == "MENIA UNIV", "match_name"] = "Minia University"
org_df_2.loc[org_df_2["Organisation"] == "Mohammed V", "match_name"] = "Mohammed V University"
org_df_2.loc[org_df_2["Organisation"] == "UNIV HASSAN 2", "match_name"] = "University of Hassan II Casablanca"
org_df_2.loc[org_df_2["Organisation"] == "HASSAN II UNIV", "match_name"] = "University of Hassan II Casablanca"
org_df_2.loc[org_df_2["Organisation"] == "UNIV KASDI MERBAH", "match_name"] = "University of Ouargla"
org_df_2.loc[org_df_2["Organisation"] == "HADJ LAKHDAR UNIV", "match_name"] = "University of Batna"
org_df_2.loc[org_df_2["Organisation"] == "UNIV ORAN 1 AHMED BEN BELLA", "match_name"] = "École Nationale Polytechnique d'Oran"
org_df_2.loc[org_df_2["Organisation"] == "UNIV ORAN AHMED BEN BELLA", "match_name"] = "École Nationale Polytechnique d'Oran"
org_df_2.loc[org_df_2["Organisation"] == "UNIV MEDEA", "match_name"] = "University Yahia Fares of Medea"
org_df_2.loc[org_df_2["Organisation"] == "UNIV SETIF 1", "match_name"] = "University Ferhat Abbas of Setif"
org_df_2.loc[org_df_2["Organisation"] == "UNIV SET 1", "match_name"] = "University Ferhat Abbas of Setif"
org_df_2.loc[org_df_2["Organisation"] == "CNRS", "match_name"] = "CNRS"
org_df_2.loc[org_df_2["Organisation"] == "CNRS IRD MNHN UPMC", "match_name"] = "CNRS"
org_df_2.loc[org_df_2["Organisation"] == "CEA UVSQ CNRS", "match_name"] = "CNRS"
org_df_2.loc[org_df_2["Organisation"] == "UMR 7504 CNRS UDS", "match_name"] = "CNRS"
org_df_2.loc[org_df_2["Organisation"] == "ENSCM UMII CNRS", "match_name"] = "CNRS"
org_df_2.loc[org_df_2["Organisation"] == "UMR CNRS 5518", "match_name"] = "CNRS"
org_df_2.loc[org_df_2["Organisation"] == "PROMES CNRS", "match_name"] = "CNRS"
org_df_2.loc[org_df_2["Organisation"] == "UMR CNRS 6027", "match_name"] = "CNRS"
org_df_2.loc[org_df_2["Organisation"] == "IRD", "match_name"] = "IRD"
org_df_2.loc[org_df_2["Organisation"] == "IRD FRANCE NORD", "match_name"] = "IRD"
org_df_2.loc[org_df_2["Organisation"] == "INRA IRD CIRAD SUPAGRO", "match_name"] = "IRD"
org_df_2.loc[org_df_2["Organisation"] == "INRA IRD SUPAGRO", "match_name"] = "IRD"
org_df_2.loc[org_df_2["Organisation"] == "IRD NOUMEA", "match_name"] = "IRD"
org_df_2.loc[org_df_2["Organisation"] == "INST RECH DEV", "match_name"] = "IRD"
org_df_2.loc[org_df_2["Organisation"] == "INRA", "match_name"] = "INRA"
org_df_2.loc[org_df_2["Organisation"] == "CTR COOPERAT INT RECH AGRON DEV CIRAD", "match_name"] = "CGIAR"
org_df_2.loc[org_df_2["Organisation"] == "FAC SCI TUNIS", "match_name"] = "Tunis El Manar University"
org_df_2.loc[org_df_2["Organisation"] == "CIRAD", "match_name"] = "CIRAD"
org_df_2.loc[org_df_2["Organisation"] == "CTR COOPERAT INT RECH AGRON DEV CIRAD", "match_name"] = "CIRAD"
org_df_2.loc[org_df_2["Organisation"] == "FRENCH AGR RES CTR INT DEV CIRAD", "match_name"] = "CIRAD"
org_df_2.loc[org_df_2["Organisation"] == "INRAE", "match_name"] = "INRAE"
org_df_2.loc[org_df_2["Organisation"] == "CSIR", "match_name"] = "CSIR"
org_df_2.loc[org_df_2["Organisation"] == "UNIV LYON 1", "match_name"] = "Claude Bernard University Lyon 1"
org_df_2.loc[org_df_2["Organisation"] == "ASSET RES", "match_name"] = "ASSET Research"
org_df_2.loc[org_df_2["Organisation"] == "EDUC HLTH AFRICA", "match_name"] = "Education for Health Africa"
org_df_2.loc[org_df_2["Organisation"] == "INT INST TROP AGR", "match_name"] = "International Institute of Tropical Agriculture (IITA)"
org_df_2.loc[org_df_2["Organisation"] == "IITA HEADQUARTERS", "match_name"] = "International Institute of Tropical Agriculture (IITA)"
org_df_2.loc[org_df_2["Organisation"] == "AGR RES CTR", "match_name"] = "The Agricultural Research Council"
org_df_2.loc[org_df_2["Organisation"] == "ISRA", "match_name"] = "ISRA/CNRF"
org_df_2.loc[org_df_2["Organisation"] == "CNRF", "match_name"] = "ISRA/CNRF"
org_df_2.loc[org_df_2["Organisation"] == "CTR IRD ISRA", "match_name"] = "ISRA/CNRF"





# %%

# The difference should not be this vast
# %%

org_df_2.loc[org_df_2["Organisation"] == "CDER", "Country"]
# %%
len(org_df["Organisation"] )


# %%
test_df = org_df.groupby('match_name').agg(' | '.join)
test_df.to_csv("test_org_df.csv")
# %%
M_06["Organisation"]
# %%
org_freq = [None] * len(M_06["Organisation"])
for i, org in enumerate(M_06["Organisation"].unique()):
    print(i/len(M_06["Organisation"]))
    temp_indexes_bool = M_06["Organisation"] == org
    freq = len(M_06.loc[temp_indexes_bool, "ID"].unique())
    for j in [j for j,x in enumerate(temp_indexes_bool) if x ==True]:
        org_freq[j] = freq
# %%

M_06["org_freq"] = org_freq

# %%

M_06[["org_freq", "Organisation"]]
# %%
a = pd.DataFrame(org_df_2["aff_ID"][1]) -1
# %%
org_prop = [None] * len(M_06["Organisation"])
for i,x in enumerate(org_df_2["match_name"]):
    indexes = pd.DataFrame(org_df_2["aff_ID"][i]) -1
    for j in list(indexes["aff_ID"]):
        print(j)
        org_prop[j] = x


# %%
M_06["org_prop"] = org_prop
# %%

M_06[ "Organisation"] 
# %%
org_freq2 = [None] * len(M_06["Organisation"])
for i, org in enumerate(M_06["org_prop"].unique()):
    print(i/len(M_06["org_prop"]))
    temp_indexes_bool = M_06["org_prop"] == org
    freq = len(M_06.loc[temp_indexes_bool, "ID"].unique())
    for j in [j for j,x in enumerate(temp_indexes_bool) if x ==True]:
        org_freq2[j] = freq

org_freq2
# %%

M_06["org_freq_prop"] = org_freq2
# %%

temp_df = M_06[ ["org_prop", "org_freq_prop"] ]
# %%
temp_df = temp_df.sort_values(["org_freq_prop", "org_prop"], ascending=False)

# %%
what = zip(temp_df["org_prop"], temp_df["org_freq_prop"])


# %%
what = pd.unique(temp_df[['org_prop', 'org_freq_prop']].values.ravel('K'))
# %%
pd.DataFrame(what)
# %%
what2 = pd.concat([temp_df['org_prop'], temp_df['org_freq_prop']]).unique()
# %%
# %%
what2 = pd.DataFrame(["; ".join(i) for i in zip([str(a) for a in temp_df['org_prop']], [str(i) for i in temp_df['org_freq_prop']])])
# %%
what2 = pd.DataFrame(what2[0].unique())
# %% Normalize org countries | This one did not go well, loop back
## M_06.loc[M_06["org_prop"] == "International Institute of Tropical Agriculture (IITA)", "au_off_country"] = "Nigeria"
## M_06.loc[M_06["org_prop"] == "International Institute of Tropical Agriculture (IITA)", "au_region"] = "Nigeria"
## M_06.loc[M_06["org_prop"] == "CIRAD", "au_off_country"] = "France"
## M_06.loc[M_06["org_prop"] == "North-West University", "au_off_country"] = "South Africa"
## M_06.loc[M_06["org_prop"] == "World Agroforestry Centre", "au_off_country"] = "Kenya"
## M_06.loc[M_06["org_prop"] == "Center for International Forestry Research", "au_off_country"] = "Indonesia"
## M_06.loc[M_06["org_prop"] == "University of Nigeria", "au_off_country"] = "Nigeria"
## M_06.loc[M_06["org_prop"] == "International Crops Research Institute for the Semi-Arid Tropics", "au_off_country"] == "India"
## M_06.loc[M_06["org_prop"] == "The Agricultural Research Council", "au_off_country"] = "South Africa"
## M_06.loc[M_06["org_prop"] == "International Maize and Wheat Improvement Center", "au_off_country"] = "Mexico"
## M_06.loc[M_06["org_prop"] == "Centre of Biotechnology of Sfax", "au_off_country"] = "Tunisia"
## M_06.loc[M_06["org_prop"] == "CSIR", "au_off_country"] = "South Africa"
## M_06.loc[M_06["org_prop"] == "IRD", "au_off_country"] = "France"
## M_06.loc[M_06["org_prop"] == "Terres Univia", "au_off_country"] = "France"
## M_06.loc[M_06["org_prop"] == "University of Zambia", "au_off_country"] = "Zambia"

# %%

## M_06.loc[M_06["au_off_country"] == "South Africa", "Country":"org_relative"] = M_06.loc[M_06["au_off_country"] == "South Africa", "Country":"org_relative"].iloc[1,:]

# %%

## M_06.loc[M_06["au_off_country"] == "Nigeria", "au_regions"] = "Western Africa"
## M_06.loc[M_06["au_off_country"] == "France", "au_regions"] = M_06["au_regions"][92411]
## M_06.loc[M_06["au_off_country"] == "Kenya", "au_regions"] = "Eastern Africa"
## M_06.loc[M_06["au_off_country"] == "Indonesia", "au_regions"] = M_06["au_regions"][92411]
## M_06.loc[M_06["au_off_country"] == "India", "au_regions"] = M_06["au_regions"][92411]
## M_06.loc[M_06["au_off_country"] == "Mexico", "au_regions"] = M_06["au_regions"][92411]
## M_06.loc[M_06["au_off_country"] == "Tunisia", "au_regions"] = "Northern Africa"
## M_06.loc[M_06["au_off_country"] == "Zambia", "au_regions"] = "Southern Africa"
# %%

len(M_06.loc[M_06["Organisation"] == "CDER", "ID"].unique())
# %%

for i,x in enumerate(M_06["Organisation"]):
    if x == "MENIA UNIV":
        M_06.loc[i, "org_prop"] = "Minia University" 

# %%
org_df_2.to_csv("./08_organisation_names/02_org_df.csv")
org_df_2.to_pickle("./08_organisation_names/02_org_df.pickle")
# %%

# %%

M_06.to_csv("../01_data/02_bibliometrix/0608_org_proper.csv")
M_06.to_pickle("../01_data/02_bibliometrix/0608_org_proper.pickle")
# %%

org_df_2
# %%

# %%

# %%

# %%

# %%

# %%

# %%
sum(org_df_2["Num_pub"])
# %%

# %%

# %%

# %%

# %%

# %%
