# %%
import pandas as pd
import pickle
from pandas.core.frame import DataFrame
import pyreadr

#%%
M_06 = pyreadr.read_r('../../../01_data/02_bibliometrix/0602_after_refine.RDS') # also works for RData
## M_06 = pd.read_csv('../../01_data/02_bibliometrix/0602_after_refine.csv')
M_06 = M_06[None]


# %%
def create_network(df, 
node_colname, 
ID_colname =  "ID", 
Tot_freq_colname="cou_tot_pub",
nodesID_colname="id",
nodesLab_colname="label",
nodesValue_colname="value",
edgesFrom_colname="from",
edgesTo_colname="to",
edgesValue_colname="value",
):
    edges = pd.DataFrame()
    nodes = pd.DataFrame()

    """A node dictionary with unique ids"""
    unique_nodes = list(df[node_colname].unique())
    node_id = list(range(len(unique_nodes)))
    node_dict = dict(zip(unique_nodes, node_id))
    # Add those also to the nodes

    """edge components:"""
    # Store from two edges in sets for now
    # in order to avoid same edges with diff. orders
    edges_fromto = list()
    edges_value = list()


    """Each unique ID to have its own reduced dataframe"""
    for p, x in enumerate(df[ID_colname].unique()):
        indexes_bool = df[ID_colname] == x
        id_df = df.loc[indexes_bool, :] 

        # print(f"{p/len(df[ID_colname].unique())} is completed")
        temp_nodes = id_df[node_colname].unique()
        """How many different nodes are in the id_df?"""
        if len(temp_nodes) > 1:
            # print(temp_nodes)
            # parse every node and create edges
            for i in range(len(temp_nodes)):
                for j in range(len(temp_nodes)):
                    temp_edge = {node_dict[temp_nodes[i]], node_dict[temp_nodes[j]]}
                    # Dont match it with itself
                    if len(temp_edge) == 1:
                        continue
                    # If pair already exist, increase the value
                    elif temp_edge in edges_fromto:
                        edges_value[[i for i,x in enumerate(edges_fromto) if x == temp_edge][0]] += 1
                    # If it doesn't exist yet, create an entry and assign a value
                    elif temp_edge not in edges_fromto:
                        edges_fromto.append(temp_edge)
                        edges_value.append(1)
    """Configure nodes and edges dfs"""
    nodes[nodesID_colname] = node_id
    nodes[nodesLab_colname] = unique_nodes
    # Optional but we can also enter frequencies to define node size
    temp_freq = list()
    df = df.reset_index(drop=True)
    for node in unique_nodes:
        # print(df.loc[[i for i,x in enumerate(df[node_colname]) if x == node],:])
        # temp_freq.append(df.loc[[i for i,x in enumerate((df[node_colname])) if x == node], Tot_freq_colname][0])
        node_indexes = df[node_colname] == node
        temp_freq.append(list(df.loc[node_indexes, Tot_freq_colname])[0])


    nodes[nodesValue_colname] = temp_freq

    edges[edgesFrom_colname] = [list(x)[0] for x in edges_fromto]
    edges[edgesTo_colname] = [list(x)[1] for x in edges_fromto]
    edges[edgesValue_colname] = edges_value

    return {
        "nodes": nodes,
        "edges": edges
    }



# %% create a df with publications that include at least one West African collab.
wa_indexes = M_06.loc[M_06["UNSD_reg"] == "Western Africa",]["ID"]

wa_df_indexes = list()
for i,x in enumerate(wa_indexes):
    print(x)
    wa_df_indexes.extend([j for j,y in enumerate(M_06["ID"]) if y == x])
#%%

wa_df = M_06.iloc[wa_df_indexes,].reset_index(drop=True)

# wa_df = M_06.loc[[i for i,x in enumerate(M_06["ID"]) if x in list(wa_indexes.unique())],]

# %%
test_net = create_network(wa_df, "Country_names")
# %%

test_net["nodes"].to_csv("./test_nodes.csv")
test_net["edges"].to_csv("./test_edges.csv")

# %%
# %%
