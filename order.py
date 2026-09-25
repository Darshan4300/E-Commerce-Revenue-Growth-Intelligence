import pandas as pd
import numpy as np
df=pd.read_csv(r"D:\Project-1\E commerce sales analysis\order_dataset\olist_orders_dataset.csv")

print("\nRow,Column : ",df.shape)
print("\nfirst & last data :\n",df.head())
print(df.tail())

print("\nColumn name & Datatype : ")
print(df.info())
print("\nStatistics :\n",df.describe())

print("\nType conversion or fix data type of the column :") #df["Price"] = df["Price"].astype(float) &  df[col] = pd.to_datetime(df[col])
df["order_purchase_timestamp"] = pd.to_datetime(df["order_purchase_timestamp"])
df["order_approved_at"] = pd.to_datetime(df["order_approved_at"])
df["order_delivered_carrier_date"] = pd.to_datetime(df["order_delivered_carrier_date"])
df["order_delivered_customer_date"] = pd.to_datetime(df["order_delivered_customer_date"])
df["order_estimated_delivery_date"] = pd.to_datetime(df["order_estimated_delivery_date"])
print(df.info())

#missing data handling:
print("\nMissing values in each columns :")
print(df.isnull().sum())

print("\napproved column missing values :")
print(df[df["order_approved_at"].isna()]["order_status"].value_counts())
print("\n",df[df["order_delivered_carrier_date"].isna()]["order_status"].value_counts())
print("\n",df[df["order_delivered_customer_date"].isna()]["order_status"].value_counts())
print("\nMissing data is handled.\n")

#duplicate data :
print("\nDuplicate data count =",df.duplicated().sum())

#Unique values in order_status
print("\nUnique values in order_status :")
print(df["order_status"].value_counts())

#Date validation :
print("\nWas an order approved before it was purchased? ",(df["order_approved_at"] < df["order_purchase_timestamp"]).sum())
print("\nWas the carrier pickup before approval? ",(df["order_delivered_carrier_date"] < df["order_approved_at"]).sum())
print("\nWas the customer delivery before carrier pickup?",(df["order_delivered_customer_date"] < df["order_delivered_carrier_date"]).sum())
print("\nWas the estimated delivery date before the purchase date?",(df["order_estimated_delivery_date"] < df["order_purchase_timestamp"]).sum())

#finding reson for invalid date :

print("\nCarrier pickup before approval (1359) :")
invalid_carrier = df[df["order_delivered_carrier_date"] < df["order_approved_at"]]

print(invalid_carrier[[
    "order_status",
    "order_approved_at",
    "order_delivered_carrier_date"
]].head(10))


print("\nCustomer delivery before carrier pickup (23) :")
invalid_delivery = df[df["order_delivered_customer_date"] < df["order_delivered_carrier_date"]]

print(invalid_delivery[[
    "order_status",
    "order_delivered_carrier_date",
    "order_delivered_customer_date"
]])
'''
print(df.to_csv("orders_clean.csv", index=False))
print("orders data is cleaned successfully and save cleaned data to order_clean.csv..")'''