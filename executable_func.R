# r-lint-disable

# Charger les bibliothèques nécessaires
library(optparse)
library(dplyr)
library(lme4)
library(ggplot2)
library(patchwork)

batch_cohort_correction <- function(data, batch_col, sample_col, intensity_cols, output_file) {
  
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

  ### Visualisation des effets de lot avant/après ###
  
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
  
  output_dir <- "img/"  # Répertoire de sortie
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)  # Crée le dossier s'il n'existe pas
  
  output_path <- file.path(output_dir, output_file)

  # Sauvegarde du graphique
  ggsave(output_path, plot = (p1 + p2), width = 10, height = 5)

  cat("✅ Image sauvegardée :", output_path, "\n")

  return(data)
}

### Gestion des arguments de la ligne de commande ###

# Définition des options
option_list <- list(
  make_option(c("-i", "--input"), type = "character", default = "data.csv", help = "Fichier de données pour traitement", metavar = "FILE"),
  make_option(c("-o", "--output"), type = "character", default = "figure.png", help = "Fichier d'image de sortie", metavar = "FILE")
)

# Création du parser
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Vérification que le fichier d'entrée existe
if (!file.exists(opt$input)) {
  stop(paste("❌ Erreur : Le fichier", opt$input, "n'existe pas."))
}

# Charger les données
data_set <- read.csv(opt$input, header = TRUE, sep = ",")

# Vérifier les colonnes nécessaires
required_columns <- c("Batch", "SampleID", "Ion1", "Ion2", "Injection_Order")
missing_columns <- setdiff(required_columns, colnames(data_set))

if (length(missing_columns) > 0) {
  stop(paste("❌ Erreur : Les colonnes suivantes sont manquantes dans le fichier CSV :", paste(missing_columns, collapse = ", ")))
}

# Colonnes d'intensité
intensity_cols <- c("Ion1", "Ion2")

# Appliquer la correction
corrected_data <- batch_cohort_correction(data_set, "Batch", "SampleID", intensity_cols, opt$output)

cat("✅ Traitement terminé avec succès !\n")
