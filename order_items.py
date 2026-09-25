import pandas as pd
import numpy as np
df=pd.read_csv("olist_order_items_dataset.csv")

print("\nRow,Column : ",df.shape)
print("\nfirst & last data :\n",df.head())
print(df.tail())

print("\nColumn name & Datatype : ")
print(df.info())

#converting datatype to original datatype :
df["shipping_limit_date"] = pd.to_datetime(df["shipping_limit_date"])
print(df.info())

#statistics
print("\nStatistics :\n",df.describe())

#missing data handling:
print("\nMissing values in each columns :")
print(df.isnull().sum())

#duplicate data :
print("\nDuplicate data count =",df.duplicated().sum())

#Negative values and infinite values :
print("\nNegative Price:", (df["price"] < 0).sum())
print("Negative Freight:", (df["freight_value"] < 0).sum())

print("Infinite Price:", np.isinf(df["price"]).sum())
print("Infinite Freight:", np.isinf(df["freight_value"]).sum())

print("Zero Price:", (df["price"] == 0).sum())
print("Zero Freight:", (df["freight_value"] == 0).sum())

#order item id count :
print("\n",df["order_item_id"].value_counts().sort_index())

#Save file to order_items_clean.csv
print(df.to_csv("order_items_clean.csv", index=False))
print("\nCleaning is done and file is saved to order_items_clean.csv..")