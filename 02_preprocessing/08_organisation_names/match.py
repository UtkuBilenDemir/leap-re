#%% Outsourced micro methods for match_org_names

def remove_stopwords(text, stop_words):
    text_tokens = word_tokenize(text)
    tokens_without_sw = [word for word in text_tokens if not word in stop_words]
    return (" ").join(tokens_without_sw)

#%% Outsourced matching algorithm_1 for match_org_names
def match_names(name, name_to_match):
    return fuzz.token_sort_ratio(name, name_to_match)

# %%
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

# %%
if __name__ == "__main__":
    pass