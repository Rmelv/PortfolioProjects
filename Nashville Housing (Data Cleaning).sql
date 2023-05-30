/*

 Cleaning Data in SQL Queries

 */

 Select *
 From PortfolioProject..NashvilleHousing

 -- Standarize Date Format

 Select SaleDateConverted, CONVERT(Date,SaleDate)
 From PortfolioProject..NashvilleHousing

 Update NashvilleHousing
 SET SaleDate = CONVERT(Date,SaleDate)

 ALTER TABLE NashvilleHousing
 Add SaleDateConverted Date;

 Update NashvilleHousing
 SET SaleDateConverted = CONVERT(Date,SaleDate)

 -- Populate Property Address data

 Select *
 From PortfolioProject..NashvilleHousing
 --where PropertyAddress is null
 order by ParcelID

 Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
 From PortfolioProject..NashvilleHousing a
 JOIN PortfolioProject..NashvilleHousing b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID] <> b.[UniqueID]
 Where a.PropertyAddress is null

 Update a
 SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
 From PortfolioProject..NashvilleHousing a
 JOIN PortfolioProject..NashvilleHousing b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID] <> b.[UniqueID]
  Where a.PropertyAddress is null

  -- Breaking out Address into Individual Columns (Address, City, State)


 Select PropertyAddress
 From PortfolioProject..NashvilleHousing
 --where PropertyAddress is null
 --order by ParcelID
 
 SELECT 
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
  From PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


Select *
From PortfolioProject..NashvilleHousing

Select OwnerAddress
From PortfolioProject..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)
From PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1),

Select *
from NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant = 'N' Then 'No'
else SoldAsVacant
END
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' Then 'Yes'
when SoldAsVacant = 'N' Then 'No'
else SoldAsVacant
END

-- Remove Duplicates

With RowNumCTE AS(
Select *,
ROW_NUMBER() Over (
Partition by ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
Order by UniqueID) row_num
from PortfolioProject..NashvilleHousing
--order by ParcelID
)

Select *
from RowNumCTE
where row_num > 1
Order by PropertyAddress



-- Delete Unused Columns


Alter table  PortfolioProject..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter table  PortfolioProject..NashvilleHousing
drop column SaleDate

Select *
from PortfolioProject..NashvilleHousing
