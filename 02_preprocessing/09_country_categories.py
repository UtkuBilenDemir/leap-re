# %% 
import pandas as pd

# %% 
M_06 = pd.read_pickle("../01_data/02_bibliometrix/0604_au_regions.pickle")
cou_table = pd.read_pickle("../01_data/0201_tables/02_country_table.pickle")
# %%
cou_dict = {i:j for i,j in zip(cou_table.index, cou_table["au_regions"] )}

# %%
cou_dict
# %%

eu27 = [
"BELGIUM",
"FRANCE",
"GERMANY",
"ITALY", 
"LUXEMBOURG",
"NETHERLANDS",
"DENMARK",
"IRELAND",
"GREECE",
"PORTUGAL",
"SPAIN",
"AUSTRIA",
"FINLAND",
"SWEDEN",
"CYPRUS",
"CZECH REPUBLIC",
"ESTONIA",
"HUNGARY",
"LATVIA",
"LITHUANIA",
"MALTA", 
"POLAND",
"SLOVAKIA",
"SLOVENIA",
"BULGARIA",
"ROMANIA",
"CROATIA"]

# %%
for cou in eu27:
    cou_dict[cou] = "EU-27"

# %% 
eu_au_region = list()
for cou in M_06["Country"]:
    try:
        eu_au_region.append(cou_dict[cou])
    except:
        eu_au_region.append("Other")
        
# %%
eu_au_region

# %%
M_06["eu_au_region"] = eu_au_region
M_06.to_pickle("../01_data/02_bibliometrix/0605_eu_au_regions.pickle")
# %%
