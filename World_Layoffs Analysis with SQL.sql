-- Exploratory Data Analysis 
 USE world_layoffs;
 -- Maximum Total_laid_off vs Minimum Total_laid_off across each company
SELECT 
	company,
	MAX(total_laid_off),
	MIN(total_laid_off)
	FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC;
 
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- SUM of total_layoffs across each company 
SELECT 
	company,
	SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 1;

-- Starting date and ending date for the entire dataset
SELECT 
	MIN(date),
    MAX(date)
FROM layoffs_staging2;

-- Sum of total laidoffs across the industry
SELECT 
	industry,
    SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Sum of total layoffs across each country
SELECT 
	country,
    SUM(total_laid_off) as Sum_of_Total_layoffs
FROM layoffs_staging2
GROUP BY country;

-- Sum of total layoffs across the years
SELECT 
	YEAR(date),
    SUM(total_laid_off) as Sum_of_Total_layoffs
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 DESC;

SELECT *
FROM layoffs_staging2;

-- Rolling sum of layoffs across the years for each company  
SELECT 
	SUBSTRING(date, 1,7) AS MONTH,
    SUM(total_laid_off) as Total_layoffs
FROM layoffs_staging2
WHERE SUBSTRING(date, 1,7) IS NOT NULL
GROUP BY SUBSTRING(date, 1,7)
ORDER BY 1;

With Rolling_Total AS
(
SELECT 
	SUBSTRING(date, 1,7) as MONTH,
    SUM(Total_laid_off) as Total_layoffs
FROM layoffs_staging2
WHERE SUBSTRING(date, 1,7) IS NOT NULL
GROUP BY SUBSTRING(date, 1,7) 
ORDER BY 1
)
SELECT
	MONTH,
    Total_layoffs,
	SUM(Total_layoffs) OVER(ORDER BY MONTH)	as Rolling_Total_By_Month
FROM Rolling_Total
ORDER BY 3 DESC;



-- Total layoffs across the years for each company
SELECT
	company,
    YEAR(date) AS YEAR,
    SUM(total_laid_off) AS Total_layoffs
FROM layoffs_staging2
GROUP BY company, YEAR(date)
ORDER BY 3 DESC;

-- Top 5 company with the highest number of layoffs across the years
WITH company_rank as
(
SELECT
	company,
    YEAR(date) AS YEAR,
    SUM(total_laid_off) AS Total_layoffs
FROM layoffs_staging2
GROUP BY company, YEAR(date)
ORDER BY 3 DESC
), Company_Year_Rank AS
(
SELECT 
	*,
	DENSE_RANK() OVER(PARTITION BY YEAR ORDER BY Total_layoffs DESC) AS comapny_ranking
FROM company_rank
WHERE YEAR IS NOT NULL
) 
SELECT 
	*
FROM Company_Year_Rank
WHERE comapny_ranking <=5;