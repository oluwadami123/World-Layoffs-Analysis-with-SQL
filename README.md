# World-Layoffs-Analysis-with-SQL

## Project Overview
This project provides a thorough analysis to uncover trends and insights of the world’s layoffs dataset.
The dataset was extracted from a reliable source and it contains 9 columns that are relevant for our analysis. Here are the basic descriptions of each column:
  1.	Company:  This gives the names of each company globally across all country 
  2.	Location: This column gives the exact location of each company 
  3.	Industry: This gives the sector category of business the company operates 
  4.	Total_laid_off: This column contains the total number of employees laid off for each company 
  5.	Percentage_laid_off: This gives the percentage count of the total_laid_off 
  6.	Date: This contains the date when the layoffs occurred or announced 
  7.	Stage: The company's stage in its business lifecycle, such as post-IPO (after it has gone public) or Series B (early-stage startup funding). "Unknown" means the company's stage is not specified
  8.	Country: The country where the company operates.
  9.	Funds_raised_millions: The amount of funding the company has raised expressed in millions
## Data Cleaning:
  1.	Removed duplicates
  2.	Standardized the entire dataset
  3.	Handled Nulls and Blanks spaces
  4.	Removed irrelevant columns
## Exploratory Data Analysis:
  1.	Total layoffs across each company 
  2.	Total layoffs across the years
  3.	Highest number of total layoffs 
  4.	Rolling sum of the total layoffs across the company based on the year & month
