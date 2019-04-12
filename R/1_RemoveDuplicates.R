
ARC <- read.csv("C:/Users/enxhi/Desktop/R_independentstudy/R_project/Data/all_rate_changes_distinct.csv", sep =",", header=TRUE)

# Remove duplicates based on BAN_SEQ column
RCU <- ARC[!duplicated(ARC$BAN_SEQ), ]
write.csv(RCU, file="C:/Users/enxhi/Desktop/R_independentstudy/R_project/Data/RateChangeUnique.csv")
