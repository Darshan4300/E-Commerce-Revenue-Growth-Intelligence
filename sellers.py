import pandas as pd
import numpy as np
df=pd.read_csv("olist_sellers_dataset.csv")

print("\nRow,Column : ",df.shape)
print("\nfirst & last data :\n",df.head())
print(df.tail())

print("\nColumn name & Datatype : ")
print(df.info())
print("\nStatistics :\n",df.describe())

#missing data handling:
print("\nMissing values in each columns :")
print(df.isnull().sum())

#duplicate data :
print("\nDuplicate data count =",df.duplicated().sum())

#check unique seller states:
print("\n",df['seller_state'].value_counts())

#check negative zip codes:
print("\nNegative ZIP Codes:", (df["seller_zip_code_prefix"] < 0).sum())

#save cleaned data:
print(df.to_csv("sellers_clean.csv", index=False))
print("\nCleaning is done and file is saved to sellers_clean.csv..")