import pandas as pd
import numpy as np
df=pd.read_csv("olist_order_reviews_dataset.csv")
print(df.head())
print(df.tail())

print("\n",df.shape)
print("\n",df.info())
print("\n",df.describe())

df["review_creation_date"] = pd.to_datetime(df["review_creation_date"])
df["review_answer_timestamp"] = pd.to_datetime(df["review_answer_timestamp"])
print("\n",df.info())

print("\nDuplicate rows:", df.duplicated().sum())

print("\n",df.isnull().sum())

#review score check:
print("\nInvalid Scores:", ((df["review_score"] < 1) | (df["review_score"] > 5)).sum())
#review score range:
print(df["review_score"].value_counts().sort_index())

#date validation ;
print(
    "\nAnswer before Review:",
    (df["review_answer_timestamp"] < df["review_creation_date"]).sum()
) 

#save cleaned data:
print(df.to_csv("order_reviews_clean.csv", index=False))
print("\nData cleaning is complete.cleaned dataset is save as order_reviews_clean.csv..")
