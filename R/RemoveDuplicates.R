library(dplyr)

ARC <- read.csv("C:/Users/enxhi/Desktop/CenturyLink/CenturyLink/all_rate_changes_distinct.csv", sep =",", header=TRUE)

# Remove duplicates based on BAN_SEQ column
RCU <- ARC %>% distinct(.ARC, BAN_SEQ,SNAPSHOT_DATE, .keep_all=TRUE)
write.csv(RCU, file="C:/Users/enxhi/Desktop/R_independentstudy/R_project/Data/RateChangeUnique.csv")

