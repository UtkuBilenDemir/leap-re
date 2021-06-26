# %%
import pandas as pd
import pyreadr
import pickle as cPickle

#%% TODO list
# Match country names with the Grid
# Inject a AU_regions column

# %% Read the latest df
M_06 = pyreadr.read_r('../../01_data/02_bibliometrix/0602_after_refine.RDS') # also works for RData
M_06 = M_06[None]


# %% Read GRID df
grid = pd.read_csv('../../01_data/05_org_names/grid.csv') 

# %% get unique grid and M_06 countries
grid_cou = grid["Country"].unique()
m_cou = M_06["Country_names"].unique()

# %% Create a dictionary and find out which ones are not included in grid
cou_dict = {x:x for x in m_cou}
not_in_grid = [x for x in m_cou if x not in grid_cou]

#%% Change respective entries in the dictionary
cou_dict[not_in_grid[0]] = "China"
cou_dict[not_in_grid[1]] = "Ivory Coast"
cou_dict[not_in_grid[2]] = "United Kingdom"
cou_dict[not_in_grid[3]] = "United States"
cou_dict[not_in_grid[4]] = "United Arab Emirates"
cou_dict[not_in_grid[5]] = "United Kingdom"
cou_dict[not_in_grid[6]] = "United Kingdom"
cou_dict[not_in_grid[7]] = "Sudan"
cou_dict[not_in_grid[8]] = "Bosnia and Herzegovina"
cou_dict[not_in_grid[9]] = "Democratic Republic of the Congo"
cou_dict[not_in_grid[10]] = "Trinidad and Tobago"
cou_dict[not_in_grid[11]] = "United Kingdom"
cou_dict[not_in_grid[13]] = "Republic of the Congo"
cou_dict[not_in_grid[14]] = "Czechia"
cou_dict[not_in_grid[16]] = "Central African Republic"
cou_dict[not_in_grid[21]] = "Sao Tome and Principe"
cou_dict[not_in_grid[22]] = "Cabo Verde"
cou_dict[not_in_grid[23]] = "Eswatini"
cou_dict[not_in_grid[24]] = "Equatorial Guinea"
cou_dict[not_in_grid[26]] = "North Macedonia"
cou_dict["S. Sudan"] = "South Sudan"
cou_dict['São Tomé and Principe'] = "Sao Tome and Principe"
cou_dict['W. Sahara'] = "W. Sahara"
cou_dict['Mayotte'] = 'Mayotte'
cou_dict['Reunion'] = 'Reunion'
cou_dict['Gabot'] ='Gabot'
cou_dict['Saint Helena'] = 'Saint Helena'
cou_dict['61'] = '61'

# %% Create a list with the dict
M_06["GRID_country_name"] = [cou_dict[x] for x in M_06["Country_names"]]


# %% Read org_df
org_df = pyreadr.read_r('../../01_data/0201_tables/country_table.Rds') # also works for RData
org_df = org_df[None]

# %% Create the same column also here
org_df["Grid_country_name"] = [cou_dict[x] for x in org_df["carto_names"]]

# %% Create a grid to au_off dictionary and create a column for the au off names in the df
grid_au_off_dict = {x:x for x in M_06["GRID_country_name"]}
for k,y in enumerate(org_df["Grid_country_name"]):
    grid_au_off_dict[y] = org_df["au_off_names"][k]

#%% 
M_06["au_off_country"] = M_06["GRID_country_name"]

for l, z in enumerate(M_06["au_off_country"]):
    if z in list(org_df["Grid_country_name"]):
        M_06.loc[l, "au_off_country"] = grid_au_off_dict[z]  

# %% save everything


with open(r"../../01_data/02_bibliometrix/0603_GRID_au-off_names.pickle", "wb") as output_file:
    cPickle.dump(M_06, output_file)
M_06.to_csv("../../01_data/02_bibliometrix/0603_GRID_au-off_names.csv")
# %%
with open(r"../../01_data/0201_tables/02_country_table.pickle", "wb") as output_file:
    cPickle.dump(org_df, output_file)
org_df.to_csv("../../01_data/0201_tables/02_country_table.csv")
# %%



# %% TEST CELL
org_df.loc[org_df["tot_pub"] < 40,]

# %%
sum(org_df["tot_pub"] < 40)
# %%
