/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM portfolioproject.dbo.NashvilleHousing
 

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SaleConverted, CONVERT(Date,SaleDate)
FROM portfolioproject.dbo.NashvilleHousing

 UPDATE.NashvilleHousing
 SET SaleDate = CONVERT(Date,SaleDate)


 ALTER TABLE NashvilleHousing
 ADD SaleConverted Date;

 UPDATE.NashvilleHousing
 SET SaleConverted = CONVERT(Date,SaleDate)



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data


SELECT *
FROM portfolioproject.dbo.NashvilleHousing
--WHERE PropertyAddress is NULL
ORDER BY ParcelID


 

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM portfolioproject.dbo.NashvilleHousing a
JOIN portfolioproject.dbo.NashvilleHousing b
	 on a.ParcelID = b.ParcelID
	 AND a.[UniqueID] <> b.[UniqueID]
	 where a.PropertyAddress is null


	 Update a
	 SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
	 FROM portfolioproject.dbo.NashvilleHousing a
JOIN portfolioproject.dbo.NashvilleHousing b
	 on a.ParcelID = b.ParcelID
	 AND a.[UniqueID] <> b.[UniqueID]
	 where a.PropertyAddress is null

 


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
FROM portfolioproject.dbo.NashvilleHousing
--WHERE PropertyAddress is NULL
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
FROM portfolioproject.dbo.NashvilleHousing


 
 
 ALTER TABLE NashvilleHousing
 ADD PropertySplitAddress Nvarchar(255);

 UPDATE.NashvilleHousing
 SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

 ALTER TABLE NashvilleHousing
 ADD PropertySplitCity Nvarchar(255);

 UPDATE.NashvilleHousing
 SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


 
 SELECT *
 FROM portfolioproject.dbo.NashvilleHousing



  
 SELECT OwnerAddress
 FROM portfolioproject.dbo.NashvilleHousing


 SELECT
 PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

  FROM portfolioproject.dbo.NashvilleHousing



   ALTER TABLE NashvilleHousing
 ADD OwnerSplitAddress Nvarchar(255);

 UPDATE.NashvilleHousing
 SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

 ALTER TABLE NashvilleHousing
 ADD OwnerSplitCity Nvarchar(255);


 UPDATE.NashvilleHousing
 SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

 
 ALTER TABLE NashvilleHousing
 ADD OwnerSplitState Nvarchar(255);

 UPDATE.NashvilleHousing
 SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



	
  
 SELECT *
 FROM portfolioproject.dbo.NashvilleHousing





--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


 SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
 FROM portfolioproject.dbo.NashvilleHousing
 Group by SoldAsVacant
 order by 2




 SELECT SoldAsVacant
 , CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END

  FROM portfolioproject.dbo.NashvilleHousing



  Update NashvilleHousing
  SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END





-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


WITH RowNumCTE AS(
SELECT *,
	 ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
				  PropertyAddress, 
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
					UniqueID
					) row_num
  FROM portfolioproject.dbo.NashvilleHousing
  --order by ParcelID
  )
  SELECT *
  FROM RowNumCTE
  WHERE row_num > 1
  order by PropertyAddress



  SELECT *
  FROM portfolioproject.dbo.NashvilleHousing

 




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



  SELECT *
  FROM portfolioproject.dbo.NashvilleHousing



  ALTER TABLE portfolioproject.dbo.NashvilleHousing
  DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


  ALTER TABLE portfolioproject.dbo.NashvilleHousing
  DROP COLUMN SaleDate


