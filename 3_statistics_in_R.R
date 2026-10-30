#---------------------------------------------------------------------------#
############################# STATISTICS WITH R #############################
#---------------------------------------------------------------------------#

library(readxl)
library(ggplot2)
library(dplyr)
library(summarytools)
library(car)

#---------------------------------------------------------------------------#
######################## INFERENCE ON QUANTITATIVE DATA #####################
#---------------------------------------------------------------------------#

# We are going to study the parametric assumptions on some generated data.
# Then we will compute the appropriate statistical test.

# Construct some random data (plotting, parametric assumptions, t-test, ANOVA)
set.seed(20)
df <- data.frame(age = as.integer(rnorm(200, mean = 47, sd = 15)),
                 sex = factor(sample(c("M", "F"), 200, replace = TRUE)),
                 weight = rnorm(200, mean = 67, sd = 20),
                 dose = factor(sample(c("high", "mid", "low", "no"), 200, replace = TRUE)),
                 non_normal = sample(1:100, 200, replace = TRUE))

# Inspect the data
table(df$age)
table(df$sex)
table(df$weight)
table(df$dose)
descr(df)

# Check normality graphically
hist(df$age, prob = TRUE, main = "Histogram of age", las = 1, xlab = "Age")
lines(density(df$age))
qqnorm(df$age, main = "QQ plot of age")
qqline(df$age) # Normal data fall close to this line

# Check for normality with Shapiro Test
shapiro.test(df$age)

# Check normality for age in each sex
tapply(df$age, df$sex, shapiro.test)

# Check homocedasticity for age and weight between sexes. Levene's test uses
# the mean (center = mean); with center = median (the default of leveneTest) it
# is the Brown-Forsythe test, more robust when data are not normal
leveneTest(df$weight, df$sex, center = mean)
leveneTest(df$age, df$sex, center = mean)

# Compute a t-test for age between sexes
boxplot(age ~ sex, data = df,
        horizontal = FALSE,
        lwd = 1,
        xlab = "sex",
        ylab = "age",
        col = c(3,4))

# Student's t-test assumes equal variances (var.equal = TRUE). Welch's t-test,
# R's default, does not, and is a safe choice in general
t.test(df$age ~ df$sex, var.equal = TRUE)
t.test(df$age ~ df$sex)

# Compute a t-test for weight between sexes
boxplot(weight ~ sex, data = df,
        horizontal = FALSE,
        lwd = 1,
        xlab = "sex",
        ylab = "weight",
        col = c(3,4))

t.test(df$weight ~ df$sex)

# Check for the variable called non-normal: Mann-Whitney (Wilcoxon rank-sum) test
hist(df$non_normal)
shapiro.test(df$non_normal)
wilcox.test(df$non_normal ~ df$sex)

# Compute an ANOVA test between dose and weight
boxplot(weight ~ dose, data = df,
        horizontal = FALSE,
        lwd = 1,
        xlab = "dose",
        ylab = "weight",
        col = c(1,2,3,4))

anova_test <- aov(weight ~ dose, data = df)

# ANOVA assumptions: normal residuals and equal variances between groups
shapiro.test(residuals(anova_test))
leveneTest(weight ~ dose, data = df, center = mean)

summary(anova_test)

# Post-hoc tests: which groups differ? Tukey's test, or pairwise t-tests with
# the Bonferroni correction for multiple comparisons
TukeyHSD(anova_test)
pairwise.t.test(df$weight, df$dose, p.adjust.method = "bonferroni")

# When the data are not normal, compare more than two groups with the
# Kruskal-Wallis test, and use Dunn's test as post-hoc test
boxplot(non_normal ~ dose, data = df, col = c(1,2,3,4))
kruskal.test(non_normal ~ dose, data = df)

install.packages("FSA")
library(FSA)
dunnTest(non_normal ~ dose, data = df, method = "bonferroni")

# Compute correlation between age and weight
ggplot(df, aes(x=age, y=weight)) +
  geom_point(size=2)

cor.test(df$age, df$weight) # Pearson, for normal data
cor.test(df$age, df$weight, method = "spearman") # Spearman, based on ranks


#---------------------------------------------------------------------------#
################################# CORRELATION ###############################
#---------------------------------------------------------------------------#

# Let's load the data we cleaned previously (synthetic stenting data), and
# simply ask if age might be correlated with the neurological scales.

# Load the data. The first column has the patient ids, so we use it as rownames
stent <- read.csv2("Data/data_cleaning_age.csv", row.names = 1)

# Inspect the quantitative variables
hist(stent$EscalaRACE)
hist(stent$NIHSSinicial)
hist(stent$Edat)

# The RACE (0-9) and NIHSS (0-42) scales are ordinal, and their distributions
# are skewed: we use Spearman's correlation, which is based on ranks. Let's
# plot them first

ggplot(data = stent, aes(x= Edat, y = EscalaRACE)) +
  geom_jitter(colour = "#0c4c8b", height = 0.2) + # jitter separates repeated values
  theme_minimal()

cor.test(stent$Edat, stent$EscalaRACE, method = "spearman")

ggplot(data = stent, aes(x= Edat, y = NIHSSinicial)) +
  geom_jitter(colour = "#0c4c8b", height = 0.2) +
  theme_minimal()

cor.test(stent$Edat, stent$NIHSSinicial, method = "spearman")

# Why there is such a low correlation bewtheen age and this scales??

# And between both scales?
cor.test(stent$EscalaRACE, stent$NIHSSinicial, method = "spearman")


#---------------------------------------------------------------------------#
######################### INFERENCE ON QUALITATIVE DATA #####################
#---------------------------------------------------------------------------#

# To test if there are differences between the proportions of the two groups
# (STENTINTRAsino = 1 vs STENTINTRAsino = 0), we are going to perform some
# chi-square tests. We are going to ask ourselves: are those patients with
# hypertension more likely to receive a stent? are men or women more
# likely to receive a stent?


# First, let's convert these qualitative variables into factors
str(stent)
stent$Sexe <- as.factor(stent$Sexe)
stent$STENTINTRAsino <- as.factor(stent$STENTINTRAsino)
stent$CodiHipertensió <- as.factor(stent$CodiHipertensió)
str(stent)

# Now let's make some contingency tables and perform the chi-square tests

sex <- table(stent$Sexe, stent$STENTINTRAsino)
sex
prop.table(sex, margin = 2)

chisq.test(stent$STENTINTRAsino, stent$Sexe)

hypertension <- table(stent$CodiHipertensió, stent$STENTINTRAsino)
hypertension
prop.table(hypertension, margin = 2) # 1 for rows, 2 for columns

chisq.test(stent$STENTINTRAsino, stent$CodiHipertensió)

# The chi-square test needs expected counts of at least 5 in each cell. With
# small samples, use Fisher's exact test instead
chisq.test(hypertension)$expected
fisher.test(hypertension)

#---------------------------------------------------------------------------#
########################### AUTOMATED PACKAGES IN R #########################
#---------------------------------------------------------------------------#

#### Get custom plots for selected variables with GGally
install.packages("GGally")
library(GGally)

stent %>%
  dplyr::select(Edat, NIHSSinicial, ASPECTSscore, STENTINTRAsino) %>%
  ggpairs(columns = 1:3, mapping = aes(color = STENTINTRAsino, alpha = 0.5))

#### Do exploratory data analysis with DataExplorer
install.packages("DataExplorer")
library(DataExplorer)

stent %>%
  create_report(
    output_file = "eda_report_stenting.html",
    report_title = "EDA Report - Stenting data (synthetic)",
    y = "STENTINTRAsino"
  )

#### Get a statistics table with tableone
install.packages("tableone")
library(tableone)

# Variables coded with numbers that are categorical
categorical <- c("Sexe", "CodiIctusdespertariniciincert", "tPAsino", "ACIT",
                 "CodiACMM1", "CodiACMM2", "CodiAB", "CodiHipertensió",
                 "CodiFibril.lacióauricular")

# We compare the patients with and without stent (STENTINTRAsino)
tableOne <- CreateTableOne(vars = setdiff(colnames(stent), "STENTINTRAsino"),
                           strata = "STENTINTRAsino",
                           factorVars = categorical,
                           data = stent)


# We pass the continuous variables that are not normally distributed in the
# "nonnormal" argument: they are summarised with the median and IQR and
# compared with non-parametric tests
non_normal <- c("EscalaRACE", "NIHSSinicial", "ASPECTSscore")
print(
  tableOne,
  nonnormal = non_normal,
  showAllLevels = TRUE)

# Inspect tables
tableOne$CatTable
tableOne$ContTable

# Save the table into a .csv file
table_one <- print(tableOne, nonnormal = non_normal, showAllLevels = TRUE,
                   quote = FALSE, noSpaces = TRUE, printToggle = FALSE)
write.csv(table_one, "table_one.csv")


# Use compareGroups to compute univariate statistics
install.packages("compareGroups")
library(compareGroups)

res <- compareGroups(STENTINTRAsino ~ ., data = stent)
res
restab <- createTable(res)
export2word(restab, "compare_groups.docx")

#---------------------------------------------------------------------------#
######################### EXERCISE SOME R SKILLS HERE #######################
#---------------------------------------------------------------------------#

library(readxl)
library(tableone)
library(tidyr)
library(dplyr)
library(ggplot2)

# The hematoma dataset contains 96 patients that have been through histerectomy.
# Some of these patients suffer from bruising as a common complication, so the
# dependent variable is Hematoma (1 = yes, 0 = no). We are interested in the possible
# effect of different variables on the outcome but the type of procedure (Via robótica),
# suture material (Material sutura) seems to be the most relevant ones.
# We will perform some plots and correlations, and compute some chi-square test
# on the next section over the hematoma dataset.
# The data are SYNTHETIC (Data/generate_synthetic_data.R): no real patients.

# Load the hematoma dataset with read_excel()


# Convert it to data frame


# Set patients as rownames and remove that column


# Inspect it with str, summary, descr


# Convert the categorical variables to factor (you can use lapply)


# Inspect Edat, Peso, Charlson and Tiempo Cirugía with hist


# Inspect numerical variables for hematoma = 1 and hematoma = 0 separately (use boxplots)


# Seems like there might be some differences in these variables between
# patients with bruising and patients with no bruising. Do some t-tests
# (or Wilcoxon tests for non-normal or ordinal variables, such as Charlson)!


# Now, build contigency tables for Via Robótica, Diabetes and Inmuno
# Then, use chi-square (or Fisher's exact test, if the expected counts are
# small) to look for differences between proportions


# Now, you can compare your results with tableOne's automatic results


# Let's see if Age and Hemograma are correlated (use cor.test)


# Let's see if Age and BMI are correlated



#---------------------------------------------------------------------------#
################## EXERCISE SOME R SKILLS HERE LIGHT VERSION ################
#---------------------------------------------------------------------------#

library(readxl)
library(tableone)
library(tidyr)
library(dplyr)
library(ggplot2)

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

# Convert it to data frame
hematoma <- ____(hematoma)

# Set patients as rownames and remove that column
____(hematoma) <- hematoma$Pacient
hematoma <- hematoma[,__]

# Inspect it with str, summary, descr


# Convert the categorical variables to factor with lapply
hematoma[,c(1,2,3,8,9,10,14)] <- ____(hematoma[,c(1,2,3,8,9,10,14)], factor)
str(hematoma)

# Inspect Edat, Peso, Charlson and Tiempo Cirugía with hist
hist(____)


# Inspect numerical variables for hematoma = 1 and hematoma = 0 separately (use boxplots)
boxplot(____ ~ ____, data = hematoma,
        horizontal = FALSE,
        lwd = 1,
        xlab = "hematoma",
        ylab = "edad",
        col = c(3,4))


# Seems like there might be some differences in these variables between
# patients with bruising and patients with no bruising. Do some t-tests
# (or Wilcoxon tests for non-normal or ordinal variables, such as Charlson)!
t.test(hematoma$____ ~ hematoma$____)
wilcox.test(hematoma$Charlson ~ hematoma$____)


# Now, build contigency tables for Via Robótica, Diabetes and Inmuno
# Then, use chi-square (or Fisher's exact test, if the expected counts are
# small) to look for differences between proportions
via <- ____(hematoma$`Via robótica`, hematoma$Hematoma)
via
prop.table(via, margin = 2)
chisq.test(hematoma$`Via robótica`, ____)

diabetes <- table(hematoma$Diabetes, hematoma$Hematoma)
diabetes
prop.table(____, margin = 2)
chisq.test(diabetes)$expected # Are the expected counts at least 5?
fisher.test(diabetes)

inmuno <- table(hematoma$Inmuno, hematoma$Hematoma)
inmuno
prop.table(inmuno, margin = 2)
____(inmuno)

# Now, you can compare your results with tableOne's automatic results
tableOne <- CreateTableOne(vars = colnames(select(hematoma, -"Hematoma")),
                           strata = c("Hematoma"),
                           data = ____)

tableOne$CatTable
tableOne$ContTable


# Let's see if Age and Hemograma are correlated (use cor.test)
ggplot(data = hematoma, aes(x= Edat, y = Hemograma)) +
  geom_point(colour = "#0c4c8b") +
  theme_minimal()

____(hematoma$Edat, ____)


# Let's see if Age and BMI are correlated
ggplot(data = hematoma, aes(x= Edat, y = BMI)) +
  geom_point(colour = "#0c4c8b") +
  theme_minimal()

____(____, hematoma$BMI)

