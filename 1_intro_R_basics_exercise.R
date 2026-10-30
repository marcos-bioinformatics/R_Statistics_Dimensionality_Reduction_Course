#---------------------------------------------------------------------------#
################### EXERCISE SOME R SKILLS HERE CORRECTION ##################
#---------------------------------------------------------------------------#

library(dplyr)

# Create a dataframe for a genome mouse study, with 12 samples, and the following
# variables. You can choose any design you want for the factor variables.

# - sample_name (chr)
# - age (num) (from 0 to 24 months)
# - genotype (factor) (WT/KO)
# - weight (num) (from 19 to 29gr)
# - height (cm) (from 3-5cm)
# - dose (factor) (high/low)

# TIPS: you can construct each vector appropiately and then create the dataframe.
#       you can create everything inside the data.frame function
#       it's allowed to check google for answers if you get stucked

set.seed(1) # So that the random numbers are the same every time
experimental_design <- data.frame(
  sample_name = sprintf("sample_%02d", 1:12), # sample_01 ... sample_12
  age = as.integer(rnorm(12, mean = 14, sd = 2)),
  genotype = factor(c("WT", "WT", "WT", "WT", "WT", "WT", "KO", "KO", "KO", "KO", "KO", "KO")),
  weight = rnorm(12, mean = 24, sd = 2),
  height = rnorm(12, mean = 4, sd = 0.4),
  dose = factor(c("high", "high", "high", "low", "low", "low", "high", "high", "high",
                  "low", "low", "low"))
)

# Once you have the dataframe, you should do the following. Each step is shown
# with base R and, in a separate object, with dplyr

# - Set sample_names as rownames and eliminate sample_name's column
rownames(experimental_design)
rownames(experimental_design) <- experimental_design$sample_name
experimental_design_dplyr <- experimental_design %>% # With dplyr
  select(-sample_name)
experimental_design <- experimental_design[,-1]

# - Convert age from months to days (about 30 days per month)
experimental_design_dplyr <- experimental_design_dplyr %>% # With dplyr
  mutate(age = age*30)
experimental_design$age <- experimental_design$age*30

# - Get the mean and standard deviation of age
mean(experimental_design$age)
sd(experimental_design$age)

age <- experimental_design %>% # With dplyr
  summarise(mean = mean(age), sd = sd(age))

# - Get the mean and standard deviation of weight
mean_sd <- function(x) {
  media <- mean(x)
  desv <- sd(x)
  return(c(mean = media, sd = desv))
}

mean_sd(experimental_design$weight)

weight <- experimental_design %>% # With dplyr
  summarise(mean = mean(weight), sd = sd(weight))


# - Create a new column that calculates the BMI: weight/(height)^2
experimental_design$BMI <- experimental_design$weight/(experimental_design$height^2)

experimental_design_dplyr <- experimental_design_dplyr %>% # With dplyr
  mutate(BMI = weight/height^2)

# - Split the dataframe by genotype in two: WT samples and KO samples
experimental_WT <- experimental_design[experimental_design$genotype == "WT",]
experimental_KO <- experimental_design[experimental_design$genotype == "KO",]

experimental_WT_dplyr <- experimental_design_dplyr %>% # With dplyr
  filter(genotype == "WT")

experimental_KO_dplyr <- experimental_design_dplyr %>% # With dplyr
  filter(genotype == "KO")

# - Save each dataset in any format you like
write.csv2(experimental_KO, "KO_mice.csv")
write.csv2(experimental_WT, "WT_mice.csv")
