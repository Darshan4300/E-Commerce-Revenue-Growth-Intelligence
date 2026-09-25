import pandas as pd
import numpy as np
df=pd.read_csv("olist_order_payments_dataset.csv")

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

#nagative values :
print("\nNegative Installments:", (df["payment_installments"] < 0).sum())
print("Negative Payment:",(df["payment_value"]<0).sum())

#zero values :
print("\nZero Installments:",(df['payment_installments']==0).sum())
print(df[df['payment_installments']==0])

print("\nZero Payment:",(df['payment_value']==0).sum())
print(df[df["payment_value"]==0])

#infinite value:
print("\nInfinite Payment:",np.isinf(df['payment_value']).sum())

#Valid payment method:
print("\n",df['payment_type'].value_counts())

#save cleaned data:
print(df.to_csv("order_payments_clean.csv", index=False))
print("\nCleaning is done and file is saved to order_payments_clean.csv..")