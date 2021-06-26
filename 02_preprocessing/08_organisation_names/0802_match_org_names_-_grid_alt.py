# %%
import pyreadr
import pandas as pd
from nltk.tokenize import word_tokenize
from fuzzywuzzy import fuzz

#%%
## M_06 = pyreadr.read_r('../../01_data/02_bibliometrix/0602_after_refine.RDS') # also works for RData
## M_06 = pd.read_csv('../../01_data/02_bibliometrix/0602_after_refine.csv')
## M_06 = M_06[None]
M_06 = pd.read_pickle(r'../../01_data/02_bibliometrix/0603_GRID_au-off_names.pickle')

# %%
grid = pd.read_csv('../../01_data/05_org_names/grid.csv') 
institutes = pd.read_csv('../../01_data/05_org_names/full_tables/institutes.csv') 
addresses = pd.read_csv('../../01_data/05_org_names/full_tables/addresses.csv') 
geonames = pd.read_csv('../../01_data/05_org_names/full_tables/geonames.csv') 
aliases = pd.read_csv('../../01_data/05_org_names/full_tables/aliases.csv') 
labels = pd.read_csv('../../01_data/05_org_names/full_tables/labels.csv')
acronyms = pd.read_csv('../../01_data/05_org_names/full_tables/acronyms.csv')
external_ids = pd.read_csv('../../01_data/05_org_names/full_tables/external_ids.csv')
links = pd.read_csv('../../01_data/05_org_names/full_tables/links.csv')
relationships = pd.read_csv('../../01_data/05_org_names/full_tables/relationships.csv')
types = pd.read_csv('../../01_data/05_org_names/full_tables/types.csv')
grid.head()

#%%
# Get the most common words
from collections import Counter
un_org_names = M_06["Organisation"].unique()
names_freq = Counter()
for name in un_org_names:
    names_freq.update(str(name).split(" "))
stop_words = [word for (word,_) in names_freq.most_common(45)]
print(stop_words)

# %% Create a df with unique org names
unique_country = list()
unique_prop_country = list()
unique_city = list()
org_pub_freq = list()
org_indexes = list()
for i,x in enumerate(un_org_names):
    print(f'{i}/{len(un_org_names)}')
    indexes = x == M_06["Organisation"]
    cou = M_06.loc[indexes, "Country"].unique()
    prop_cou = M_06.loc[indexes, "GRID_country_name"].unique()
    city = M_06.loc[indexes, "City"].unique()
    pub_freq = len(set(M_06.loc[indexes, "ID"]))
    unique_country.append(cou)
    unique_prop_country.append(prop_cou)
    unique_city.append(city)
    org_pub_freq.append(pub_freq)
    org_indexes.append(M_06.loc[indexes, "aff_ID"])

# %% Configure df with unique org_names
org_df = pd.DataFrame({
    "aff_ID": org_indexes,
    "Organisation": un_org_names,
    "City": unique_city,
    "Country": unique_country,
    "Country_prop": unique_prop_country,
    "Num_pub": org_pub_freq
})
# Do we need explosions?
## org_df = org_df.explode("Country_prop")
org_df.head(10)

# %% Find the single word org_names
# We don't want to match single words, it is messy
one_word_org_indexes, one_word_org = list(zip(*[(i,x) for i,x in enumerate(org_df["Organisation"]) if len(str(x).split(" ")) == 1]))
print(f"There are {len(one_word_org)} one word long org. names")
# Create a column for one word indication
org_df["Too_short"] = [True if x in one_word_org_indexes else False for x in org_df.index]

#%% Outsourced micro methods for match_org_names

def remove_stopwords(text, stop_words):
    text_tokens = word_tokenize(text)
    tokens_without_sw = [word for word in text_tokens if not word in stop_words]
    return (" ").join(tokens_without_sw)

#%% Outsourced matching algorithm_1 for match_org_names
def match_names(name, name_to_match):
    return fuzz.token_sort_ratio(name, name_to_match)


#%% Write a method for complete fuzzy match
# TODO: Turn it into class with all the other micro methods

def match_org_names(unique_org_df, 
                    org_name_db, 
                    stop_words=["UNIV"],
                    org_colname="Organisation",
                    cou_colname="Country",
                    cit_colname="City",
                    id_colname="ID",
                    match_method=match_names):
    # To be returned
    unmatched_countries = list()  # Catch unmatched country names between df and db
    unmatched_cities = list()  # Catch unmatched country names between df and db
    match_id_col = list()
    match_name_col = list()
    match_score_col = list()
    ## match_id_col2 = list()
    ## match_name_col2 = list()
    ## match_score_col2 = list()


    match_depth = [None] * len(org_name_db.index) # Country based level, city based level?
    for i, org in enumerate(unique_org_df[org_colname]):
        # TODO: Make sure Country and City names are matching between two dfs
        cou = unique_org_df.loc[i, cou_colname]
        city = unique_org_df.loc[i, cit_colname]
        print(f'\nIndex: {i}\nOrg. name: {org}\nCountry: {cou}\nCity{city}\n=====>')
        
        # Remove the stop_words from the org name?
        # Better try both
        # Yieldede better result without removing
        ## org = remove_stopwords(org, stop_words)
        
        # Create a reduced org database through country and city info
        if any(cou) in org_name_db[cou_colname]:
            # We are assuming the column names are the same
            # If not, why?
            cou_match_indexes = [i for i,x in enumerate(org_name_db[cou_colname]) if x in cou]
            cou_based_db = org_name_db.iloc[cou_match_indexes, :]
            match_depth[i] = "Country"
            org_name_db.loc[cou_match_indexes, cou_colname].unique()
        else:
            unmatched_countries.append(cou)
            print(f'\nCOUNTRY; {cou} do/does not have any matches in the database')
            cou_based_db = org_name_db
        
        # Even further, create a city based df
        # This one is trickier because the city names are a mess usually
        if any(city) in cou_based_db[cit_colname]:
            city_match_indexes = [i for i,x in enumerate(cou_based_db[cit_colname]) if x in city]
            # Don't name the following differently
            cou_based_db = cou_based_db.iloc[city_match_indexes, :]
            match_depth[i] = "City"
        else:
            unmatched_cities.append(city)
            print(f'\nCITY; {city} do/does not have any matches in the database')
            cou_based_db = cou_based_db
        cou_based_db = cou_based_db.reset_index(drop=True)
        # TODO: Outsource the matching method!
        # We want to try it with differnt modules 
        # Our match method to return (match_id, match_name, match_score)
        out_match_score = 0
        out_match_id = None
        out_match_name = None
        ## out_match_score2 = 0
        ## out_match_id2 = None
        ## out_match_name2 = None
        for j, db_org in enumerate(cou_based_db[org_colname]):
            match_score = match_method(org, db_org)
            # A slightly worse approach but let's see both
            ## matcher = hmni.Matcher(model='latin')
            ## match_score2 = matcher.similarity(org, db_org)
            if match_score > out_match_score:
                out_match_id = cou_based_db.loc[j, id_colname]
                out_match_name = db_org
                out_match_score = match_score
            ## if match_score2 > out_match_score2:
            ##     out_match_id2 = cou_based_db.loc[j, id_colname]
            ##     out_match_name2 = db_org
            ##     out_match_score2 = match_score2
        print(f'\n---MATCH!\nID: {out_match_id}\nName: {out_match_name}\nScore: {out_match_score}')
        # print(f'\n---MATCH2!\nID: {out_match_id2}\nName: {out_match_name2}\nScore: {out_match_score2}')
        print(f'Progress... {i/len(unique_org_df.index)}')
        match_id_col.append(out_match_id)       
        match_name_col.append(out_match_name)
        match_score_col.append(out_match_score)
        ## match_id_col2.append(out_match_id2)       
        ## match_name_col2.append(out_match_name2)
        ## match_score_col2.append(out_match_score2)
    unique_org_df["match_id"] = match_id_col
    unique_org_df["match_name"] = match_name_col
    unique_org_df["match_score"] = match_score_col
    ## unique_org_df["match_id2"] = match_id_col2
    ## unique_org_df["match_name2"] = match_name_col2
    ## unique_org_df["match_score2"] = match_score_col2
    return {"df": unique_org_df,
            "unmatched_cou": unmatched_countries,
            "unmatched_cit": unmatched_cities,
            "match_depth": match_depth}

# %% Edit colnames of the database accordingly
grid.columns = ['ID', 'Organisation', 'City', 'State', 'Country_prop']

# %% Test match_org_names

matched_org_df = match_org_names(org_df, grid, stop_words, cou_colname="Country_prop")

#%% TEST CELL

#len([i for i,x in enumerate(grid["Country"]) if x in org_df.loc[1,"Country_prop"]])

matched_org_df
## # %%
## ulti = (0, 0)
## for i,x in enumerate(grid["Organisation"]):
##     score = match_names("Amer Cairo", x)
##     if score > ulti[1]:
##         ulti = (i, score)
## 
## # %%
## # Performed worse but who knows
## ulti2 = (0, 0)
## for i,x in enumerate(grid["Organisation"]):
##     score = matcher.similarity(test_org.title(), x)
##     if score > ulti2[1]:
##         ulti2 = (i, score)


# %%

## M_06.to_csv('../../01_data/02_bibliometrix/0601_to_refine.csv')
# %%
import _pickle as cPickle
# %%
with open(r"./02_org_df.pickle", "wb") as output_file:
    cPickle.dump(org_df, output_file)
org_df.to_csv("02_org_df.csv")
# %%
with open(r"./08999_matched_org_df.pickle", "wb") as output_file:
    cPickle.dump(matched_org_df, output_file)
matched_org_df["df"].to_csv("./08999_matched_org_df.csv")

# %% Make script properly importable
def main():
    print("IMPORTED!")
# %%
if __name__ == "__main__":
    main()