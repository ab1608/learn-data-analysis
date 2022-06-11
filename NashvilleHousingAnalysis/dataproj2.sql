-- TASK 1 : Populate Property Addresses
SELECT *
FROM housingSalesInfo;
-- TASK 2 : Split Address into (Address, City, State) columns
-- Source: https://stackoverflow.com/questions/34992575/mysql-substring-extraction-using-delimiter
-- Add the columns 
ALTER TABLE housingSalesInfo
ADD COLUMN houseAddress VARCHAR(255),
    ADD COLUMN city VARCHAR(255),
    ADD COLUMN state VARCHAR(5);
UPDATE housingSalesInfo
SET houseAddress = SUBSTRING_INDEX(
        SUBSTRING_INDEX(housingSalesInfo.address, ',', 1),
        ',',
        -1
    );
UPDATE housingSalesInfo
SET city = SUBSTRING_INDEX(
        SUBSTRING_INDEX(housingSalesInfo.address, ',', 2),
        ',',
        -1
    );
UPDATE housingSalesInfo
SET state = SUBSTRING_INDEX(
        SUBSTRING_INDEX(housingSalesInfo.ownerAddress, ',', 3),
        ',',
        -1
    );
-- TASK 3: Change "Y" and "N" in soldVacant field to "Yes" and "No"
UPDATE housingSalesInfo
SET soldAsVacant = "Yes"
WHERE soldAsVacant LIKE "Y";
UPDATE housingSalesInfo
SET soldAsVacant = "No"
WHERE soldAsVacant LIKE "N";
-- Alternate approach using CASE 
UPDATE housingSalesInfo
SET soldAsVacant = CASE
        WHEN soldAsVacant = "Y" THEN "YES"
        WHEN soldAsVacant = "N" THEN "NO"
        ELSE soldAsVacant
    END;
-- TASK 4: Remove Duplicate entries
WITH duplicates AS (
    SELECT uniqueID,
        COUNT(uniqueID)
    FROM housingSalesInfo
    GROUP BY uniqueID
    HAVING COUNT(uniqueID) > 1
)
DELETE FROM duplicates
where COUNT(uniqueID) > 1;
-- TASK 5: Delete redundant columns
ALTER TABLE housingSalesInfo DROP COLUMN taxDistrict,
    DROP COLUMN ownerAddress,
    DROP COLUMN address;