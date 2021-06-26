# %%
import pickle
#%%
import pandas as pd
M_06 = pd.read_pickle("../../../../01_data/02_bibliometrix/0604_au_regions.pickle")

# %%
na_bool = M_06["au_regions"] == "Northern Africa"
# %%
na_indexes_un = list(M_06.loc[na_bool, "ID"].unique())
# %%
def gen_region_df(df, region, id_colname="ID", region_colname="au_regions"):
    out_indexes = list()
    region_bool = df[region_colname] == region
    region_indexes_un = list(df.loc[region_bool, id_colname].unique())
    for i,x in enumerate(df[id_colname]):
        print(i/len(df[id_colname]))
        if x in region_indexes_un:
            out_indexes.append(i)
    return out_indexes

# %% 
reg = list(M_06["au_regions"].unique())
reg.pop(1)



# %%
reg
for i, r in enumerate(reg):
    print(r)
    reg_indexes = gen_region_df(M_06, r)
    with open("".join(r.split(" ")) + ".pickle", "wb") as output_file:
        pickle.dump(reg_indexes, output_file)


# %%
reg_indexes
# %%
with open( "na.pickle", "wb") as output_file:
        pickle.dump(reg_indexes, output_file)


# %%
