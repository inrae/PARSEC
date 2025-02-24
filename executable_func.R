# Load necessary libraries
library(optparse)
library(dplyr)
library(lme4)
library(ggplot2)
library(patchwork)

batch_cohort_correction <- function(data, batch_col, sample_col, intensity_cols, output_file) { # nolint: line_length_linter.

  # Check if columns exist in data
  missing_cols <- setdiff(
    c(batch_col, sample_col, intensity_cols),
    colnames(data)
  )
  if (length(missing_cols) > 0) {
    stop(
      paste("Les colonnes suivantes sont manquantes dans le fichier :",
        paste(missing_cols, collapse = ", ")
      )
    )
  }

  # Save raw values for comparison
  data_raw <- data

  # Step 1: Log-transform intensities
  data <- data %>%
    mutate(across(all_of(intensity_cols), log1p))

  # Step 2: Batch-wise standardization
  data <- data %>%
    group_by(!!sym(batch_col)) %>%
    mutate(across(all_of(intensity_cols), ~ scale(.x, center = TRUE, scale = TRUE)[,1])) %>% ungroup() # nolint

  # Check if "Injection_Order" exist
  if (!"Injection_Order" %in% colnames(data)) {
    stop("Error: The ‘Injection_Order’ column is missing from the data. Make sure it's included.") # nolint
  }

  # Step 3: Mixed model to correct for cohort effect and injection order
  for (col in intensity_cols) {
    formula <- as.formula(
      paste0(col, " ~ Injection_Order + (1|", batch_col, ")")
    )
    model <- lmer(formula, data = data, REML = TRUE)
    data[[col]] <- residuals(model)
  }

  # Étape 4 : Inverse exponentiation

  data <- data %>%
    mutate(across(all_of(intensity_cols), expm1))  # salomon

  ### Visualization of before/after batch effects ###

  # col_to_plot <- intensity_cols[1]  # Select first column for visualization

  # Before correction
  # p1 <- ggplot(data_raw, aes(x = !!sym(batch_col), y = !!sym(col_to_plot), fill = !!sym(batch_col))) + geom_boxplot(alpha = 0.7) + theme_minimal() + ggtitle("Before correction") + labs(x = "Batch_col", y = "Intensity Ion1") # nolint

  # After correction
  # p2 <- ggplot(data, aes(x = !!sym(batch_col), y = !!sym(col_to_plot), fill = !!sym(batch_col))) + geom_boxplot(alpha = 0.7) + theme_minimal() + ggtitle("After correction") # nolint

  # Output directory
  output_dir <- "data_process/"

  # Create folder if it doesn't exist
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
  output_path <- file.path(output_dir, output_file)

  # Save graphic
  # ggsave(output_path, plot = (p1 + p2), width = 10, height = 5) #nolint

  cat("✅ Image sauvegardée :", output_path, "\n")
  write.csv(data, output_path, row.names = FALSE)
  cat(
    "LE dataframe modifié a été enregistrer avec les entête dans le repertoir dataprocess" #nolint
  )
  return(data)
}

### Managing command line arguments ###

# Definition of options
option_list <- list(
  make_option(
    c("-i", "--input"),
    type = "character",
    default = "data.csv",
    help = "Data file for processing",
    metavar = "FILE"
  ),
  make_option(
    c("-o", "--output"),
    type = "character",
    default = "data_proces.csv",
    help = "Output data file",
    metavar = "FILE"
  )
)

# Parser creation
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Check that input file exists
if (!file.exists(opt$input)) {
  stop(paste("❌ Error: The file", opt$input, "does not exist."))
}

# Load data
data_set <- read.csv(opt$input, header = TRUE, sep = ",")

# Check required column
required_columns <- c("Batch", "SampleID", "Ion1", "Ion2", "Injection_Order")
missing_columns <- setdiff(required_columns, colnames(data_set))

if (length(missing_columns) > 0) {
  stop(paste(
    "❌ Error: The following columns are missing from the CSV file:",
    paste(missing_columns, collapse = ", ")
  ))
}

# Intensity columns
intensity_cols <- c("Ion1", "Ion2")

# Apply correction
corrected_data <- batch_cohort_correction(
  data_set,
  "Batch",
  "SampleID",
  intensity_cols,
  opt$output
)
print(corrected_data)
cat("✅ Processing completed successfully !\n")
