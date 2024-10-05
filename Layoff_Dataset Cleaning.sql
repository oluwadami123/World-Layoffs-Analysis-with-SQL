USE world_layoffs;

DESCRIBE layoffs;

-- Created a new table "layoffs_staging" 
ALTER TABLE layoffs
CHANGE ï»¿company company TEXT;

CREATE TABLE layoffs_staging
LIKE layoffs;
-- Populated the entire table with the values in table "layoffs"  
INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

-- Tasks to cover
-- 1. Removing Duplicates
-- 2. Data Standardization
-- 3. Filling Null values and Blank spaces
-- 4. Removing unnecessary

-- First method in check for Duplicates using Subquery
SELECT *
FROM(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, "date", stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)t WHERE row_num > 1;

-- Second method in checking for Duplicates utilizing CTEs
WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, "date", stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
) 
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, "date", stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Task 2 -Data Standardizing

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET industry = "Crypto"
WHERE industry LIKE "Crypto%";


-- SELECT DISTINCT country, TRIM(TRAILING "." FROM country) trimedcountry
-- FROM layoffs_staging2
-- ORDER BY 1;

UPDATE layoffs_staging2
SET country = "United States"
WHERE country LIKE "United States%";

SELECT date,
STR_TO_DATE (date, "%m/%d/%Y") AS newDate
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET date = STR_TO_DATE (date, "%m/%d/%Y");

-- Changing the "date" Column to a Date format
ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;

-- Task 3 (Replacing NULL Values and EMPTY Values)
SELECT 
	company,
	industry,
    total_laid_off,
    percentage_laid_off
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = "";

SELECT *
FROM layoffs_staging2
WHERE company LIKE "Juul";

-- Used self Join to check missing values o
SELECT t1.company, t1.industry, t2.company, t2.industry
FROM layoffs_staging2 as t1
JOIN layoffs_staging2 as t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE t1.industry IS NULL OR t1.industry =""
AND t2.industry IS NOT NULL;

-- Changing the empty values to NULL values
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = "";


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry    
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL;

-- Checking the count of the Nulls in two columns
SELECT 
	COUNT(*)
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- Deleting rows where total_laid_off column and percentage_laid_off column are null
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- Task 4 (Removing Irrelevant Column)
-- Droping the row_num column
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *, 
COUNT(*) OVER() TotalCount
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;