CREATE TABLE housing( unique_id INTEGER, parcel_id VARCHAR, land_use VARCHAR, property_address VARCHAR, sale_date DATE, sale_price VARCHAR, legal_reference VARCHAR, sold_as_vacancy VARCHAR, owner_name VARCHAR, owner_address VARCHAR, acreage NUMERIC, tax_district VARCHAR, land_value INTEGER, building_value INTEGER, total_value INTEGER, year_built INTEGER, bedrooms INTEGER, fullbath INTEGER, halfbath INTEGER);

-- View of Raw Table 
 SELECT *
 FROM housing;
 
 -- Determining the datatypes and columns 
 SELECT column_name, data_type FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_name = 'housing';
 
 -- Finding out the accurate row count
 SELECT COUNT(*) AS row_count
 FROM housing;
 
 -- Checking NULL values in the property address column 
 SELECT *
 FROM housing
 WHERE property_address IS NULL;
 
 -- Finding out the rows with the same parcel ID
  SELECT *
 FROM housing
 WHERE property_address IS NULL
 ORDER BY parcel_id;
 
 -- Using Self-Joins 
 SELECT a.parcel_id, a.property_address, b.parcel_id, b.property_address, 
 COALESCE(a.property_address, b.property_address) AS merged_property_address
FROM housing AS a
JOIN housing AS b ON a.parcel_id = b.parcel_id AND a.unique_id <> b.unique_id
WHERE a.property_address IS NULL;

 -- Using UPDATE 
 UPDATE housing 
 SET property_address = COALESCE(a.property_address, b.property_address) 
 FROM housing AS a
JOIN housing AS b ON a.parcel_id = b.parcel_id AND a.unique_id <> b.unique_id
WHERE a.property_address IS NULL;

-- View Output 
SELECT property_address
FROM housing
WHERE property_address IS NULL;

 -- Breaking out Property Address column into Individual Columns (Address, City)
 SELECT property_address
 FROM housing;
 
 SELECT SUBSTRING(property_address FROM 1 FOR POSITION(',' IN property_address) - 1) AS address
FROM housing;

SELECT TRIM(BOTH ' ' FROM SPLIT_PART(property_address, ', ', 2)) AS city
FROM housing;

ALTER TABLE housing
ADD property_split_address VARCHAR(50);
 
UPDATE HOUSING
SET property_split_address = SUBSTRING(property_address FROM 1 FOR POSITION(',' IN property_address) - 1);

ALTER TABLE housing
ADD property_split_city VARCHAR(50);

UPDATE housing
SET property_split_city = TRIM(BOTH ' ' FROM SPLIT_PART(property_address, ', ', 2));

 -- Breaking out the Owner Address into individual columns (Address, City)
 SELECT owner_address
 FROM housing;
 
SELECT SUBSTRING(owner_address FROM 1 FOR POSITION(',' IN owner_address) -1) AS owner_address
FROM housing;

SELECT TRIM(BOTH ' ' FROM SPLIT_PART(owner_address, ', ', 2)) AS city
FROM housing;	  

SELECT SUBSTRING(owner_address FROM POSITION(', ' IN owner_address) + 2 FOR 2) AS state_code
FROM;

SELECT 
  CASE 
    WHEN TRIM(BOTH ' ' FROM SPLIT_PART(owner_address, ', ', 3)) = 'TN' THEN 'Tennessee'
    ELSE TRIM(BOTH ' ' FROM SPLIT_PART(owner_address, ', ', 3))
  END AS state_name
FROM housing;

ALTER TABLE housing
ADD owner_split_address VARCHAR(50);

UPDATE housing
SET owner_split_address = SUBSTRING(owner_address FROM 1 FOR POSITION(',' IN owner_address) -1);

ALTER TABLE housing
ADD owner_split_city VARCHAR(50);

UPDATE housing
SET owner_split_address = TRIM(BOTH ' ' FROM SPLIT_PART(owner_address, ', ', 2));

ALTER TABLE housing
ADD owner_split_state VARCHAR(50);

UPDATE housing
SET owner_split_state =  CASE 
    WHEN TRIM(BOTH ' ' FROM SPLIT_PART(owner_address, ', ', 3)) = 'TN' THEN 'Tennessee'
    ELSE TRIM(BOTH ' ' FROM SPLIT_PART(owner_address, ', ', 3))
  END;


 -- Change Y and N to Yes and No respectively in the "Sold As Vacancy" Field
 SELECT sold_as_vacancy, COUNT(sold_as_vacancy)
 FROM housing
 GROUP BY sold_as_vacancy;
 
 SELECT sold_as_vacancy,
       CASE WHEN sold_as_vacancy = 'N' THEN 'No'
	        WHEN sold_as_vacancy = 'Y' THEN 'Yes'
			ELSE sold_as_vacancy
			END
	FROM housing;
	 
 UPDATE housing
 SET sold_as_vacancy = CASE WHEN sold_as_vacancy = 'N' THEN 'No'
	        WHEN sold_as_vacancy = 'Y' THEN 'Yes'
			ELSE sold_as_vacancy
			END;
			
 -- Removing Duplicates
  WITH ROWNUMCTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                parcel_id,
                land_use,
                property_address,
                sale_date,
                sale_price,
                legal_reference,
                owner_name
            ORDER BY unique_id DESC
        ) AS Row_num
    FROM housing
) 
DELETE FROM housing
USING ROWNUMCTE
WHERE housing.unique_id = ROWNUMCTE.unique_id AND ROWNUMCTE.Row_num > 1;

 -- Delete Unused Columns
ALTER TABLE housing
DROP COLUMN owner_address,
DROP COLUMN tax_district,
DROP COLUMN property_address,
DROP COLUMN sale_date; 
