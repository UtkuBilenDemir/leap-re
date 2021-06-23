import sklearn
print(sklearn.__version__)
import hmni
# Initialize a Matcher Object
matcher = hmni.Matcher(model='latin')



matcher.similarity('Alan', 'Al')
import pandas as pd

df1 = pd.DataFrame({'name': ['Al', 'Mark', 'James', 'Harold']})
df2 = pd.DataFrame({'name': ['Mark', 'Alan', 'James', 'Harold']})

merged = matcher.fuzzymerge(df1, df2, how='left', on='name')




print(sklearn.__version__)
