
library(dplyr)
library(tidyverse)
devtools::install_github("jimhester/vroom")
install.packages("flexdashboard")

ARC <- read.csv("C:/Users/enxhi/Desktop/R_independentstudy/R_project/Data/all_rate_changes_distinct.csv", sep =",", header=TRUE)

# Remove duplicates based on BAN_SEQ column
RCU <- ARC %>% distinct(.ARC, BAN_SEQ,SNAPSHOT_DATE, .keep_all=TRUE)

#Narrow down variables 
RCU <- RCU %>%
  select(BAN_SEQ, SNAPSHOT_DATE, CURR_PAYING_RATE, PRIOR_PAYING_RATE,CURR_QTY, PRIOR_QTY)

#Create a csv only with the variables of interest
write.csv(RCU, file="C:/Users/enxhi/Desktop/R_independentstudy/R_project/Data/RateChangeUnique.csv")

#Loading different csv files provided to build the final dataset
demographics <- read.delim("C:/Users/enxhi/Desktop/R_project/data/LogRegDataSet.csv", 
                           sep =";", header = TRUE)

demographics <- demographics[,(1:16)]
colnames(demographics)[1] <- "BAN_SEQ"

demographics2 <- read.delim("C:/Users/enxhi/Desktop/R_project/CenturyLink/Demographics.txt", 
                            sep =",", header = TRUE)
#Narrowing variables down
demographics2 <- demographics2[,-(11:622)]

#Merging the two demographic dataframes
DEMO <- merge(demographics,demographics2, by = "BAN_SEQ")

# Remove duplicates based on BAN_SEQ column
DEMO <- DEMO[!duplicated(DEMO$BAN_SEQ), ]

DEMO <- DEMO %>%
  select(BAN_SEQ, CREDIT_CLASS, CALL_COUNT, AGE,
         EDUCATION_LEVEL, CUST_TYPE, CITY, STATE, ZIP, CVGENDERCODE1)
#Create a csv with demographic data
write.csv(DEMO, file = "C:/Users/enxhi/Desktop/R_independentstudy/R_project/data/DEMO.csv")
DF <- merge(DEMO,RCU, by = "BAN_SEQ")

#Using the table I got from scraping
Income_per_state <- read.delim("C:/Users/enxhi/Desktop/R_project/Data/Income_per_state.csv", 
                            sep =",", header = TRUE)

#To merge the table of scraping with the rest you have to rename a column
names(DF)[names(DF) == "STATE"] <- "STATE_ABBREVIATION"
DF1 <- merge(DF,Income_per_state, by = "STATE_ABBREVIATION")
