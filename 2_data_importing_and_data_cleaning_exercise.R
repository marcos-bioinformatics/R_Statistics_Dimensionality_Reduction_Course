#---------------------------------------------------------------------------#
################### EXERCISE SOME R SKILLS HERE CORRECTION ##################
#---------------------------------------------------------------------------#

library(haven)
library(summarytools)

## We are going to load some clinical data and work with it. The objective is to
## inspect it and clean it. The STENTING dataset contains 5166 records of stroke
## patients treated with mechanical thrombectomy, with (STENTINTRAsino = 1) or
## without (STENTINTRAsino = 0) intracranial stenting. The data are SYNTHETIC
## (Data/generate_synthetic_data.R): they do not belong to real patients.
## The variables are detailed in the slideshows.

# Load the dataframe from .sav file
data <- read_sav("Data/stenting.sav")

# Check class of the dataframe. Convert it to dataframe
class(data)
data <- as.data.frame(data)

# Select or subset just the first 22 columns
data_cleaning <- data[,1:22]

# Remove the 2nd, 3rd, 7th, 14th, 16th, 18th and 22nd columns
data_cleaning <- data_cleaning[,-c(2,3,7,14,16,18,22)]

# Inspect the data with str(), summary() and descr()
str(data_cleaning)
summary(data_cleaning)
descr(data_cleaning)

# Try to set IdPacient as rownames (it will give an error, keep going)
rownames(data_cleaning) <- data_cleaning$IdPacient

# Check for duplicates in IdPacient using table() and duplicated(). Then, store them
# in a vector using which() and duplicated() After that, use that vector to eliminate
# duplicated patients from the dataframe.
table(duplicated(data_cleaning$IdPacient))
remove <- which(duplicated(data_cleaning$IdPacient))
data_cleaning <- data_cleaning[-remove,]
table(duplicated(data_cleaning$IdPacient))

# Try again to set IdPacient as rownames. Then, remove IdPacient column.
rownames(data_cleaning) <- data_cleaning$IdPacient
data_cleaning <- data_cleaning[,-1]

## At this point, we should have just our variables of interest, and no duplicated
## patients. We will examine each and every variable looking for errors, missing values
## and outliers.


# There are some empty values, convert them to NA's (try replace() function)
data_cleaning <- replace(data_cleaning, data_cleaning == "", NA)

# Now, inspect what variables contain NA's
is.na(data_cleaning)
colSums(is.na(data_cleaning))
colSums(is.na(data_cleaning)) > 0
colnames(data_cleaning)[colSums(is.na(data_cleaning)) > 0]

# For those variables that contain NA's, use table() + is.na()
table(is.na(data_cleaning$EscalaRACE))
table(is.na(data_cleaning$CodiIctusdespertariniciincert))
table(is.na(data_cleaning$NIHSSinicial))
table(is.na(data_cleaning$ASPECTSscore))
table(is.na(data_cleaning$ACIT))
table(is.na(data_cleaning$CodiACMM1))
table(is.na(data_cleaning$CodiACMM2))
table(is.na(data_cleaning$CodiAB))
table(is.na(data_cleaning$STENTINTRAsino))
table(is.na(data_cleaning$CodiHipertensió))
table(is.na(data_cleaning$CodiFibril.lacióauricular))


# Use na.omit() to keep just the patients with complete variables. We lose about
# half of the patients: in a real study we would report it, as the complete
# cases may differ from the rest
data_cleaning2 <- na.omit(data_cleaning)
nrow(data_cleaning)
nrow(data_cleaning2)

# Apply table to each column (using apply function)
apply(data_cleaning2, 2, FUN = table)

# Change the labels of ACIT (Si/No) to (S/N) with ifelse()
data_cleaning2$ACIT <- ifelse(data_cleaning2$ACIT == "No", "N", "S")

# Now that there are no errors, convert each variable to appropriate format:
# Sexe as FACTOR
# CodiIctusdespertariniciincert as FACTOR
# tPAsino as FACTOR
# ACIT as FACTOR
# CodiACMM1 as FACTOR
# CodiACMM2 as FACTOR
# CodiAB as FACTOR
# STENTINTRAsino as FACTOR
# CodiHipertensió as FACTOR
# CodiFibril.lacióauricular as FACTOR

data_cleaning2$Sexe <- as.factor(data_cleaning2$Sexe)
data_cleaning2$CodiIctusdespertariniciincert <- as.factor(data_cleaning2$CodiIctusdespertariniciincert)
data_cleaning2$tPAsino <- as.factor(data_cleaning2$tPAsino)
data_cleaning2$ACIT <- as.factor(data_cleaning2$ACIT)
data_cleaning2$CodiACMM1 <- as.factor(data_cleaning2$CodiACMM1)
data_cleaning2$CodiACMM2 <- as.factor(data_cleaning2$CodiACMM2)
data_cleaning2$CodiAB <- as.factor(data_cleaning2$CodiAB)
data_cleaning2$STENTINTRAsino <- as.factor(data_cleaning2$STENTINTRAsino)
data_cleaning2$CodiHipertensió <- as.factor(data_cleaning2$CodiHipertensió)
data_cleaning2$CodiFibril.lacióauricular <- as.factor(data_cleaning2$CodiFibril.lacióauricular)
str(data_cleaning2)

# Remove those patients under 40 years old
data_cleaning_age <- data_cleaning2[data_cleaning2$Edat >= 40,]

# Save it with write.csv2() and inspect it manually!
write.csv2(data_cleaning_age, "data_cleaning_age.csv")

# Save the cleaned dataframe as a workspace!
save(data_cleaning_age, file = "data_cleaning_age.RData")
