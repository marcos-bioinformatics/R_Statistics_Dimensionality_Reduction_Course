#---------------------------------------------------------------------------#
####################### PRINCIPAL COMPONENT ANALYSIS ########################
#---------------------------------------------------------------------------#

# Install and load the appropriate packages
install.packages("FactoMineR")
install.packages("factoextra")
library(FactoMineR)
library(factoextra)
library(readxl)
library(dplyr)
library(tableone)

# Load microbiome data: clr_assay (abundance of 94 bacterial genera in 35 mouse
# samples, after a centred log-ratio transformation) and design (diet and group
# of each sample)
load("Data/microbiome_data.RData")
dim(clr_assay)
head(design)

# Principal Component Analysis
res.pca <- PCA(clr_assay, graph = FALSE, scale.unit = TRUE)

#Eigenvalues measure the amount of variation retained by each principal component.
get_eigenvalue(res.pca)

# Scree plot
fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 70),main = "")

# Get vars
var <- get_pca_var(res.pca)
var

# Coordinates of variables
head(var$coord)

# Contributions to the dimensions
head(var$contrib)
varcontrib <- var$contrib

# Individual plot
fviz_pca_ind(res.pca, col.ind = design$Diet,
             pointsize=2,
             pointshape=21,
             fill="black",
             repel = TRUE,
             addEllipses = FALSE,
             legend.title="Conditions",
             title="Principal Components Analysis")


fviz_contrib(res.pca, choice = "ind", axes = 1:2)
fviz_contrib(res.pca, choice = "var", axes = 1:2)


#---------------------------------------------------------------------------#
####################### PCA WITH GENE EXPRESSION DATA #######################
#---------------------------------------------------------------------------#

# RNA-seq counts of airway smooth muscle cells from four donors (cell),
# treated or not with dexamethasone (dex): the airway dataset (Himes et al. 2014)
gene_expression <- read.csv2("Data/gene_expression.csv", row.names = 1)
gene_data <- read.csv2("Data/gene_data.csv", row.names = 1)
dim(gene_expression)
gene_data[, c("cell", "dex")]

# Remove genes with low counts and normalise: log2 of counts per million
gene_expression <- gene_expression[rowSums(gene_expression >= 10) >= 4, ]
log_cpm <- log2(t(t(gene_expression) / colSums(gene_expression)) * 1e6 + 1)

# Keep the 500 genes with the highest variance, with samples as rows
top_genes <- order(apply(log_cpm, 1, var), decreasing = TRUE)[1:500]
res.pca.genes <- PCA(t(log_cpm[top_genes, ]), graph = FALSE, scale.unit = FALSE)

fviz_eig(res.pca.genes, addlabels = TRUE)
fviz_pca_ind(res.pca.genes, habillage = factor(gene_data$dex), repel = TRUE,
             title = "PCA of gene expression")
fviz_pca_ind(res.pca.genes, habillage = factor(gene_data$cell), repel = TRUE,
             title = "PCA of gene expression")


#---------------------------------------------------------------------------#
####################### FACTOR ANALYSIS OF MIXED DATA #######################
#---------------------------------------------------------------------------#

# Load the hematoma case-control dataset (caso_control.xlsx). The data are
# SYNTHETIC (Data/generate_synthetic_data.R): no real patients
hematoma <- read_excel("Data/caso_control.xlsx")
hematoma <- as.data.frame(hematoma)
str(hematoma)

# Convert variables to appropriate format
hematoma[,c(1,2,3,4,8,10,11,12,14,15,18,20)] <- lapply(hematoma[,c(1,2,3,4,8,10,11,12,14,15,18,20)], factor)
str(hematoma)

# Set patient number to rownames and remove first column
rownames(hematoma) <- hematoma$Pacient
hematoma <- hematoma[,-1]
str(hematoma)

## FAMD
# Compute FAMD analysis
res.famd <- FAMD(hematoma, ncp = 8, graph = FALSE)

# Get eigenvalues
eig.val <- get_eigenvalue(res.famd)
eig.val

# An eigenvalue > 1 indicates that PCs account for more variance than
# accounted by one of the original variables in standardized data. This is
# commonly used as a cutoff point for which PCs are retained. This holds true
# only when the data are standardized.

# Scree plot
fviz_eig(res.famd, addlabels = TRUE)

# Get vars
var <- get_famd_var(res.famd)
var

# Coordinates of variables
head(var$coord)

# Contributions to the dimensions
head(var$contrib)
varcontrib <- var$contrib


options(ggrepel.max.overlaps = Inf)
# Plot of variables
fviz_famd_var(res.famd, geom = "text", repel = TRUE)
# Contribution to the first dimension
fviz_contrib(res.famd, "var", axes = 1)
# Contribution to the second dimension
fviz_contrib(res.famd, "var", axes = 2)
# Contribution to the third dimension
fviz_contrib(res.famd, "var", axes = 3)
# Contribution to the fourth dimension
fviz_contrib(res.famd, "var", axes = 4)

# Individual plot
fviz_famd_ind(res.famd,
              geom = "point",
              pointsize = 2,
              habillage = "Hematoma", # color by groups
              addEllipses = TRUE, ellipse.type = "confidence",
              repel = TRUE # Avoid text overlapping
)


# Multiple factor map
fviz_ellipses(res.famd, c("Hematoma", "Tipus H", "Material sutura",
                          "Indicació oncológica", "Mobilitzador"),
              geom = "point",
              pointsize = 2,
              addEllipses = TRUE,
              ellipse.type = "confidence",
              ellipse.level = 0.68)


# Check the statistics with tableOne
tableOne <- CreateTableOne(vars = colnames(select(hematoma, -"Hematoma")),
                           strata = c("Hematoma"),
                           data = hematoma)

tableOne$CatTable
tableOne$ContTable
