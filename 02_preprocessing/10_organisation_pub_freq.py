# %%  This one is not well structured but corrects the issues with org name matching
import pandas as pd

#%%
M_06 = pd.read_pickle("../01_data/02_bibliometrix/0605_eu_au_regions.pickle")

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
# %%

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

M_06.to_csv("../01_data/02_bibliometrix/0606_org_prop.csv")
M_06.to_pickle("../01_data/02_bibliometrix/0606_org_prop.pickle")
# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%
