# %%
import pandas as pd
import pickle
from pandas.core.frame import DataFrame
import pyreadr
import itertools

##### ! Caution, the method has been transferred to bibliometry_module

#%%
## M_06 = pyreadr.read_r('../../../01_data/02_bibliometrix/0602_after_refine.RDS') # also works for RData
## M_06 = pd.read_csv('../../01_data/02_bibliometrix/0602_after_refine.csv')
## M_06 = M_06[None]
M_06 = pd.read_pickle("../../../01_data/02_bibliometrix/0605_eu_au_regions.pickle")


# %%
def create_network(df, 
node_colname, 
ID_colname =  "ID", 
Tot_freq_colname="cou_tot_pub",
nodesID_colname="id",
nodesGroup_colname="group",
nodesLab_colname="label",
nodesValue_colname="value",
nodesTitle_colname="title",
edgesTitle_colname="title",
edgesFrom_colname="from",
edgesTo_colname="to",
edgesValue_colname="value",
region_colname="eu_au_region",
node_title="pub.",
edge_title="co-pub."
):
    edges = pd.DataFrame()
    nodes = pd.DataFrame()

    """A node dictionary with unique ids"""
    unique_nodes = list(df[node_colname].unique())
    node_id = list(range(len(unique_nodes)))
    node_group = list()
    for node in unique_nodes:
        index = [i for i,x in enumerate(df[node_colname]) if x == node][0]
        node_group.append(df.loc[index, region_colname])
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
        temp_nodes = id_df[node_colname].unique()
        
        """How many different nodes are in the id_df?"""
        if len(temp_nodes) > 1:
            # print(temp_nodes)
            # parse every node and create edges
            # create one iteration from each pair
            iter_list = itertools.combinations(list(range(len(temp_nodes))), 2)
            for i_tup in iter_list:
                temp_edge = {node_dict[temp_nodes[i_tup[0]]], node_dict[temp_nodes[i_tup[1]]]}
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
    nodes[nodesGroup_colname] = node_group
    nodes[nodesLab_colname] = unique_nodes
    # Optional but we can also enter frequencies to define node size
    temp_freq = list()
    temp_title = list()
    df = df.reset_index(drop=True)
    for node in unique_nodes:
        node_indexes = df[node_colname] == node
        freq = list(df.loc[node_indexes, Tot_freq_colname])[0]
        temp_freq.append(freq)
        temp_title.append(str(freq) + " " + node_title)

    nodes[nodesValue_colname] = temp_freq
    nodes[nodesTitle_colname] = temp_title

    edges[edgesFrom_colname] = [list(x)[0] for x in edges_fromto]
    edges[edgesTo_colname] = [list(x)[1] for x in edges_fromto]
    edges[edgesValue_colname] = edges_value
    edges[edgesTitle_colname] = [str(x) + " " + edge_title for x in edges_value]

    return {
        "nodes": nodes,
        "edges": edges
    }


# %%
na_df = pd.read_csv("../na_df.csv", low_memory=False)
# %% Apply method
na_net = create_network(na_df, "au_off_country")

na_net["nodes"].to_csv("../na_nodes.csv", index=False)
na_net["edges"].to_csv("../na_edges.csv", index=False)



# %%
