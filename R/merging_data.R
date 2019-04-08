library(dyplr)
library(tidyverse)
devtools::install_github("jimhester/vroom")

demographics2 <- read.delim("C:/Users/enxhi/Desktop/R_project/CenturyLink/Demographics.txt", 
                            sep =",", header = TRUE)

Avg_Inc_State <- read.delim("C:/Users/enxhi/Desktop/R_project/Avg_Inc_State.csv", 
                            sep =",", header = TRUE)

demographics2 <- demographics2[,-(11:622)]
names(demographics2)[names(demographics2) == "STATE"] <- "State_Abbreviation"

Demo_Income <- merge(demographics2, Income_per_state, by ="State_Abbreviation")

demographics <- read.delim("C:/Users/enxhi/Desktop/R_project/data/LogRegDataSet.csv", 
                           sep =";", header = TRUE)

demographics <- demographics[,(1:16)]
colnames(demographics)[1] <- "BAN_SEQ"

Demo_Income2 <- merge(Demo_Income,demographics, by = "BAN_SEQ")

#Taking off the dataset useless columns
Demo_Income2 <- Demo_Income2[,-(6:9)]
Demo_Income2$CUST_TYPE <- NULL
write.csv(Demo_Income2, file="Demo_Income.csv", row.names = F)

rate_change <- read.delim("C:/Users/enxhi/Desktop/R_project/CenturyLink/all_rate_changes_distinct.csv",
                          sep = ',',header = TRUE)

