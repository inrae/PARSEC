# PARSEC

## 1. Background
This operating procedure describes the implementation of a correction algorithm for batch and cohort effects in R. 
The aim is to harmonize metabolomic data from several studies in the absence of long-term Quality Controls.

## 2. Prerequisites
- Installation of R and RStudio.
- Installation of `lme4`, `dplyr`, and `tidyverse` libraries.
- CSV format dataset containing the following columns:
  - SampleID: Sample identifier
  - Batch: Batch number
  - Injection_Order` : Injection order
  - Ion1, Ion2, ...` : Intensities of the various ions

## 3. Execution procedure in R

### 3.1 Data import
1. Load CSV file into R :

```r
# Load libraries
library(dplyr)
library(lme4)

# Read data
data <- read.csv(“data.csv”)
```

### 3.2. Executing the R script
1. Copy the following code into RStudio and run it:

```r

# Correction function
denoising_correction <- function(data, batch_col, sample_col, intensity_cols) {
  data <- data %>% mutate(across(all_of(intensity_cols), log1p))
  
  for (col in intensity_cols) {
    data <- data %>%
      group_by(!!sym(batch_col)) %>%
      mutate(!!sym(col) := scale(!!sym(col), center = TRUE, scale = TRUE)) %>%
      ungroup()
  }
  
  for (col in intensity_cols) {
    formula <- as.formula(paste(col, “~ Injection_Order + (1|”, batch_col, “)”))
    model <- lmer(formula, data = data, REML = TRUE)
    data[[col]] <- residuals(model)
  }
  
  data <- data %>% mutate(across(all_of(intensity_cols), expm1))
  return(data)
}

# Apply processing
intensity_columns <- names(data)[grepl(“Ion”, names(data))]
corrected_data <- denoising_correction(data, “Batch”, “SampleID”, intensity_columns)

# Save corrected file
write.csv(corrected_data, “corrected_data.csv”, row.names = FALSE)
```

### 3.3. Exporting results
1. The `corrected_data.csv` file will contain the corrected values.
2. Visualize results via PCA or density curves:

```r
library(ggplot2)
library(FactoMineR)

pca_results <- PCA(corrected_data[ , intensity_columns], scale.unit = TRUE, graph = FALSE)
plot(pca_results, choice = “ind”)
```

## 4. example of a dataset
A fictitious example of a dataset to be tested:

| SampleID | Batch | Injection_Order | Ion1 | Ion2 |
|----------|-------|----------------|------|------|
| 1 | 1 | 5 | 500 | 300 |
| 2 | 1 | 15 | 520 | 310 |
| 3 | 2 | 25 | 490 | 290 |
| 4 | 2 | 35 | 505 | 295 |
