# %%
import pandas as pd
import pickle
from pandas.core.frame import DataFrame
import pyreadr
import itertools

##### ! Caution, the method has been transferred to bibliometry_module

#%%
## M_06 = pyreadr.read_r('../../../01_data/02_bibliometrix/0607_org_oty.Rds') # also works for RData
## M_06 = pd.read_csv('../../../01_data/02_bibliometrix/0607_org_oty.csv', low_memory=False)
M_06 = pd.read_pickle("../../../01_data/02_bibliometrix/0608_org_proper.pickle")
## M_06 = M_06[None]
##M_06 = pd.read_pickle("../../../01_data/02_bibliometrix/0606_org_prop.pickle")



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
        ##index = [i for i,x in enumerate(df[node_colname]) if x == node][0]
        index = [i for i,x in enumerate(df[node_colname]) if x == node]
        print(index)
        if len(index)>1:
            index = index[0]
        node_group.append(df.loc[index, region_colname])
        print(df.loc[index, region_colname])
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
        print(node)
        ## freq = df.loc[node_indexes, Tot_freq_colname]
        # freq = list(df.loc[node_indexes, Tot_freq_colname])[0]
        freq = set(df.loc[node_indexes, Tot_freq_colname])
        # Freq in this cluster
        spec_freq = len(set(df.loc[node_indexes, ID_colname]))
        if len(freq)>1:
            freq = list(freq)[0]
        elif len(freq)>0:
            (freq,) = freq
        print(freq)
        temp_freq.append(spec_freq)
        temp_title.append(str(spec_freq) + " / " + str(freq) + " " + node_title)

    nodes[nodesValue_colname] = temp_freq
    nodes[nodesTitle_colname] = temp_title

    edges[edgesFrom_colname] = [list(x)[0] for x in edges_fromto]
    edges[edgesTo_colname] = [list(x)[1] for x in edges_fromto]
    edges[edgesValue_colname] = edges_value
    edges[edgesTitle_colname] = [str(x) + " " + edge_title for i,x in enumerate(edges_value)]

    return {
        "nodes": nodes,
        "edges": edges
    }


# %%
na_df = pd.read_csv("../../../01_data/0202_region_dfs/na_df.csv", low_memory=False)
wa_df = pd.read_csv("../../../01_data/0202_region_dfs/wa_df.csv", low_memory=False)
ca_df = pd.read_csv("../../../01_data/0202_region_dfs/ca_df.csv", low_memory=False)
ea_df = pd.read_csv("../../../01_data/0202_region_dfs/ea_df.csv", low_memory=False)
sa_df = pd.read_csv("../../../01_data/0202_region_dfs/sa_df.csv", low_memory=False)
# %% Apply method
na_net = create_network(na_df, "au_off_country")
wa_net = create_network(wa_df, "au_off_country")
ca_net = create_network(ca_df, "au_off_country")
ea_net = create_network(ea_df, "au_off_country")
sa_net = create_network(sa_df, "au_off_country")

na_net["nodes"].to_csv("../na_nodes.csv", index=False)
wa_net["nodes"].to_csv("../wa_nodes.csv", index=False)
ca_net["nodes"].to_csv("../ca_nodes.csv", index=False)
ea_net["nodes"].to_csv("../ea_nodes.csv", index=False)
sa_net["nodes"].to_csv("../sa_nodes.csv", index=False)

na_net["edges"].to_csv("../na_edges.csv", index=False)
wa_net["edges"].to_csv("../wa_edges.csv", index=False)
ca_net["edges"].to_csv("../ca_edges.csv", index=False)
ea_net["edges"].to_csv("../ea_edges.csv", index=False)
sa_net["edges"].to_csv("../sa_edges.csv", index=False)

# %%
na_net

# %% Country networks
egypt_df = pd.read_csv("../../../01_data/0203_country_dfs/egypt_df.csv", low_memory=False)
morocco_df = pd.read_csv("../../../01_data/0203_country_dfs/morocco_df.csv", low_memory=False)
algeria_df = pd.read_csv("../../../01_data/0203_country_dfs/algeria_df.csv", low_memory=False)
# %%
eg_mor_alg_df = pd.read_csv("../../../01_data/0203_country_dfs/eg_mor_alg_df.csv", low_memory=False)
# %%
nigeria_df = pd.read_csv("../../../01_data/0203_country_dfs/nigeria_df.csv", low_memory=False)
ghana_df = pd.read_csv("../../../01_data/0203_country_dfs/ghana_df.csv", low_memory=False)
senegal_df = pd.read_csv("../../../01_data/0203_country_dfs/senegal_df.csv", low_memory=False)
sen_gha_ni_df = pd.read_csv("../../../01_data/0203_country_dfs/sen_gha_ni_df.csv", low_memory=False)
eth_ken_tan_df = pd.read_csv("../../../01_data/0203_country_dfs/eth_ken_tan_df.csv", low_memory=False)
con_cam_gab_df = pd.read_csv("../../../01_data/0203_country_dfs/con_cam_gab_df.csv", low_memory=False)
west_east_central_df = pd.read_csv("../../../01_data/0203_country_dfs/west_east_central_df.csv", low_memory=False)

cameroon_df = pd.read_csv("../../../01_data/0203_country_dfs/cameroon_df.csv", low_memory=False)
demrepcongo_df = pd.read_csv("../../../01_data/0203_country_dfs/demrepcongo_df.csv", low_memory=False)
ethiopia_df = pd.read_csv("../../../01_data/0203_country_dfs/ethiopia_df.csv", low_memory=False)
kenya_df = pd.read_csv("../../../01_data/0203_country_dfs/kenya_df.csv", low_memory=False)
tanzania_df = pd.read_csv("../../../01_data/0203_country_dfs/tanzania_df.csv", low_memory=False)
sa_df = pd.read_csv("../../../01_data/0203_country_dfs/sa_df.csv", low_memory=False)
zimbabwe_df = pd.read_csv("../../../01_data/0203_country_dfs/zimbabwe_df.csv", low_memory=False)
##egypt_df["org_prop"] = str(egypt_df["org_prop"])
## egypt_df["org_prop"] = egypt_df["org_prop"].fillna(" ").isna()
egypt_df["org_freq_prop"] = [int(i) for i in egypt_df["org_freq_prop"].fillna(0)]
morocco_df["org_freq_prop"] = [int(i) for i in morocco_df["org_freq_prop"].fillna(0)]
algeria_df["org_freq_prop"] = [int(i) for i in algeria_df["org_freq_prop"].fillna(0)]
nigeria_df["org_freq_prop"] = [int(i) for i in nigeria_df["org_freq_prop"].fillna(0)]
ghana_df["org_freq_prop"] = [int(i) for i in ghana_df["org_freq_prop"].fillna(0)]
senegal_df["org_freq_prop"] = [int(i) for i in senegal_df["org_freq_prop"].fillna(0)]
sen_gha_ni_df["org_freq_prop"] = [int(i) for i in sen_gha_ni_df["org_freq_prop"].fillna(0)]
eth_ken_tan_df["org_freq_prop"] = [int(i) for i in eth_ken_tan_df["org_freq_prop"].fillna(0)]
con_cam_gab_df["org_freq_prop"] = [int(i) for i in con_cam_gab_df["org_freq_prop"].fillna(0)]
west_east_central_df["org_freq_prop"] = [int(i) for i in west_east_central_df["org_freq_prop"].fillna(0)]

cameroon_df["org_freq_prop"] = [int(i) for i in cameroon_df["org_freq_prop"].fillna(0)]
demrepcongo_df["org_freq_prop"] = [int(i) for i in demrepcongo_df["org_freq_prop"].fillna(0)]
ethiopia_df["org_freq_prop"] = [int(i) for i in ethiopia_df["org_freq_prop"].fillna(0)]
kenya_df["org_freq_prop"] = [int(i) for i in kenya_df["org_freq_prop"].fillna(0)]
tanzania_df["org_freq_prop"] = [int(i) for i in tanzania_df["org_freq_prop"].fillna(0)]
sa_df["org_freq_prop"] = [int(i) for i in sa_df["org_freq_prop"].fillna(0)]
zimbabwe_df["org_freq_prop"] = [int(i) for i in zimbabwe_df["org_freq_prop"].fillna(0)]
# %% 


# %%

egypt_net = create_network(      egypt_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
morocco_net = create_network(    morocco_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
algeria_net = create_network(    algeria_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
# %%
eg_mor_alg_net = create_network(    eg_mor_alg_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
# %%
nigeria_net = create_network(    nigeria_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
ghana_net = create_network(      ghana_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
senegal_net = create_network(    senegal_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
# %%
sen_gha_ni_net = create_network(    sen_gha_ni_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
eth_ken_tan_net = create_network(    eth_ken_tan_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
con_cam_gab_net = create_network(    con_cam_gab_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
west_east_central_net = create_network(    west_east_central_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
#%%

cameroon_net = create_network(   cameroon_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
demrepcongo_net = create_network(demrepcongo_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
ethiopia_net = create_network(   ethiopia_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
kenya_net = create_network(      kenya_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
tanzania_net = create_network(   tanzania_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
sa_net = create_network(         sa_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")
zimbabwe_net = create_network(   zimbabwe_df, "org_prop", Tot_freq_colname="org_freq_prop",region_colname="au_off_country")

# %%
egypt_net["nodes"].to_csv("../egypt_nodes.csv", index=False)
morocco_net["nodes"].to_csv("../morocco_nodes.csv", index=False)
algeria_net["nodes"].to_csv("../algeria_nodes.csv", index=False)
# %%
eg_mor_alg_net["nodes"].to_csv("../eg_mor_alg_nodes.csv", index=False)
# %%
nigeria_net["nodes"].to_csv("../nigeria_nodes.csv", index=False)
ghana_net["nodes"].to_csv("../ghana_nodes.csv", index=False)
senegal_net["nodes"].to_csv("../senegal_nodes.csv", index=False)
# %%
sen_gha_ni_net["nodes"].to_csv("../sen_gha_ni_nodes.csv", index=False)
eth_ken_tan_net["nodes"].to_csv("../eth_ken_tan_nodes.csv", index=False)
con_cam_gab_net["nodes"].to_csv("../con_cam_gab_nodes.csv", index=False)
west_east_central_net["nodes"].to_csv("../west_east_central_nodes.csv", index=False)
# %% 
cameroon_net["nodes"].to_csv("../cameroon_nodes.csv", index=False)
demrepcongo_net["nodes"].to_csv("../demrepcongo_nodes.csv", index=False)
ethiopia_net["nodes"].to_csv("../ethiopia_nodes.csv", index=False)
kenya_net["nodes"].to_csv("../kenya_nodes.csv", index=False)
tanzania_net["nodes"].to_csv("../tanzania_nodes.csv", index=False)
sa_net["nodes"].to_csv("../sa_nodes.csv", index=False)
zimbabwe_net["nodes"].to_csv("../zimbabwe_nodes.csv", index=False)

egypt_net["edges"].to_csv("../egypt_edges.csv", index=False)
morocco_net["edges"].to_csv("../morocco_edges.csv", index=False)
algeria_net["edges"].to_csv("../algeria_edges.csv", index=False)
# %%
eg_mor_alg_net["edges"].to_csv("../eg_mor_alg_edges.csv", index=False)
# %% 
nigeria_net["edges"].to_csv("../nigeria_edges.csv", index=False)
ghana_net["edges"].to_csv("../ghana_edges.csv", index=False)
senegal_net["edges"].to_csv("../senegal_edges.csv", index=False)
# %%
sen_gha_ni_net["edges"].to_csv("../sen_gha_ni_edges.csv", index=False)
eth_ken_tan_net["edges"].to_csv("../eth_ken_tan_edges.csv", index=False)
con_cam_gab_net["edges"].to_csv("../con_cam_gab_edges.csv", index=False)
west_east_central_net["edges"].to_csv("../west_east_central_edges.csv", index=False)
# %%

cameroon_net["edges"].to_csv("../cameroon_edges.csv", index=False)
demrepcongo_net["edges"].to_csv("../demrepcongo_edges.csv", index=False)
ethiopia_net["edges"].to_csv("../ethiopia_edges.csv", index=False)
kenya_net["edges"].to_csv("../kenya_edges.csv", index=False)
tanzania_net["edges"].to_csv("../tanzania_edges.csv", index=False)
sa_net["edges"].to_csv("../sa_edges.csv", index=False)
zimbabwe_net["edges"].to_csv("../zimbabwe_edges.csv", index=False)


#%%
M_06["au_off_country"]
# %%
egypt_df.iloc[64,]
# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%

# %%
