import pandas as pd
import numpy as np
df=pd.read_csv("olist_geolocation_dataset.csv")

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
print(df[df.duplicated()].head(10))

print(df["geolocation_zip_code_prefix"].duplicated().sum())

#remove duplicates:
df = df.drop_duplicates()
print(df)
print("\n",df.shape)
#recheck duplicate values
print("Duplicate rows:", df.duplicated().sum())

#nagative values handling:
print("Negative ZIP Codes:",
      (df["geolocation_zip_code_prefix"] < 0).sum())

#invalide data handling:
print("Invalid Latitude:",
      ((df["geolocation_lat"] < -90) |
       (df["geolocation_lat"] > 90)).sum())

print("Invalid Longitude:",
      ((df["geolocation_lng"] < -180) |
       (df["geolocation_lng"] > 180)).sum())

#save cleaned data:
print(df.to_csv("geolocation_clean.csv", index=False))
print("\nCleaning is done and file is saved to geolocation_clean.csv..")