# Introduction to R, Applied Statistics, and Dimensionality Reduction

Course objective: to acquire a sufficient foundation in R to manipulate data frames, visualize data, and perform statistical tests.

Each module has a slideshow (`.pptx`), an R script with the lesson and the exercises, and an R script with the solutions (`_exercise.R`).

## Module I — Introduction to R

`1_intro_R_basics.R`, `2_data_importing_and_data_cleaning.R`

- R and RStudio: installation, tools, and packages
- Types of data
- Arithmetic operations
- Vectors
- Matrices
- Logical values and logical operators
- Characters
- Factors
- Data frames
- Special values
- Functions
- Conditionals and loops
- Data importing (CSV, Excel, SPSS and FASTA files)
- Data cleaning: duplicates, wrong values and missing data
- Basic data visualization

## Module II — Applied Statistics with R

`3_statistics_in_R.R`

- Summary statistics
  - Mean
  - Median
  - Standard deviation
  - IQR
- Introduction to statistical inference
- Parametric assumptions: normality and homoscedasticity
- Inference in quantitative data
- Comparing two groups
  - t-test (Student and Welch)
  - Mann–Whitney test
- Comparing more than two groups
  - ANOVA
  - Kruskal–Wallis test
- Post-hoc tests
  - Tukey's test
  - Bonferroni correction
  - Dunn's test
- Correlation
  - Pearson
  - Spearman
- Inference in qualitative data
  - Chi-square test
  - Fisher's exact test
- Automated tables and reports: GGally, DataExplorer, tableone, compareGroups

## Module III — Dimensionality Reduction

`4_dimensional_reduction.R`

- Introduction to dimensionality reduction
- Principal Component Analysis (PCA)
- PCA with microbiota data
- PCA with gene expression data
- Factor Analysis of Mixed Data (FAMD) with clinical data

## Practical exercises

Data cleaning (module I) and statistical analysis (module II) of clinical data.

## Data

**The clinical datasets are synthetic.** They were generated from scratch with `Data/generate_synthetic_data.R`, using made-up distributions: they keep the variable names and types of the exercises, but they do not describe real patients and their results have no clinical meaning.

| File | Content | Source |
|---|---|---|
| `stenting.sav` | Stroke patients treated with mechanical thrombectomy, with or without intracranial stenting (5,166 records, with duplicates and missing values to clean) | Synthetic |
| `data_cleaning_age.csv` | `stenting.sav` after the cleaning exercise of module I | Synthetic |
| `hematoma.xlsx`, `caso_control.xlsx` | Women who underwent hysterectomy, with or without a post-surgical hematoma (96 patients) | Synthetic |
| `error.sav`, `experim.sav` | Survey data with errors to practise data screening, and a small experimental dataset | Pallant J. *SPSS Survival Manual* (Open University Press) |
| `Health_AnimalBites.csv` | Animal bites reported in Louisville, Kentucky | Kaggle |
| `gene_expression.csv`, `gene_data.csv` | RNA-seq counts of airway smooth muscle cells treated or not with dexamethasone (*airway* dataset) | Himes BE, et al. *PLoS ONE* 9(6): e99625 (2014) |
| `ASV_seqs_table.xlsx`, `rep-seqsAll.fasta` | 16S rRNA amplicon sequence variants (ASVs): abundance table and sequences | Made-up example data |
| `microbiome_data.RData`, `metabolites.csv` | Gut microbiota at genus level (CLR-transformed) and metabolic measurements of 35 samples in diet groups | Made-up example data |
| `protein.expression.csv` | Small example table of protein expression | Made-up example data |

## Requirements and usage

R (≥ 4.1) and RStudio. Each script installs or loads the packages it uses; the main ones are readxl, haven, dplyr, ggplot2, summarytools, car, FSA, GGally, DataExplorer, tableone, compareGroups, FactoMineR and factoextra.

Open the course folder as the working directory (in RStudio, *Session → Set Working Directory*) and run the scripts line by line: the exercise templates contain blanks (`____`) to fill in.

## How to cite

If you use or adapt these materials, please credit them as:

> Elizalde-Horcada M. *Introduction to R, Applied Statistics, and Dimensionality Reduction* (course materials). GitHub: https://github.com/marcos-bioinformatics/R_Statistics_Dimensionality_Reduction_Course

## License

The course materials (slides, scripts and synthetic data) are licensed under the [Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/): you can share and adapt them, also commercially, as long as you give appropriate credit (see *How to cite*), link to the license and indicate if changes were made. See [LICENSE](LICENSE).

The third-party datasets listed in *Data* (Pallant, Kaggle and *airway*) keep the terms of their original sources.
