# r-lint-disable

batch_cohort_correction <- function(data, batch_col, sample_col, intensity_cols, output_file = "correction_plot.png") {
  
  # Chargement des bibliothèques nécessaires
  options(repos = c(CRAN = "https://cran.r-project.org"))  # Définit le miroir CRAN
  
  required_packages <- c("dplyr", "lme4", "ggplot2", "patchwork")
  installed_packages <- rownames(installed.packages())
  for (pkg in required_packages) {
    if (!(pkg %in% installed_packages)) install.packages(pkg, dependencies = TRUE)
  }

  library(dplyr)
  library(lme4)
  library(ggplot2)
  library(patchwork)  # Pour combiner plusieurs plots
  
  # Vérifier si les colonnes existent dans les données
  missing_cols <- setdiff(c(batch_col, sample_col, intensity_cols), colnames(data))
  if (length(missing_cols) > 0) {
    stop(paste("Les colonnes suivantes sont manquantes dans le fichier :", paste(missing_cols, collapse = ", ")))
  }

  # Sauvegarde des valeurs brutes pour comparaison
  data_raw <- data
  
  # Étape 1 : Log-transformation des intensités
  data <- data %>%
    mutate(across(all_of(intensity_cols), log1p))  # log1p(x) = log(1 + x)
  
  # Étape 2 : Standardisation batch-wise
  data <- data %>%
    group_by(!!sym(batch_col)) %>%
    mutate(across(all_of(intensity_cols), ~ scale(.x, center = TRUE, scale = TRUE)[,1])) %>%
    ungroup()
  
  # Vérifier si "Injection_Order" existe
  if (!"Injection_Order" %in% colnames(data)) {
    stop("Erreur : La colonne 'Injection_Order' est absente des données. Assurez-vous qu'elle est bien incluse.")
  }

  # Étape 3 : Modèle mixte pour corriger l'effet de cohorte et l'ordre d'injection
  for (col in intensity_cols) {
    formula <- as.formula(paste0(col, " ~ Injection_Order + (1|", batch_col, ")"))
    model <- lmer(formula, data = data, REML = TRUE)
    data[[col]] <- residuals(model)
  }

  # Étape 4 : Exponentiation inverse
  data <- data %>%
    mutate(across(all_of(intensity_cols), expm1))  # expm1(x) = exp(x) - 1

  ### 📊 Visualisation des effets de lot avant/après ###
  
  col_to_plot <- intensity_cols[1]  # Sélectionner une colonne pour la visualisation
  
  # Avant correction
  p1 <- ggplot(data_raw, aes(x = !!sym(batch_col), y = !!sym(col_to_plot), fill = !!sym(batch_col))) +
    geom_boxplot(alpha = 0.7) +
    theme_minimal() +
    ggtitle("Avant correction")
  
  # Après correction
  p2 <- ggplot(data, aes(x = !!sym(batch_col), y = !!sym(col_to_plot), fill = !!sym(batch_col))) +
    geom_boxplot(alpha = 0.7) +
    theme_minimal() +
    ggtitle("Après correction")
  
  output_dir <- "C:/Users/sgouiriloem/Documents/Salomon/PARSEC/parsec-algo-250102588/"
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)  # Crée le dossier s'il n'existe pas
  output_file <- file.path(output_dir, "output.png")

  # Sauvegarde du graphique
  ggsave(output_file, plot = (p1 + p2), width = 10, height = 5)

  return(data)
}

### Gestion des arguments de la ligne de commande ###
args <- commandArgs(TRUE)

if (length(args) < 2) {
  stop("Usage : Rscript script.R <fichier_csv> <fichier_png>")
}

filename <- args[1]  # Nom du fichier CSV
file_png <- args[2]  # Nom du fichier de sortie pour la visualisation

# Charger les données
data_set <- read.csv(filename, header = TRUE, sep = ",")

# Vérifier les colonnes nécessaires
required_columns <- c("Batch", "SampleID", "Ion1", "Ion2", "Injection_Order")
missing_columns <- setdiff(required_columns, colnames(data_set))

if (length(missing_columns) > 0) {
  stop(paste("Erreur : Les colonnes suivantes sont manquantes dans le fichier CSV :", paste(missing_columns, collapse = ", ")))
}

# Colonnes d'intensité
intensity_cols <- c("Ion1", "Ion2")

# Appliquer la correction
corrected_data <- batch_cohort_correction(data_set, "Batch", "SampleID", intensity_cols, file_png)

