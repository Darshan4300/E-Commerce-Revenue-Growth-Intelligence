import pandas as pd
import numpy as np
df=pd.read_csv("olist_customers_dataset.csv")

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

#Unique values in order_status
print("\nUnique values in customer_state :")
print(df["customer_state"].value_counts())

print("\nUnique cities:", df["customer_city"].nunique())
print(df["customer_city"].value_counts().head(20))

#nagative zipcode checking:
print("Negative ZIP codes:", (df["customer_zip_code_prefix"] < 0).sum())

#Save file to customers_clean.csv
print(df.to_csv("customers_clean.csv",index=False))
print("\nCleaning is done and file is saved to customers_clean.csv..")
