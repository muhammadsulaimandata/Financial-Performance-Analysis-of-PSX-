# Financial Performance Analysis of PSX

This repository contains a financial analytics project focused on non-financial companies listed on the Pakistan Stock Exchange (PSX) from 2005 to 2023.

## Project overview

The objective of this project is to analyze the financial performance of PSX-listed companies by examining key financial ratios across sectors and years. Instead of comparing raw monetary values, the analysis uses ratio-based metrics so firms of different sizes can be compared fairly.

The study focuses on financial indicators related to:
- Profitability
- Liquidity
- Leverage
- Efficiency
- Firm size

## Data and scope

- Time period: 2005–2023
- Companies: listed non-financial firms on PSX
- Sectors: 14 sectors represented in the dataset
- Data source: SBP financial statement data for listed non-financial companies
- Treatment: the aggregated "All Sector" rows were excluded from firm-level analysis to avoid distortion

## Methodology

The analysis workflow includes:
1. Loading and cleaning the dataset
2. Filtering out aggregated sector totals
3. Constructing financial ratio variables
4. Winsorizing extreme outliers
5. Performing correlation analysis and related statistical checks in R
6. Visualizing results through correlation heatmaps and supporting reports

## Main analytical approach

The project emphasizes ratio-based analysis, where variables such as net profit margin, gross profit margin, operating margin, ROA, ROE, current ratio, quick ratio, debt-to-equity ratio, and asset turnover are evaluated together.

The key statistical method used is correlation analysis, which helps identify how different financial ratios move together and whether strong relationships exist among profitability, liquidity, and leverage measures.

## Tools used

- R
- RStudio
- R packages: readxl, dplyr, corrplot, car, plm, factoextra, cluster, rpart, ggplot2

## Repository contents

- `PSX_Financial_Analysis.R` — main R analysis script
- `01 Correlation Analysis.R` — correlation-focused analysis script
- `BDA Project.Rmd` — project report in R Markdown
- `RMD Final Lab.Rmd` — additional report / lab file
- `BDA-Project.html` — rendered HTML output

## Notes

This project is an academic/data-analysis project centered on PSX financial statement evaluation and statistical comparison of firm performance. It is designed to explore how financial ratios behave across sectors and years rather than to provide a commercial dashboard or business intelligence product.
