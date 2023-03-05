--Cleaning Data in SQL Queries

SELECT *
FROM [Portfolio Project].[dbo].[Nashville Housing]

--Standardize Date Format


SELECT SalesDateConverted, CONVERT(Date, SaleDate)
FROM [Portfolio Project].[dbo].[Nashville Housing]


UPDATE [Nashville Housing]
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE [Nashville Housing]
Add SalesDateConverted Date;

UPDATE [Nashville Housing]
SET SalesDateConverted = CONVERT(Date,SaleDate)


--Populate Property Address data

SELECT *
FROM [Portfolio Project].[dbo].[Nashville Housing]
--WHERE PropertyAddress is null
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project].[dbo].[Nashville Housing] a
JOIN [Portfolio Project].[dbo].[Nashville Housing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project].[dbo].[Nashville Housing] a
JOIN [Portfolio Project].[dbo].[Nashville Housing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]





--------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)



SELECT PropertyAddress
FROM [Portfolio Project].[dbo].[Nashville Housing]
--WHERE PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))  as Address
FROM [Portfolio Project].[dbo].[Nashville Housing]


ALTER TABLE [Nashville Housing]
Add PropertySplitAddress Nvarchar(255);

UPDATE [Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1)

ALTER TABLE [Nashville Housing]
Add PropertySplitCity Nvarchar(255);

UPDATE [Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))



SELECT *
FROM [Portfolio Project].[dbo].[Nashville Housing]


SELECT OwnerAddress
FROM [Portfolio Project].[dbo].[Nashville Housing]


SELECT
PARSENAME(REPLACE(OwnerAddress,',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress,',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress,',', '.') ,1)
FROM [Portfolio Project].[dbo].[Nashville Housing]


ALTER TABLE [Nashville Housing]
Add OwnerSplitAddress Nvarchar(255);

UPDATE [Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.') ,3)

ALTER TABLE [Nashville Housing]
Add OwnerSplitCity Nvarchar(255);

UPDATE [Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.') ,2)

ALTER TABLE [Nashville Housing]
Add OwnerSplitState Nvarchar(255);

UPDATE [Nashville Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.') ,1)


SELECT *
FROM [Portfolio Project].[dbo].[Nashville Housing]


--Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM [Portfolio Project].[dbo].[Nashville Housing]
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
	When SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END
FROM [Portfolio Project].[dbo].[Nashville Housing]




UPDATE [Nashville Housing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
	When SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END



--Remove Duplicates

WITH RowNumCTE AS(
Select*,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num
				
FROM [Portfolio Project].[dbo].[Nashville Housing]
--ORDER BY ParcelID
)
Select*
FROM RowNumCTE
Where row_num> 1
ORDER BY PropertyAddress



--Delete Unused Column


Select*
FROM [Portfolio Project].[dbo].[Nashville Housing]


ALTER TABLE [Portfolio Project].[dbo].[Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Portfolio Project].[dbo].[Nashville Housing]
DROP COLUMN SaleDate