import pandas as pd
import numpy as np
df=pd.read_csv("olist_products_dataset.csv")

print("\nRow,Column : ",df.shape)
print("\nfirst & last data :\n",df.head())
print(df.tail())

print("\nColumn name & Datatype : ")
print(df.info())
print("\nStatistics :\n",df.describe())

#missing data handling:
print("\nMissing values in each columns :")
print(df.isnull().sum())

print(df[df["product_category_name"].isna()])
print(df[df["product_weight_g"].isna()])

print("\nDo not guess or fill the dimensions.Reason:Weight and dimensions are business attributes.Filling them with a mean or median would create inaccurate product information.")

#duplicate data :
print("\nDuplicate data count =",df.duplicated().sum())

#check negative values :
print("\nNegative Weight:", (df["product_weight_g"] < 0).sum())
print("Negative Length:", (df["product_length_cm"] < 0).sum())
print("Negative Height:", (df["product_height_cm"] < 0).sum())
print("Negative Width:", (df["product_width_cm"] < 0).sum())

#check infinite values :
print("\nInfinite Weight:", np.isinf(df["product_weight_g"]).sum())
print("Infinite Length:", np.isinf(df["product_length_cm"]).sum())
print("Infinite Height:", np.isinf(df["product_height_cm"]).sum())
print("Infinite Width:", np.isinf(df["product_width_cm"]).sum())

#check xero values :
print("\nZero Weight:", (df["product_weight_g"] == 0).sum())
print("Zero Length:", (df["product_length_cm"] == 0).sum())
print("Zero Height:", (df["product_height_cm"] == 0).sum())
print("Zero Width:", (df["product_width_cm"] == 0).sum())
print("Zero Photos:", (df["product_photos_qty"] == 0).sum())

print("\nKeep the 0 values as they are and document them.\n\nReason:\n->Replacing them with the mean or median would introduce inaccurate business data.\n->There are only 4 records out of 32,951 (about 0.01%), so their impact on analysis is negligible.\n->If you later calculate shipping costs based on weight, you can simply exclude or flag these four records in that specific analysis instead of modifying the original \n  cleaned dataset.")

#save cleaned data :
print(df.to_csv("products_clean.csv", index=False))
print("\nDataset is cleaned successfully. Cleaned data save as products_cleane.csv\n")