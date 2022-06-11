CREATE DATABASE NASHVILLEHOUSING;
DROP TABLE housingSalesInfo;
CREATE TABLE nashvillehousing.housingSalesInfo (
    uniqueID VARCHAR(20),
    parcelID VARCHAR(100),
    landUse VARCHAR(100),
    address VARCHAR(255),
    saleDate DATE,
    salePrice BIGINT,
    legalRef VARCHAR(255),
    soldAsVacant VARCHAR(5),
    ownerName VARCHAR(255),
    ownerAddress VARCHAR(255),
    acreage FLOAT,
    taxDistrict VARCHAR(255),
    landValue INT,
    buildingValue INT,
    totalValue INT,
    yearBuilt VARCHAR(4),
    numBedrooms INT,
    numFullBaths INT,
    numHalfBaths INT
);
-- Load CSV files into the table
LOAD DATA INFILE "/usr/local/mysql-8.0.29-macos12-arm64/Nashville Housing Data for Data Cleaning.csv" INTO TABLE nashvillehousing.housingSalesInfo FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS (
    uniqueID,
    parcelID,
    landUse,
    address,
    @saleDate,
    salePrice,
    legalRef,
    soldAsVacant,
    ownerName,
    ownerAddress,
    acreage,
    taxDistrict,
    landValue,
    buildingValue,
    totalValue,
    yearBuilt,
    numBedrooms,
    numFullBaths,
    numHalfBaths
)
SET saleDate = STR_TO_DATE(@saleDate, '%d-%b-%y');