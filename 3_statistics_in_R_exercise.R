#---------------------------------------------------------------------------#
################### EXERCISE SOME R SKILLS HERE CORRECTION ##################
#---------------------------------------------------------------------------#

library(readxl)
library(tableone)
library(tidyr)
library(dplyr)
library(ggplot2)
library(summarytools)

# The hematoma dataset contains 96 patients that have been through histerectomy.
# Some of these patients suffer from bruising as a common complication, so the
# dependent variable is Hematoma (1 = yes, 0 = no). We are interested in the possible
# effect of different variables on the outcome but the type of procedure (Via robótica),
# suture material (Material sutura) seems to be the most relevant ones.
# We will perform some plots and correlations, and compute some chi-square test
# on the next section over the hematoma dataset.
# The data are SYNTHETIC (Data/generate_synthetic_data.R): no real patients.

# Load the hematoma dataset with read_excel()
hematoma <- read_excel("Data/hematoma.xlsx")
class(hematoma)

# Convert to data frame
hematoma <- as.data.frame(hematoma)

# Set patients as rownames and remove that column
rownames(hematoma) <- hematoma$Pacient
hematoma <- hematoma[,-1]

# Inspect it with str, summary, descr
str(hematoma)
summary(hematoma)
descr(hematoma)

# Convert the categorical variables to factor with lapply (Hematoma, Tipus H,
# Via robótica, Tabaco, Diabetes, Inmuno and Material sutura)
hematoma[,c(1,2,3,8,9,10,14)] <- lapply(hematoma[,c(1,2,3,8,9,10,14)], factor)
str(hematoma)

# Inspect Edat, Peso, Charlson and Tiempo Cirugía with hist
hist(hematoma$Edat)
hist(hematoma$Peso)
hist(hematoma$BMI)
hist(hematoma$Charlson)
hist(hematoma$`Tiempo cirugia`)

# Inspect numerical variables for hematoma = 1 and hematoma = 0 separately (use boxplots)
boxplot(Edat ~ Hematoma, data = hematoma,
        horizontal = FALSE,
        lwd = 1,
        xlab = "hematoma",
        ylab = "edad",
        col = c(3,4))

boxplot(Peso ~ Hematoma, data = hematoma,
        horizontal = FALSE,
        lwd = 1,
        xlab = "hematoma",
        ylab = "peso",
        col = c(3,4))

boxplot(Charlson ~ Hematoma, data = hematoma,
        horizontal = FALSE,
        lwd = 1,
        xlab = "hematoma",
        ylab = "charlson",
        col = c(3,4))

boxplot(`Tiempo cirugia` ~ Hematoma, data = hematoma,
        horizontal = FALSE,
        lwd = 1,
        xlab = "hematoma",
        ylab = "tiempo cirugia",
        col = c(3,4))


# Seems like there might be some differences in these variables between
# patients with bruising and patients with no bruising. Do some t-tests
# (Welch's t-test, R's default, does not assume equal variances)

t.test(hematoma$Edat ~ hematoma$Hematoma)

t.test(hematoma$Peso ~ hematoma$Hematoma)

t.test(hematoma$`Tiempo cirugia` ~ hematoma$Hematoma)

# The Charlson index is an ordinal score with a skewed distribution: we use
# the Wilcoxon (Mann-Whitney) test
wilcox.test(hematoma$Charlson ~ hematoma$Hematoma)


# Now, build contigency tables for Via Robótica, Diabetes and Inmuno
# Then, use chi-square to look for differences between proportions. When the
# expected counts are smaller than 5, use Fisher's exact test
via <- table(hematoma$`Via robótica`, hematoma$Hematoma)
via
prop.table(via, margin = 2)
chisq.test(via)$expected
chisq.test(via)

diabetes <- table(hematoma$Diabetes, hematoma$Hematoma)
diabetes
prop.table(diabetes, margin = 2)
chisq.test(diabetes)$expected # Expected counts below 5: chi-square is not valid
fisher.test(diabetes)

inmuno <- table(hematoma$Inmuno, hematoma$Hematoma)
inmuno
prop.table(inmuno, margin = 2)
fisher.test(inmuno)

# Now, you can compare your results with tableOne's automatic results. We
# pass Charlson as non-normal, and ask for exact tests for Diabetes and Inmuno
tableOne <- CreateTableOne(vars = colnames(select(hematoma, -"Hematoma")),
                           strata = c("Hematoma"),
                           data = hematoma)

print(tableOne, nonnormal = "Charlson", exact = c("Diabetes", "Inmuno"))
tableOne$CatTable
tableOne$ContTable

# Let's see if Age and Hemograma are correlated
ggplot(data = hematoma, aes(x= Edat, y = Hemograma)) +
  geom_point(colour = "#0c4c8b") +
  theme_minimal()

cor.test(hematoma$Edat, hematoma$Hemograma)

# Let's see if Age and BMI are correlated
ggplot(data = hematoma, aes(x= Edat, y = BMI)) +
  geom_point(colour = "#0c4c8b") +
  theme_minimal()

cor.test(hematoma$Edat, hematoma$BMI)
