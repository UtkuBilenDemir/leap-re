# %%
import pickle
from match import *

# %%
import pandas as pd
M_06 = pd.read_pickle(r'../../01_data/02_bibliometrix/0603_GRID_au-off_names.pickle')
cou_table =  pd.read_pickle(r'../../01_data/0201_tables/02_country_table.pickle')

# %%
M_06["au_regions"] = None
african_indexes = [i for i,x in enumerate(M_06["African"]) if x == "True"]

# %%
for i in african_indexes:
    M_06.loc[i, "au_regions"] = cou_table.loc[M_06.loc[i, "Country"], "au_regions"]


# %%
with open(r"../../01_data/02_bibliometrix/0604_au_regions.pickle", "wb") as output_file:
    pickle.dump(M_06, output_file)
#%%
M_06.to_csv("../../01_data/02_bibliometrix/0604_au_regions.csv")

