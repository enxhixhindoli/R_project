#call in packages
library(dplyr)
library(ggplot2)
library(Matrix)
library(xgboost)
library(lubridate)

ARC <- read.csv("C:/Users/enxhi/Desktop/CenturyLink/CenturyLink/all_rate_changes_distinct.csv", sep =",", header=TRUE)

#turning in snapshot date into a date value
ARC <- ARC %>% mutate(n_snapshotdate = as.character(SNAPSHOT_DATE)) %>% 
  arrange(n_snapshotdate) %>% 
  mutate(n_snapshotdate = as.Date(SNAPSHOT_DATE, format = "%m/%d/%Y"))


#narrowing down variables
ARC <- ARC %>% select(BAN_SEQ, n_snapshotdate, PRODUCT_TYPE, BUNDLE_CODE, PRICE_PLAN, FEATURE_CODE, SUB_MARKET_CODE, CURR_MRR, PRIOR_MRR, 
                       CURR_PAYING_RATE, PRIOR_PAYING_RATE, CURR_QTY, PRIOR_QTY, PREFIX_CAT_CODE, SUFFIX_CAT_CODE,
                       UNIT_GROUP, BASE_RATE, PROMO_RATE)

#Subsetting only the observations of 2015
ARC2 <- filter(ARC, n_snapshotdate>'2014-12-31' & n_snapshotdate<'2016-01-31')

#Checking that the results are consistent
length(unique(ARC2$n_snapshotdate))
unique(ARC2$n_snapshotdate)

#Creating variable churn
ARC2$CHURN <- if_else(ARC2$CURR_QTY >= ARC2$PRIOR_QTY,0,1)
sum(ARC2$CHURN==1)

#write to a csv
write.csv(ARC2, file ="C:/Users/enxhi/Desktop/R_independentstudy/R_project/RateChange_Churn.csv")
