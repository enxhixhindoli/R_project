library(dplyr)
library(lubridate)
library(ggplot2)
library(Matrix)
library(plyr)
detach("package:plyr", unload=TRUE)
install.reprex("reprex")

#Reading the file
rate_change_distinct <- read.delim("C:/Users/enxhi/Desktop/CL dataset/CenturyLink/all_rate_changes_distinct.csv",
                                   sep =",", header = TRUE)

#Arranging observations by BAN_SEQ and SNAPSHOT_DATE
rate_change_distinct$SNAPSHOT_DATE <- as.Date(rate_change_distinct$SNAPSHOT_DATE, format="%m/%d/%Y")
df <- rate_change_distinct %>% 
  arrange(BAN_SEQ,SNAPSHOT_DATE)
df[,1] <- NULL

#Taking out obervations in 2014
df2 <- filter(df, SNAPSHOT_DATE!='2014-12-31')

#Creating a new variable which contains only month and year
df3 <- df2 %>% 
  group_by(BAN_SEQ,SNAPSHOT_DATE,CURR_PAYING_RATE)%>%
  summarise(count=n())%>%
  mutate(Month_Yr=format(as.Date(SNAPSHOT_DATE), "%Y-%m"))

#Subsetting the dataset based on Month_Yr variable and creating first_2015
first_2015 <- subset(df3, Month_Yr > "2015-01" & Month_Yr < "2015-07")
first_2015$CURR_PAYING_RATE <- as.numeric(as.character(first_2015$CURR_PAYING_RATE))

#Seeing the CURR_PAYING_RATE for each BAN_SEQ
Amount_first_2015<- first_2015%>%
  group_by(BAN_SEQ)%>%
  summarise(first_2015=sum(CURR_PAYING_RATE))

#METHOD 2 -- Seeing the CURR_PAYING_RATE for each BAN_SEQ
df4 <-aggregate(CURR_PAYING_RATE~BAN_SEQ,first_2015,sum)
 
#Subsetting the dataset based on Month_Yr variable and creating second_2015
second_2015 <- subset(df3, Month_Yr > "2015-07" & Month_Yr < "2015-12")
second_2015$CURR_PAYING_RATE <- as.numeric(as.character(second_2015$CURR_PAYING_RATE))
df5 <-aggregate(CURR_PAYING_RATE~BAN_SEQ,second_2015,sum)

#Subsetting the dataset based on Month_Yr variable and creating first_2016
first_2016 <- subset(df3, Month_Yr > "2016-01" & Month_Yr < "2016-07")
first_2016$CURR_PAYING_RATE <- as.numeric(as.character(first_2016$CURR_PAYING_RATE))
df6 <-aggregate(CURR_PAYING_RATE~BAN_SEQ,first_2016,sum)

#Subsetting the dataset based on Month_Yr variable and creating second_2016
second_2016 <- subset(df3, Month_Yr > "2016-07" & Month_Yr < "2016-12")
second_2016$CURR_PAYING_RATE <- as.numeric(as.character(second_2016$CURR_PAYING_RATE))
df7 <-aggregate(CURR_PAYING_RATE~BAN_SEQ,second_2016,sum)

#Renaming column of Total CURR_PAYING_RATE
names(df4)[2]<-"Paying_2015_1"
names(df5)[2]<-"Paying_2015_2"
names(df6)[2]<-"Paying_2016_1"
names(df7)[2]<-"Paying_2016_2"

#Merging datasets to create a unique ID with 4 Curr_Paying_Rate (per each semester)
Total_2015 <- merge(df4,df5, by = 'BAN_SEQ')
Total_2016 <- merge(df6,df7, by = 'BAN_SEQ')
Amount_years <- merge(Total_2015,Total_2016,by = 'BAN_SEQ')

#create a csv from the Dataframe
write.csv(Amount_years, "CURR_PAYING_BY_SEMESTER.csv")
