# Nashville-Housing-Dataset-Cleaning-Using-PostgreSQL
My project used PostgreSQL to clean up the city's land use and property data, making it ready for meaningful analysis.

## About the Dataset 
The dataset was gotten from [Nashville Housing Data](https://github.com/yanny-alt/Nashville-Housing-Dataset-Cleaning-Using-PostgreSQL/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx)

## Metadata
The dataset is composed of 20 columns and 56,477 rows.
+ UniqueID — id number attributed to each row.
+ ParcelID — code attributed to a land.
+ LandUse — shows the different uses of land.
+ SalesPrice — cost of land
+ LegalReference — citation is the practice of crediting and referring to authoritative documents and sources.
+ OwnerName_ name of land owner
+ Acreage — the size of an area of land in acres
+ LandValue — the worth of the land
+ Building Value — worth of a building
+ Total Value — landvalue + building value
+ YearBuilt — year the building was built
+ FullBath — a bathroom that includes a shower, a bathtub, a sink, and a toilet.
+ HalfBath — a half bathroom only contains a sink and a toilet
+ Sale_Date — date when the land was sold
+ SaleAddress — address of land sold
+ City — location of land
+ Owner_Address — owners house address
+ OwnerCity — city where owner lives
+ OwnerState — state where owner is located

## Importing Data
I created a database called Nashville Housing, then imported the table which I named Housing in PostgreSQL Pgadmin4.

## Data Cleaning
After going through the dataset, I observed that the dataset needed cleaning in the following ways:

+ Some rows in the PropertyAddress is NULL.
+ The PropertyAddress has both the City and House Address in the same column.
+ The OwnerAddress has the state, city, and address on the same column.
+ Some roles in the SoldAsVacant has Y and N instead of Yes or No.
+ There are some duplicate rows that need to be removed.
+ Some Columns would not be useful for the analysis and therefore should be deleted.
