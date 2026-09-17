# PSX FINANCIAL STATEMENTS ANALYSIS (2005-2023)
# Correlation
#
# All analyses are built on RATIOS (not raw Rupee values), because ratios
# are scale-free and comparable across firms of very different sizes.



## ---- 0. PACKAGES -------------------------------------------------------
required_pkgs <- c("readxl", "dplyr", "corrplot", "car", "plm",
                    "factoextra", "cluster", "rpart", "ggplot2")
new_pkgs <- required_pkgs[!(required_pkgs %in% installed.packages()[, "Package"])]
if (length(new_pkgs)) install.packages(new_pkgs, repos = "https://cloud.r-project.org")

suppressMessages({
  library(readxl)
  library(dplyr)
  library(corrplot)
  library(car)
  library(plm)
  library(factoextra)
  library(cluster)
  library(rpart)
  library(ggplot2)
})

set.seed(123)

## ---- 1. LOAD DATA -----------------------------------------------
df <- Clean_data

df$year <- as.integer(df$year)

# The file contains 19 "All Sector" rows which are pre-aggregated totals,
# not individual firms -> drop them so they don't distort firm-level analysis
df <- df %>% filter(organization_name != "All Sector")

cat("Firms:", n_distinct(df$organization_name),
    " | Years:", min(df$year), "-", max(df$year),
    " | Rows:", nrow(df), "\n")

## ---- 2. BUILD RATIOS -----------------------------------------------------

safe_div <- function(a, b) {
  r <- a / b
  r[!is.finite(r)] <- NA
  r
}

ratios <- df %>%
  transmute(
    organization_name, sector, sub_sector, year,
    net_profit_margin    = safe_div(profit_before_tax - tax_expense, sales),
    gross_profit_margin  = safe_div(gross_profit, sales),
    operating_margin     = safe_div(gross_profit - operating_expenses, sales),
    roa                  = safe_div(profit_before_tax - tax_expense, total_assets),
    roe                  = safe_div(profit_before_tax - tax_expense, shareholders_equity),
    roce                 = safe_div(profit_before_tax, capital_employed),
    asset_turnover       = safe_div(sales, total_assets),
    inventory_turnover   = safe_div(cost_of_sales, inventory),
    receivables_turnover = safe_div(sales, accounts_receivable),
    current_ratio        = safe_div(current_assets, current_liabilities),
    quick_ratio          = safe_div(current_assets - inventory, current_liabilities),
    cash_ratio           = safe_div(cash_bank_balance, current_liabilities),
    debt_equity_ratio    = safe_div(non_current_liabilities + current_liabilities,
                                     shareholders_equity),
    liability_to_assets  = safe_div(non_current_liabilities + current_liabilities,
                                     total_assets),
    eps                  = eps,
    firm_size_log        = log(pmax(total_assets, 1))   # size control, log scale
  )

# Winsorize (cap extreme outliers at 1st/99th percentile) so a handful of
# firms with near-zero sales/assets in a given year don't dominate every model
winsorize <- function(x, p = 0.01) {
  q <- quantile(x, probs = c(p, 1 - p), na.rm = TRUE)
  x[x < q[1]] <- q[1]
  x[x > q[2]] <- q[2]
  x
}

# NOTE: debt_equity_ratio already captures leverage; an "equity_multiplier"
# (assets/equity) was deliberately left out because it is a near-perfect
# linear function of debt_equity_ratio and creates a degenerate (zero-variance)
# component in the PCA below. Keep only one leverage measure to avoid this.
ratio_vars <- c("net_profit_margin", "gross_profit_margin", "operating_margin",
                 "roa", "roe", "roce", "asset_turnover", "inventory_turnover",
                 "receivables_turnover", "current_ratio", "quick_ratio",
                 "cash_ratio", "debt_equity_ratio", "liability_to_assets",
                 "firm_size_log")

ratios_w <- ratios %>% mutate(across(all_of(ratio_vars), winsorize))


## 1. CORRELATION ANALYSIS
## Which financial ratios move together?


cor_data <- ratios_w %>% select(all_of(ratio_vars)) %>% na.omit()
cor_mat  <- cor(cor_data, use = "complete.obs")

print(round(cor_mat, 2))

png("01_correlation_heatmap.png", width = 1100, height = 1100, res = 130)
corrplot(cor_mat, method = "color", type = "upper", tl.col = "black",
         tl.cex = 0.75, addCoef.col = "grey40", number.cex = 0.55,
         title = "Correlation Matrix of Financial Ratios", mar = c(0, 0, 2, 0))
dev.off()
