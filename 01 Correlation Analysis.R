# CORRELATION ANALYSIS OF PSX FINANCIAL RATIOS (IMPROVED)

# 1. Load Libraries
library(readxl)
library(corrplot)
library(Hmisc)
library(psych)
library(PerformanceAnalytics)

# 2. Load Dataset
psx_data <- read_excel("Clean data.xlsx", sheet = 1)

# 3. Select Financial Ratios (Fixed variable name)
ratio_data <- Clean_data[, c(
  "net_profit_margin",
  "asset_turnover",
  "roa",
  "roe",
  "roce",
  "current_ratio",
  "quick_ratio",
  "inventory_turnover",
  "eps",
  "debt_equity_ratio"
)]

# 4. Remove Missing Values
ratio_data <- na.omit(ratio_data)

# ---------------------------------------------------------
# THE FIX: Change from "pearson" to "spearman" 
# ---------------------------------------------------------

# 5. Spearman Correlation Matrix (Robust to outliers)
cor_matrix_spearman <- cor(
  ratio_data,
  use = "complete.obs",
  method = "spearman"  # <--- THIS IS THE CRITICAL CHANGE
)

# 6. Correlation Significance (Spearman)
cor_test_spearman <- rcorr(
  as.matrix(ratio_data),
  type = "spearman"
)

# 7. Heatmap
corrplot(
  cor_matrix_spearman,
  method = "color",
  type = "upper",
  order = "hclust",
  tl.col = "black",
  tl.srt = 45,
  addCoef.col = "black",
  number.cex = 0.7,
  title = "Spearman Correlation of PSX Ratios", # Added Title
  mar=c(0,0,1,0)
)

# 8. Scatterplot Matrix (Advanced)
# Note: chart.Correlation defaults to Pearson. We must override it.
chart.Correlation(
  ratio_data,
  histogram = TRUE,
  pch = 19,
  method = "spearman" # <--- Ensures the scatterplot also ignores outliers
)