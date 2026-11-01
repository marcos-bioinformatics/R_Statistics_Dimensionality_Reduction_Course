#---------------------------------------------------------------------------#
############################ IMPORTING DATA IN R ############################
#---------------------------------------------------------------------------#

# Importing data into R is pretty straightforward. You have to know well the nature
# of your input file and find the appropriate function to do it. You will have to
# specify the path of the file and some other arguments if needed.

## IMPORTING .CSV FILES

# Importing .csv with read.csv and read.csv2. Template (replace path_to_filename):
# read.csv(path_to_filename,
#          sep = ",",
#          stringsAsFactors = TRUE)

# Animal bites reported in Louisville (Kentucky, USA), a public dataset from Kaggle
# Try to get it done with no arguments
data <- read.csv("Data/Health_AnimalBites.csv")
str(data)

# And with some arguments
data <- read.csv("Data/Health_AnimalBites.csv",
                 sep = ",", # Change it
                 stringsAsFactors = TRUE)
str(data)

# Now try to load metabolites with read.csv
metabolites <- read.csv("Data/metabolites.csv") # WHAT IS HAPPENING HERE?
metabolites <- read.csv2("Data/metabolites.csv")
str(metabolites)


## IMPORTING EXCEL FILES

# SEARCH for READXL AND INSTALL IT
library(readxl)

# Read a file with readxl, with the following template code:
# read_excel(path_to_filename,
#            sheet = 1,
#            col_names = TRUE,
#            skip = 0)

microbiome <- read_excel("Data/ASV_seqs_table.xlsx",
                  sheet = 1,
                  col_names = TRUE,
                  skip = 0)
str(microbiome)


## IMPORTING SPSS .sav FILEs with read_sav from the haven package

# SEARCH for HAVEN AND INSTALL IT
library(haven)

# error.sav is survey data from the SPSS Survival Manual (J. Pallant), with
# some errors introduced on purpose to practise data screening
error <- read_sav("Data/error.sav")
str(error) # TOO MUCH INFO RIGHT?


## IMPORTING FASTA files with read.fasta

install.packages("seqinr")
library(seqinr)

## Load the ASV sequences as a list from the FASTA file
seqs <- read.fasta("Data/rep-seqsAll.fasta", as.string = TRUE)
length(seqs)

# Convert the list into a dataframe with one row per sequence
seqs <- data.frame(id = names(seqs),
                   sequence = toupper(unlist(seqs))) # Convert characters to upper case
head(seqs)


## SAVING DATA to .csv FORMAT

# Data will be saved as specified in the current work directory. Templates:
# write.csv(variable_name, "name_of_the_file.csv")
# write.csv2(variable_name, "name of the_file.csv")
# write.table(variable_name, "name_of_the_file.csv")

write.csv(error, "error_csv1.csv", row.names = FALSE)
write.csv2(error, "error_csv2.csv", row.names = FALSE)
write.table(error, "error_table.csv") # What happens here??


#---------------------------------------------------------------------------#
############################ CLEANING DATA IN R #############################
#---------------------------------------------------------------------------#

## Here we are going to review some useful functions to clean data, with the
## survey data we have just saved
library(dplyr)
error <- read.csv("error_csv1.csv")

# First, we inspect the data
str(error)
glimpse(error)
summary(error)
install.packages("summarytools")
library(summarytools)
descr(error)

# We can manually remove any row or column easily

error <- error[,-c(10:ncol(error))] # remove all columns from the 10th to the end

str(error)

## The codes of the variables we keep are:
## sex: 1 = male, 2 = female
## marital: 1 to 8; child: 1 = yes, 2 = no; educ: 1 to 6 (education level)
## source: main source of stress (1 = work, 2 = partner, 3 = relationships, ...)
## smoke: 1 = smoker, 2 = non-smoker; smokenum: cigarettes per week

##### Check for duplicates, usually for sample names / identifiers

duplicated(error) # Are there any duplicated rows?
table(duplicated(error))
duplicated(error$id) # Are there any duplicated elements in this column?
table(duplicated(error$id))
duplicated_id <- error$id[duplicated(error$id)]
error[error$id == duplicated_id, ] # IS THIS REALLY A DUPLICATE????

# Both rows have the same id, but they are two different people (different sex
# and age): the error is in the id, not a duplicated record. Instead of deleting
# one of them, we give the second one a new id
error$id[duplicated(error$id)] <- max(error$id) + 1
table(duplicated(error$id))

##### Check for wrong values: compare them with the codes of each variable

table(error$sex)
table(error$educ)
summary(error$age)

which(error$sex == 3)
which(error$educ == 22)
which(error$age < 18) # This is a survey of adults

# CAREFUL WHEN CORRECTING DATA: we cannot know the right value (was sex 1 or 2?
# did educ 22 mean 2? was age 20, 32 or 52?). If we could check the original
# questionnaires we would correct them; if not, we set them to NA
error$sex[error$sex == 3] <- NA
error$educ[error$educ == 22] <- NA
error$age[error$age < 18] <- NA


##### Check for Missing data (NAs)

is.na(error) # Check the whole dataframe
table(is.na(error))

# We can omit all NA's, which will erase rows with at least 1 NA
# This is sometimes useful but discards a lot of data
error_no_NA <- na.omit(error)
nrow(error)
nrow(error_no_NA)


# It's better to look though each variable
table(is.na(error$sex)) # Check concrete variables
table(is.na(error$age))
table(is.na(error$marital))
table(is.na(error$child))
table(is.na(error$educ))
table(is.na(error$source))
table(is.na(error$smoke))
table(is.na(error$smokenum))


# This seems like a lot of work!! lets do it automatically
# First we create a function
my_function <- function(x) {
  one <- is.na(x)
  two <- table(one)
  return(two)
}

# Then we apply it to each and every column with APPLY
apply(error, MARGIN = 2, my_function)


# We can do this with colSums as well

colSums(is.na(error)) # How many NAs are there in each column
colSums(is.na(error)) > 0 # Which columns have NA
colnames(error)[colSums(is.na(error)) > 0] # Give me those colnames with NA


# We now inspect each column to see whats happening, using table() and which()

# Smokenum and smoke: who has no number of cigarettes?
table(smoke = error$smoke, smokenum_missing = is.na(error$smokenum), useNA = "ifany")

# Most of them are non-smokers: they smoke 0 cigarettes, so here we can
# impute 0 with ifelse()
error$smokenum <- ifelse(is.na(error$smokenum) & error$smoke %in% 2, # A non-smoker with NA
                         0, # Impute 0
                         error$smokenum) # Otherwise, leave the same value

# Check that both variables agree: are there non-smokers who smoke?
which(error$smoke == 2 & error$smokenum > 0)
# We cannot know which answer is wrong, so we set the number of cigarettes to NA
error$smokenum[which(error$smoke == 2 & error$smokenum > 0)] <- NA

# Age: imputing the median is an option for a numerical variable when very few
# values are missing (and it must be reported). We can save where the NA's are
# located as a vector, and then overwrite those values with the median
vector_na <- which(is.na(error$age))
error$age[vector_na] <- median(error$age, na.rm = TRUE) # Impute median
error$age[vector_na] # Check

# Sex, child, educ, source and smoke are categorical: the median of their codes
# is not a category (the median of "work" and "health" is not a source of
# stress). We leave them as NA.


############# FINAL CHECK
colSums(is.na(error)) # How many NAs are there in each column
colSums(is.na(error)) > 0 # Which columns have NA
colnames(error)[colSums(is.na(error)) > 0] # Give me those colnames with NA

# The NA's left are values we cannot recover. Analyses that need complete
# data will use the rows without NA's
error_complete <- na.omit(error)
nrow(error_complete)

#---------------------------------------------------------------------------#
############################ BASIC PLOTTING IN R ############################
#---------------------------------------------------------------------------#

# The best way to check for outliers and watch the distribution of our data
# is to make a plot.

## Barplot

barplot(error$age) # This plots each value, not the distribution!
table(error$age)
barplot(table(error$age)) # As easy as it comes!

barplot(table(error$age),
        main = "This is a barplot",
        xlab = "This is the x-axis label",
        ylab = "This is the y-axis label",
        col = "pink",
        border = "midnightblue",
        density = 100)

barplot(table(error$sex))

## Histogram

hist(error$age)

hist(error$age,
     main = "This is the title!", # sets the title
     xlab = "Age", # sets xlab
     xlim = c(0,100),
     ylab = "Frequency",
     ylim = c(0,100),
     col = "lightblue",
     breaks = 20) # number of breaks on X axis


## Boxplot
boxplot(age ~ sex, data = error)

boxplot(age ~ sex, data = error,
        horizontal = FALSE,
        lwd = 1,
        xlab = "sex",
        ylab = "age",
        col = c(3,4))


#---------------------------------------------------------------------------#
######################## EXERCISE SOME R SKILLS HERE ########################
#---------------------------------------------------------------------------#

## We are going to load some clinical data and work with it. The objective is to
## inspect it and clean it. The STENTING dataset contains 5166 records of stroke
## patients treated with mechanical thrombectomy, with (STENTINTRAsino = 1) or
## without (STENTINTRAsino = 0) intracranial stenting. The data are SYNTHETIC
## (Data/generate_synthetic_data.R): they do not belong to real patients.
## The variables are described in the README.

# Load the dataframe from .sav file


# Check class of the dataframe. Convert it to dataframe


# Select or subset just the first 22 columns


# Remove the 2nd, 3rd, 7th, 14th, 16th, 18th and 22nd columns


# Inspect the data with str(), summary() and descr()


# Try to set IdPacient as rownames (it will give an error, keep going)


# Check for duplicates in IdPacient using table() and duplicated(). Then, store them
# in a vector using which() and duplicated() After that, use that vector to eliminate
# duplicated patients from the dataframe.


# Try again to set IdPacient as rownames. Then, remove IdPacient column.


## At this point, we should have just our variables of interest, and no duplicated
## patients. We will examine each and every variable looking for errors, missing values
## and outliers.


# There are some empty values, convert them to NA's (try replace() function)


# Now, inspect what variables contain NA's


# For those variables that contain NA's, use is.na


# Use na.omit() to keep just the patients with complete variables


# Apply table to each column (using apply function)

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

# Remove those patients under 40 years old

# Save it with write.csv2() and inspect it manually!

# Save the cleaned dataframe as a workspace!


#---------------------------------------------------------------------------#
###################### EXERCISE SOME R SKILLS HERE LIGHT ####################
#---------------------------------------------------------------------------#

## We are going to load some clinical data and work with it. The objective is to
## inspect it and clean it. The STENTING dataset contains 5166 records of stroke
## patients treated with mechanical thrombectomy, with (STENTINTRAsino = 1) or
## without (STENTINTRAsino = 0) intracranial stenting. The data are SYNTHETIC
## (Data/generate_synthetic_data.R): they do not belong to real patients.
## The variables are described in the README.

# Load the dataframe from .sav file
stent <- read_sav("____")

# Check class of the dataframe. Convert it to dataframe
class(____)
stent <- ____(stent)

# Select or subset just the first 22 columns
stent <- stent[,____]

# Remove the 2nd, 3rd, 7th, 14th, 16th, 18th and 22nd columns
stent <- ______[,-c(2,3,7,14,16,18,22)]

# Inspect the data with str(), summary() and descr()
str(____)
summary(____)
descr(____)

# Try to set IdPacient as rownames (it will give an error, keep going)
rownames(____) <- stent$IdPacient


# Check for duplicates in IdPacient using table() and duplicated(). Then, store them
# in a vector using which() and duplicated() After that, use that vector to eliminate
# duplicated patients from the dataframe.
table(duplicated(____$____))
remove <- which(duplicated(____$____))
stent <- ____[-remove,]
table(duplicated(stent$IdPacient))


# Try again to set IdPacient as rownames. Then, remove IdPacient column.
rownames(____) <- stent$IdPacient
stent <- stent[,__]

## At this point, we should have just our variables of interest, and no duplicated
## patients. We will examine each and every variable looking for errors, missing values
## and outliers.


# There are some empty values, convert them to NA's (try replace() function)
stent <- replace(stent, stent == "", __)

# Now, inspect what variables contain NA's
is.na(stent)
colSums(is.na(____))
colSums(is.na(____)) > 0
colnames(stent)[colSums(is.na(____)) > 0]

# For those variables that contain NA's, use is.na
table(is.na(stent$____))
table(is.na(stent$____))
# ... do the same for the rest of the variables


# Use na.omit() to keep just the patients with complete variables. How many
# patients do we lose?
stent_clean <- na.omit(stent)

# Apply table to each column (using apply function)
apply(stent_clean, 2, FUN = table)

# Change the labels of ACIT (Si/No) to (S/N) with ifelse()
stent_clean$ACIT <- ____(stent_clean$ACIT == "No", "N", "S")

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
stent_clean$Sexe <- ____(stent_clean$Sexe)
# ... do the same for the rest of the variables


# Remove those patients under 40 years old
stent_clean_age <- stent_clean[stent_clean$____ >= 40,]

# Save it with write.csv2() and inspect it manually!
write.csv2(____, "____.csv")

# Save the cleaned dataframe as a workspace!

