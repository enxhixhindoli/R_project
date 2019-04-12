#call in packages
library(dplyr)
library(ggplot2)
library(Matrix)
library(xgboost)
library(lubridate)

RCC <- read.csv("C:/Users/enxhi/Desktop/R_independentstudy/R_project/Data/RateChange_Churn.csv", sep =",", header=TRUE)

#Grouping observations by n_snapshotdate and creating a new variable to see the number of customers each month
RCC2 <- RCC %>% 
  group_by(n_snapshotdate) %>%
  summarise(customers=n())

#Converting n_snapshotdate from factor to Date
class(RCC2$n_snapshotdate)
RCC2$n_snapshotdate <- as.character(RCC2$n_snapshotdate)
RCC2$n_snapshotdate <- as.Date(RCC2$n_snapshotdate)

#Looking at customer number accross the year
ggplot(RCC2, aes(n_snapshotdate, customers)) + 
  xlab("Timeline") + ylab("Customers by Month") + geom_line() + theme(axis.text.x=element_text(angle=60, hjust=1))

#Improving the "quality" of the graphic to get better insights
ggplot(RCC2, aes(n_snapshotdate, customers)) + scale_x_date(breaks = RCC2$n_snapshotdate, date_labels = '%m/%d') +
  scale_y_continuous(breaks = round(seq(min(RCC2$customers), max(RCC2$customers), by = 10000),1)) +
 xlab("Timeline") + ylab("Customers by Month") + geom_line() + theme(axis.text.x=element_text(angle=60, hjust=1))
#scale_x_date position scales for date time where breaks are giving positions of breaks in x axis
#scale_y_continuous used to increase the number of ticks in the y axis

#Plot a barchart of the counts of clients by snapshotdate.
ggplot(data = RCC) + geom_bar(aes(x=n_snapshotdate)) + 
  theme(axis.text.x=element_text(angle=60, hjust=1)) + facet_wrap(~BILL_CODE) 
