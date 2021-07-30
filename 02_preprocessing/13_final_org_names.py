#%% Final adjustments to org names
import pandas as pd

M_06 = pd.read_pickle("../01_data/02_bibliometrix/0608_org_proper.pickle")

#%%
M_06.loc[M_06["org_prop"] == "Chungbuk National University", "org_prop"] = "JeonBuk National University"

# Run the exploded dataframe once again to redefine org_names
# %%
