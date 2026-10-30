
## First thing to check is the location of the working directory
getwd()

#### Installing and loading R packages from CRAN

# Install a package from CRAN and load it
install.packages("vegan")
library(vegan)

## There are other projects that develop and support R packages, such as
## Bioconductor, or packages hosted on GitHub

# Install packages from Bioconductor through BiocManager (it installs the
# Bioconductor version that matches your R version)
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(c("microbiome", "ANCOMBC"))
library(ANCOMBC)

# Installing a package from GitHub (on Windows it may require Rtools)
install.packages("remotes")
remotes::install_github("antagomir/netresponse")

# Update already installed packages
update.packages()


#### Help files and documentation

?mean
?ancombc2
??mean ## Double when we are unsure of the name of the function


#### Saving Work and exiting R

## Usually hit CTRL+S to save your script. You can also save an entire
## workspace through .RData files.

#---------------------------------------------------------------------------#
############### NUMERICS, ARITHMETIC, ASSIGNMENT AND VECTORS ################
#---------------------------------------------------------------------------#
  
#### We can use R as a scientific calculator

# Basic arithmetic operations
2+5

14-6

72/8

12/4+2

12/(4+2)

2^4

# More complex arithmetic operations
sqrt(x = 196)

log(x = 100, base = 2)

log(x = 1, base = 100) # The log of x = 1 is always 0, regardless of the base.

exp(x = 4)


#### Assigning objects

## You can save any result from an arithmetic operation, or any other object
## as a variable in the current workspace. You can use either "=" or "<-"
## Variables can be named almost anything, but the name has to start with a letter.
## Try to avoid common words and symbols though.

# Simple assignment
x <- 7
y = 4

x+y

z <- x+y

x = x + 1 # Run it multiple times


#### Creating a vector

## A vector is the essential building block for handling multiple items in R.
## Usually we store numbers or text.

# Create a vector with numbers
myvector <- c(1,3,7,11,14,17,19)
myvector
class(myvector)

# Create a vector with numbers and variables who store numbers
myvector2 <- c(47, x, y, z, exp(2), log(x=10, base=4))
myvector2

# Create a text vector
myvectortext <- c("blue", "cyan", "green", "whatever")
class(myvectortext)

# Create a vector containing 2 vectors
myvectoradd <- c(myvector, myvector2)
myvectoradd

#### Subsetting and element extraction

# Lets work with a numeric vector
myvector <- c(4, 5, 6, 8, 10, 12, 14, 16, 18)
myvector

myvector[1] #gets the first element

myvector[c(1,2)] #gets both the first and second elements

myvector[-1] #deletes the first element

myvector[-myvector[1]] #careful: myvector[1] is 4, so this deletes the 4th element

myvector[2:4] #gets 2nd, 3rd and 4th elements

myvector[1] <- 6 #overwrite the first element
myvector

myvector[3:5] <- 100 #overwrite the 3rd, 4th and 5th elements
myvector


# Lets work with a character vector
myvector <- c("hey", "what's", "up", "!")
myvector

myvector[1] 

myvector[c(1,2)] 

myvector[2:4] 

myvector[1] <- "yo"
myvector

myvector[3:4] <- c("happening", "!")
myvector


#### Sequences, Repetition, Sorting, Length

# You can easily create a numeric vector as follows:
myvector <- 1:10
myvector

myvector <- 2:457
myvector

# Create a sequence with seq
seq(from = 2, to = 47, by = 3)

seq(from = 2, to = 47, length.out = 50)

seq(from = 100, to = -58, by = -2)

# Generate repetitions with rep
rep(x = 1, times = 8)

rep(x = c(4,5,6), times = 2)

rep(x = c(4,5,6), each = 2)

# Generate a vector of names
myvector <- rep(x = "sample_0", times = 20)
myvector
myvector <- paste0(myvector, 1:20)
myvector

# Sorting a vector with sort
myvector <- c(4, 5, 6, exp(2), log(x=10, base=8), sqrt(89))
myvector
sort(myvector, decreasing = TRUE)
sort(myvector, decreasing = FALSE)

# Finding a vector length with length
length(myvector)
length(c(4,5,6))
length(1:97)


#### Vector operations

## Compute arithmetic operations over a vector
myvector <- c(2, 4, 6, 8)
myvector*5
myvector^2
sqrt(myvector)
myvector*myvector
myvector^myvector

## You can perform arithmetic operations with and between vectors
myvector1 <- c(4, 5, 6, 8) 
myvector2 <- c(1, 2, 3, 4)

myvector1 * 4
myvector1 / 2

myvector1 + myvector2
myvector1 * myvector2
myvector1 / myvector2
myvector1 ** myvector2

# What happens with vectors of different lengths? EVEN case
myvector1 <- c(4, 5, 6, 8) 
myvector2 <- c(1, 2)

myvector1 + myvector2
myvector1 * myvector2
myvector1 / myvector2
myvector1 ** myvector2

# What happens with vectors of different lengths? UNEVEN case
myvector1 <- c(4, 5, 6, 8) 
myvector2 <- c(1, 2, 3)

myvector1 + myvector2
myvector1 * myvector2
myvector1 / myvector2
myvector1 ** myvector2

# You can apply lots of functions on vectors!
myvector1 <- c(1,1,3,4,5,6,7,8,8,8,9,9,9,9)
mean(myvector1)
sd(myvector1)
sum(myvector1)
table(myvector1)
all(myvector1 > 0)
all(myvector1 > 2)
any(myvector1 > 4)
any(myvector1 == 10)

#### Types of data in R

## There are 6 basic (atomic) types of data in R: logical, numeric (double),
## integer, complex, character and raw. We will use the first five.

# Logical
var <- TRUE
var
class(var)

# Numeric
var <- 8
var
class(var)

# Integer
var <- 8L # L specifies for integer
var
class(var)

# Complex
var <- 1+4i
var
class(var)

# Character
var <- "whatever"
var
class(var)

# Let's think about it!

#---------------------------------------------------------------------------#
########################## MATRICES AND ARRAYS ############################
#---------------------------------------------------------------------------#
  
## A matrix is simply several vectors stored together. Usually, we describe a
## matrix A as an m x n matrix (m rows and n columns)
  
#### Create a matrix 
mymatrix <- matrix(data = c(2, 3, 4, 5), nrow=2, ncol=2)
mymatrix

mymatrix <- matrix(data = c(1, 2, 3, 4, 5, 6), nrow = 2, ncol = 3, byrow = TRUE)
mymatrix

mymatrix <- matrix(data = c(1, 2, 3, 4, 5, 6), nrow = 2, ncol = 3, byrow = FALSE)
mymatrix

# Check dimensions
nrow(mymatrix)
ncol(mymatrix)
dim(mymatrix)

#### Create a matrix from vectors
myvector1 <- c(1, 2, 3)
myvector2 <- c(4, 5, 6)
mymatrix <- rbind(myvector1, myvector2) #bind both vectors as rows
mymatrix
mymatrix <- cbind(myvector1, myvector2) #bind both vectors as columns
mymatrix

#### Subsetting a matrix

## Just respect the order [row, column]

mymatrix
mymatrix[1,] #get the first row
mymatrix[,1] #get the first column
mymatrix[1,2] #get the second element of the first row
mymatrix[,c(1,2)] #get the first and the second column
mymatrix[,-2] #delete the second column
t(mymatrix) #get the transpose matrix


#---------------------------------------------------------------------------#
############################# LOGICAL VALUES ###############################
#---------------------------------------------------------------------------#

#### Logical values and relational operators

## Logical values in R are just TRUE and FALSE, which can be abbreviated by T and F.

TRUE
FALSE

brr <- TRUE
class(brr)
skrr <- FALSE
class(skrr)

## The relational operators are:
# == Equal to
# != Not equal to
# > Greater than
# < Less than
# >= Greater than or equal to
# <= Less than or equal to
## and the logical operators, which we will see below:
# & AND
# | OR
# ! NOT

# Equal to
1 == 4
TRUE == FALSE

# Not equal to
4 != 8
4 != 2**2
TRUE != FALSE

# Greater than
8 > 1

# Less than
4 < 12

# Greater than or equal to
8 >= 9

# Less than or equal to
8 <= 9

## This operations can be performed between other types of objects

myvector1 <- c(1,2,4,6,8,10)
myvector2 <- c(2,4,6,8,8,10)

myvector1 == myvector2

myvector1 < myvector2

length(myvector1) == length(myvector2)

myvector1 < 5


#### Logical operators

## This kind of operators are used to compare TRUE or FALSE objects

# & (Interpretation: AND)
TRUE & TRUE
TRUE & FALSE
FALSE & FALSE
FALSE & TRUE

# | (Interpretation: OR)
TRUE | FALSE
FALSE | FALSE

# ! (Interpretation: NOT)
!TRUE
!FALSE
!TRUE == FALSE


## Logicals are numbers!
## Due to the binary nature of logical values, R represents them as TRUE == 1,
## and FALSE == 0

TRUE + TRUE
TRUE - FALSE
TRUE - TRUE
TRUE * 8

## WHY ARE THESE OPERATORS USEFUL?

myvector <- c(2, 4, 5, 7, 8, 10, 11)
myvector < 6 #which elements are less than six?
myvector[myvector < 6] #subset them!


#---------------------------------------------------------------------------#
############################### CHARACTERS #################################
#---------------------------------------------------------------------------#

## Character strings are another R data type.

# Create a character string
brr <- "This is a character string"
brr
length(brr)
nchar(brr)
toupper(brr)
tolower(brr)

# A number represented as a string, will be treated as such by R
brr <- "24,5"
brr*2

# We can compare strings
"whatever" == "whatever"
"whatever" != "whichever"
c("alpha", "beta", "gamma") == "alpha"

# We can concatenate strings with cat or paste functions
brr <- c("awesome", "R", "is")
length(brr)
brr

cat(brr[2],brr[3],"totally", brr[1],"!")
cat(brr[2],brr[3],"totally",brr[1],"!", sep="_")

# We can paste text or numbers with paste function
paste("!^_^!", brr)
paste("I can say", brr)


# We can use escape sequences as well:
# \n starts a newline
# \t horizontal tab
# \b invokes a backspace
# \\ used as a single backslash
# \" includes a double quote

cat("lets\nsplit\tthis\nallright\tinnit")


#---------------------------------------------------------------------------#
################################# FACTORS ###################################
#---------------------------------------------------------------------------#

## Factors represent datapoints that fit in one of a finite number of distinct
## categories, and are really useful in data science

sex <- factor(c("male", "female", "female", "male"))
levels(sex)
nlevels(sex)

dose <- factor(c("high", "high", "mid", "low", "mid", "low", "high"))
levels(dose) # Uses alphabetical order
nlevels(dose)

dose <- factor(dose, levels = c("low", "mid", "high")) # This way we can order the factors
levels(dose)
dose

# CAREFUL: levels(dose) <- c(...) does not reorder the levels, it RENAMES them,
# so it changes the values of your data:
dose_renamed <- factor(c("high", "high", "mid", "low", "mid", "low", "high"))
levels(dose_renamed) <- c("low", "mid", "high")
dose_renamed # "high" became "low", "low" became "mid" and "mid" became "high"!

## Let's see an example

# Create a sample vector
samples <- rep("sample_0", times = 16)
samples
samples <- paste0(samples, 1:16)
samples

# Create a genotype vector
genotype <- c(rep("WT", times = 8), rep("KO", 8)) 
genotype

# Create a dose vector
dose <- c("low", "low", "mid", "mid", "high", "high", "vhigh", "vhigh",
          "low", "low", "mid", "mid", "high", "high", "vhigh", "vhigh")

# Inspect each vector's structure with str
str(samples)
str(genotype)
str(dose)

# Convert them to factor with factor function
genotype <- factor(genotype)
str(genotype)
dose <- factor(dose, levels = c("low", "mid", "high", "vhigh"), labels = c(1,2,3,4))
str(dose)
dose

# Bind the data together with cbind.data.frame
data <- cbind.data.frame(samples, genotype, dose)
data
str(data)


#---------------------------------------------------------------------------#
############################### DATA FRAMES #################################
#---------------------------------------------------------------------------#

## Data frames are probably the most natural way of presenting data in R.
## They are made of vectors, which should be of equal length.

# Construct a dataframe
df <- data.frame(sample = c("sample_01", "sample_02", "sample_03", "sample_04"),
                 genotype = c("WT", "WT", "KO", "KO"),
                 sex = c("M", "F", "M", "F"),
                 age = c(24, 28, 20, 32))

# Useful functions for dataframes
head(df)
nrow(df)
ncol(df)
dim(df)
rownames(df)
colnames(df)
str(df)

# The $ sign + tab is going to be the best combo you've ever pressed!!!!!
df$sample
df$genotype
df$sex
df$age
df$newcolumn <- c(1,2,3,4) #creates a new column
df

# Each column is a vector and we can use functions on them
str(df)
df$sex <- factor(df$sex)
str(df)
df$sample[1] #subset first element
df$sample[2:4] #subset second to fourth elements
df$age*12 #age in months
sample_names <- df$sample #just save a column into a vector
mean(df$age) #calculate mean age
sd(df$age) #calculate sd
table(df$sex) #count each category 


## Knowing how to subset a dataframe in R will allow us to work efficiently

# Create a dataframe
set.seed(24)
df <- data.frame(x = 1:20,
                 y = 11:30,
                 z = 3:22,
                 w = sample(c("Group1", "Group2", "Group3", "Group4"), 20, replace = TRUE),
                 k = sample(c("high", "mid", "low"), 20, replace = TRUE))

colnames(df) <- c("x", "y", "z", "group", "dose")


# We can use base R
df2 <- df[[1]] # Select first column
df2
df2 <- df[, 1] # Same
df2
df2 <- df[,c(TRUE,FALSE,FALSE,TRUE, TRUE)] # Select columns by logical value
df2
df2 <- df[,1:2] # Select the first two columns
df2

df2 <- df[df$group == "Group1", ] # Filter by value
df2
df2 <- df[df$group == "Group2" ] # We missed a comma
df2

df2 <- df[df$x > 6,] # Subset by value
df2

df2 <- df[df$x > 6 & df$dose == "high",] # There is no one!
df2

## We can use packages specifically designed to work with dataframes.
## Dplyr package compiles different functions that are easy to use and
## the pipe operator (%>%) that makes it possible to concatenate operations

install.packages("tidyverse")
library(dplyr)

df

# SELECT VERB
df2 <- df %>%
  select(x, dose)
df2

df2 <- select(df, dose)
df2

# FILTER VERB
df2 <- df %>%
  filter(group == "Group1")
df2

df2 <- filter(df, group == "Group1")
df2

# MUTATE VERB
df2 <- df %>%
  mutate(double_X = 2*x)
df2

df2 <- mutate(df, double_X = 2*x)
df2

# ARRANGE VERB
df2 <- df %>%
  arrange(group)
df2

df2 <- arrange(df, desc(group)) # we can choose desc or asc (default)
df2

# SUMMARISE VERB (creates a new vector/dataframe)
df2 <- df %>%
  summarise(mean_x = mean(x))
df2

df2 <- df %>%
  summarise(sum_x_y = x+y) # Read the error: summarise() returns one value
df2

df2 <- df %>%
  reframe(sum_x_y = x+y) # reframe() can return several values
df2

# We can concatenate verbs in one easy step!
df2 <- df %>%
  select(x, group, dose) %>%
  filter(group == "Group4") %>%
  mutate(x_exp = x^2)
df2

# Doing the same thing with base R requieres multiple assigning and more code
df2 <- df[, c("x", "group", "dose")]
df3 <- df2[df2$group == "Group4",]
df3$x_exp <- df3$x^2
df3

#---------------------------------------------------------------------------#
############################## SPECIAL VALUES ###############################
#---------------------------------------------------------------------------#

## There are some special values in R that we should know about:

# Infinity or Inf
brr <- Inf
brr
typeof(brr)
24/0
-24/0

# Not a Number or NaN (usually result of a bad computation)
brr <- NaN
brr
typeof(brr)
0/0
Inf/Inf

# Not Available or NA
brr <- NA
brr
typeof(brr)

# NULL is an empty object: it has no value and length 0, and it disappears
# when combined with other values
brr <- NULL
typeof(brr)
brr <- c(NA, NA, NA, NA)
brr
brr[1]
brr <- c(NULL, NULL, NULL, NULL)
brr
brr[1]
brr[5]


#---------------------------------------------------------------------------#
################################# FUNCTIONS #################################
#---------------------------------------------------------------------------#

## Functions are a set of statements organized to perform one or multiple tasks.

# Let's see some examples
greetings <- function() {
  print("Hello world")
}

greetings()

# Functions can contain arguments
greetings <- function(name) {
  print(paste("Greetings,", name))
}

greetings("User")

# Functions can be created to perform simple arithmetic calculations
dollar_to_euro <- function(dollar) { 
  euro <- dollar * 0.94
  return(euro) }

dollar_to_euro(2454)

# Or can be used to concatenate multiple built-in functions
calculations <- function(x) {
  media <- mean(x) # Calculate the mean
  desv <- sd(x) # Calculate SD
  return(c(media+desv, media-desv)) # Show me the result
}

calculations(df$x)


#---------------------------------------------------------------------------#
########################### CONDITIONALS AND LOOPS ##########################
#---------------------------------------------------------------------------#

## We can use more sophisticated techniques in our functions using conditional
## statements and loops. In a research-enviroment, knowing this will be useful
## even if we don't code our own functions on a regular basis, as conditionals
## and loops are core programming techniques used by lots of built functions.

#### IF statements

# An if statement controls which operations are computed given a code
x <- 5
y <- 9

if(x < y) {
  print("X is less than Y")
}

# Lets update this 
if(x < y) {
  print("X is less than Y")
} else {
  print("X is NOT less than Y")
  }

# Lets update this again
if(x < y) {
  print("X is less than Y")
} else if (x == y) {
  print("X is EQUAL to y")
} else {
  print("X is NOT less than Y")
}

# More examples
if(x < y) {
  z <- x^2
  print(z)
}

# How complicated! Lets learn about the IFELSE function! We will see later
# how can we do this same function manually!
df$j <- ifelse(df$x > 10, 1, 2)
df$j <- ifelse(df$x > 10, "high", "low")


#### FOR loops

# A for loop repeats a specified chunk of code n times or can execute the same
# code over a number of elements, for example, a vector.

# Lets see an easy example
for(i in 1:4){
  print("Hello World!")
}

i # What is happening here?

for(number in 1:5){
  print(number)
}

number # Same thing

# We can make our lifes easier with APPLY function! Lets try to compute the
# sum of the values for each row in a dataframe.

df2 <- df[,1:3] #pick the first 3 columns of our df
row.totals <- c() #create an empty vector

# For every row in df2, sum every element of the row and save it in a vector
for(i in 1:nrow(df2)){
  row.totals[i] <- sum(df2[i,])
}

row.totals

# This is pretty complicated, lets try to use the APPLY function
row.totals_2 <- apply(df2, 
                      MARGIN = 1, #1 apply to rows, 2 apply to columns
                      FUN = sum) # function to apply
row.totals_2

# And now, let's just use the RowSums function
row.totals_3 <- rowSums(df2)
row.totals_3


#### WHILE LOOPS

## Even though we won't need to use them often, its good to know about this
## kind of loops. We set a condition and while the condition remains TRUE,
## some code will execute. Be aware and don't get trapped in an infinite loop!

# Let's work with an example!
condition <- 1
while(condition < 6) {
  condition <- condition + 1
  print("The condition is still TRUE!")
}

# Let's update this loop a little
condition <- 1
count <- 0
while(condition < 10) {
  condition <- condition + 1
  count <- count + 1
  print(paste("This loop has been completed", count, "times"))
}


#---------------------------------------------------------------------------#
######################## EXERCISE SOME R SKILLS HERE ########################
#---------------------------------------------------------------------------#

# Create a dataframe for a genome mouse study, with 12 samples, and the following
# variables. You can choose any design you want for the factor variables.

# - sample_name (chr)
# - age (num) (from 0 to 24 months)
# - genotype (factor) (WT/KO)
# - weight (num) (from 19 to 29gr)
# - height (cm) (from 3-5cm)
# - dose (factor) (high/low)

# TIPS: you can construct each vector appropiately and then create the dataframe.
# This can be do manually or use some of the functions we learned.
# You can create everything inside the data.frame function it's ok to check 
# google for answers if you get stucked.

my_dataframe <- data.frame(
  sample_name = , # You can do it manually or use paste0 and rep
  age = , # You can do it manually or use rnorm
  genotype = , # You can do it manually or use paste0 and rep
  height = , # You can do it manually or use rnorm
  weight = , # You can do it manually or use rnorm
  dose = , ) # You can do it manually or use paste0 and rep


# Once you have constructed the dataframe, you should do the following:

# - Set sample_names as rownames and eliminate sample_name's column


# - Convert age from months to days


# - Get the mean and standard deviation of age


# - Get the mean and standard deviation of weight


# - Create a new column that calculates the BMI: weight/(height)^2


# - Split the dataframe by genotype in two: WT samples and KO samples


# - Save each dataset in any format you like


#---------------------------------------------------------------------------#
#################### EXERCISE SOME R SKILLS HERE LIGHT VERSION ##############
#---------------------------------------------------------------------------#

# Create a dataframe for a genome mouse study, with 12 samples, and the following
# variables. You can choose any design you want for the factor variables.

# - sample_name (chr)
# - age (num) (from 0 to 24 months)
# - genotype (factor) (WT/KO)
# - weight (num) (from 19 to 29gr)
# - height (cm) (from 3-5cm)
# - dose (factor) (high/low)

# TIPS: you can construct each vector appropiately and then create the dataframe.
# This can be do manually or use some of the functions we learned.
# You can create everything inside the data.frame function it's ok to check 
# google for answers if you get stucked.

my_dataframe <- data.frame(
  sample_name = , # You can do it manually or use paste0 and rep
  age = , # You can do it manually or use rnorm
  genotype = , # You can do it manually or use paste0 and rep
  height = , # You can do it manually or use rnorm
  weight = , # You can do it manually or use rnorm
  dose = , ) # You can do it manually or use paste0 and rep


# Once you have constructed the dataframe, you should do the following:

# - Set sample_names as rownames and eliminate sample_name's column
rownames(____) <- my_dataframe$____


# - Convert age from months to days (about 30 days per month)
my_dataframe$____ <- my_dataframe$____ * 30

# - Get the mean and standard deviation of age
____(my_dataframe$age)
____(my_dataframe$age)

# - Get the mean and standard deviation of weight
____(my_dataframe$weight)
____(my_dataframe$weight)

# - Create a new column that calculates the BMI: weight/(height)^2
my_dataframe$___ <- my_dataframe$weight/(my_dataframe$height^2)

# - Split the dataframe by genotype in two: WT samples and KO samples
experimental_WT <- my_dataframe[my_dataframe$____ == "WT",]
experimental_KO <- my_dataframe[my_dataframe$____ == "KO",]

# - Save each dataset in any format you like
write.csv2(____, "KO_mice.csv")
write.csv2(____, "WT_mice.csv")
