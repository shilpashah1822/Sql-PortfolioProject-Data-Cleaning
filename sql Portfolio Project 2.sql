--Data Cleaning

select *
from[PortfolioProject].[dbo].[NashvilleHousing]


--Standardise Date Format

select SaleDate, convert(date,saledate)
from[PortfolioProject].[dbo].[NashvilleHousing]


update [PortfolioProject].[dbo].[NashvilleHousing]
set SaleDate = convert(date,saledate)


alter table [PortfolioProject].[dbo].[NashvilleHousing]
add SaleDateConverted Date;


select SaleDateConverted, convert(date,saledate)
from [PortfolioProject].[dbo].[NashvilleHousing]


--Populate Property Address data

select*
from [PortfolioProject].[dbo].[NashvilleHousing]
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from [PortfolioProject].[dbo].[NashvilleHousing] a
join[PortfolioProject].[dbo].[NashvilleHousing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from[PortfolioProject].[dbo].[NashvilleHousing] a
join [PortfolioProject].[dbo].[NashvilleHousing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


--Braking out Address into individual columns (State,City,Address)
select
substring(PropertyAddress, 1, charindex(',',PropertyAddress)-1) as Address,
substring(PropertyAddress, charindex(',',PropertyAddress)+1 , len(PropertyAddress))

from[PortfolioProject].[dbo].[NashvilleHousing]

alter table [PortfolioProject].[dbo].[NashvilleHousing]
add PropertySplitAddress nvarchar(255);

update [PortfolioProject].[dbo].[NashvilleHousing]
set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',',PropertyAddress)-1)

alter table[PortfolioProject].[dbo].[NashvilleHousing]
add PropertySplitCity nvarchar(255)

update [PortfolioProject].[dbo].[NashvilleHousing]
set PropertySplitCity =substring(PropertyAddress, charindex(',',PropertyAddress)+1 , len(PropertyAddress))


select * from
[PortfolioProject].[dbo].[NashvilleHousing]




select OwnerAddress
from [PortfolioProject].[dbo].[NashvilleHousing]

select
PARSENAME(replace(OwnerAddress, ',' , '.'), 3)
,PARSENAME(replace(OwnerAddress, ',' , '.'), 2)
,PARSENAME(replace(OwnerAddress, ',' , '.'), 1)
from [PortfolioProject].[dbo].[NashvilleHousing]



alter table [PortfolioProject].[dbo].[NashvilleHousing]
add OwnerSplitAddress nvarchar(255);

update [PortfolioProject].[dbo].[NashvilleHousing]
set OwnerSplitAddress =PARSENAME(replace(OwnerAddress, ',' , '.'), 3)

alter table[PortfolioProject].[dbo].[NashvilleHousing]
add ownerSplitCity nvarchar(255);

update [PortfolioProject].[dbo].[NashvilleHousing]
set OwnerSplitCity =PARSENAME(replace(OwnerAddress, ',' , '.'), 2)


alter table [PortfolioProject].[dbo].[NashvilleHousing]
add OwnerSplitState nvarchar(255);

update [PortfolioProject].[dbo].[NashvilleHousing]
set OwnerSplitState =PARSENAME(replace(OwnerAddress, ',' , '.'), 1)


select*
from [PortfolioProject].[dbo].[NashvilleHousing]
where OwnerSplitState is not null

--change Y and N to  Yes and No in 'Sold as Vacant' feild

select distinct(SoldAsVacant),count(SoldAsVacant)
from[PortfolioProject].[dbo].[NashvilleHousing]
group by soldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
  when SoldAsVacant = 'N' then 'No'
  else SoldAsVacant
  end
from[PortfolioProject].[dbo].[NashvilleHousing]

update [PortfolioProject].[dbo].[NashvilleHousing]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
  when SoldAsVacant = 'N' then 'No'
  else SoldAsVacant
  end



--Remove Duplicates

with RowNumCTE As(
select *,
	ROW_NUMBER() over (
	partition by ParcelID,
	PropertyAddress,
	SalePrice,
	legalReference
	order by
	  uniqueID
	  ) row_num

from [PortfolioProject].[dbo].[NashvilleHousing]
)

select *
from RowNumCTE
where row_num > 1


--deleting unnecessary column

select *
from  [PortfolioProject].[dbo].[NashvilleHousing]

alter table  [PortfolioProject].[dbo].[NashvilleHousing]
drop column PropertyAddress,OwnerAddress,TaxDistrict


alter table  [PortfolioProject].[dbo].[NashvilleHousing]
drop column SaleDate