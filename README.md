# PARSEC - Batch and Cohort Effect Correction using Linear Mixed Models in R

## 1. Description
This algorithm performs **batch effect** and **cohort effect correction** on intensity data using a statistical modeling approach based on linear mixed models (LMM). This tool is especially suited for omics or high-throughput datasets, where batch or injection order can introduce unwanted variability.

The correction includes:
- Log transformation of intensities
- Batch-wise standardization (z-score normalization)
- Linear mixed-effects modeling using injection order and random batch effects
- Residual extraction and back-transformation of the signal

✨ Features:
- Handles multiple intensity columns simultaneously
- Corrects for both injection order and batch-specific effects
- Optional visualization (if `ggplot2` and `patchwork` are enabled)
- Integrates with command-line tools and Galaxy workflows

## 🎥 Visuals
If desired, before/after boxplots of batch effects can be visualized using `ggplot2`. 
These are currently commented out in the code but can be easily activated.

## 2. Prerequisites

### 1. Install R
Install from: [https://cran.r-project.org/](https://cran.r-project.org/)

### 2. Install Required Packages
```r
install.packages(c("dplyr", "lme4", "ggplot2", "patchwork", "optparse"))
```

| Package       | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| `dplyr`       | Efficient data manipulation                                  |
| `lme4`        | Fit linear mixed-effects models                              |
| `ggplot2`     | Visualize intensity distributions                            |
| `patchwork`   | Combine ggplot2 plots into panels                            |
| `optparse`    | Handle command-line options                                  |

### 3. System Requirements
- OS: Windows, MacOS, or Linux
- R ≥ 4.0 recommended

## 🚀 Usage

To run the algorithm from terminal:

```bash
Rscript ./parsec.R -i data_test.csv -o data_output.csv
```

### Command-line Arguments
- `-i` or `--input`: CSV file with columns `Batch`, `SampleID`, `Injection_Order`, and intensity columns (e.g., `Ion1`, `Ion2`).
- `-o` or `--output`: Name for the processed output CSV file.

### Example Input
```csv
Batch,SampleID,Injection_Order,Ion1,Ion2
A,1,1,120,230
A,2,2,150,260
B,3,1,110,200
B,4,2,140,240
```

## 🧠 How it Works (Algorithm)

### Step 1: Log-transform intensities
```r
mutate(across(all_of(intensity_cols), log1p))
```
Improves normality of data distribution.

### Step 2: Z-score normalization by batch
```r
group_by(batch) %>% mutate(across(intensity_cols, ~ scale(.x)[, 1]))
```
Ensures mean = 0 and SD = 1 within each batch.

### Step 3: Linear Mixed-Model Correction
```r
Ion ~ Injection_Order + (1|Batch)
```
Accounts for systematic cohort effects while removing batch bias.

### Step 4: Back-transformation
```r
mutate(across(all_of(intensity_cols), expm1))
```
Returns corrected intensities to original scale.


## 👥 Developer contact
- Elfried Salanon : magneficat.salanon@gmail.com
- Marie Lefebvre : marie.lefebvre@inrae.fr

## Citation
@softwareversion{swh-dir-f166076,
    author = "Salanon, Elfried  and Comte, Blandine  and Boccard, Julien  and Pujos-Guillot, Estelle ",
    organization = "Université Clermont Auvergne, INRAE, UNH, Plateforme d’Exploration du Métabolisme, MetaboHUB Clermont, Clermont-Ferrand, France and School of Pharmaceutical Sciences, University of Geneva, Geneva, Switzerland",
    license = "CC-BY-NC-4.0",
    abstract = "This algorithm performs batch effect and cohort effect correction on intensity data using a statistical modeling approach based on linear mixed models (LMM). This tool is especially suited for omics or high-throughput datasets, where batch or injection order can introduce unwanted variability.",
    date = "2025-06-13",
    year = "2025",
    month = jun,
    file = "https://github.com/inrae/PARSEC",
    repository = "https://github.com/inrae/PARSEC",
    title = "PARSEC",
    version = "1.0.0",
    swhid = "swh:1:dir:f16607641d45c7ae90571e847660d9040ca5723f;origin=https://github.com/inrae/PARSEC;visit=swh:1:snp:6ead07484c3aa11bdecba951b42a5d037e1cbf0c;anchor=swh:1:rev:51c7d9c1e08354ffcccb208e3f355a4cd6a9d60b"
}
