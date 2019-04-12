install.packages("clustMixType")
library(clustMixType)
library(cluster)

df <- read.csv("C:/Users/enxhi/Desktop/CenturyLink/LogRegData.csv", sep =";", header = T)
df2 <- df[,3:20]
df2$FIRST_DATE <- NULL

df2 <- as.data.frame(df2)
df2$GENDER <- as.factor(df2$GENDER)
df2$AGE <- as.numeric(df2$AGE)
df2$A_BILLING_METHOD <- as.factor(df2$A_BILLING_METHOD)
df2$R_BILLING_METHOD <- as.factor(df2$R_BILLING_METHOD)
df2$D_BILLING_METHOD <- as.factor(df2$D_BILLING_METHOD)
df2$F_BILLING_METHOD <- as.factor(df2$F_BILLING_METHOD)
df2$S_BILLING_METHOD <- as.factor(df2$S_BILLING_METHOD)
df2$MARRIED <- as.factor(df2$MARRIED)
df2$NEVER_MARRIED <- as.factor(df2$NEVER_MARRIED)
df2$SEPARATED <- as.factor(df2$SEPARATED)
df2$FIRST_TIME_CUSTOMER <- as.factor(df2$FIRST_TIME_CUSTOMER)
df2$BUNDLE_BINARY <- as.factor(df2$BUNDLE_BINARY)
df2$SUM_RATE_CHANGE <-as.character(df2$SUM_RATE_CHANGE)
any(is.na(df2$SUM_RATE_CHANGE))
df2$SUM_RATE_CHANGE <-as.numeric(df2$SUM_RATE_CHANGE)
df2$SUM_RATE_CHANGE[is.na(df2$SUM_RATE_CHANGE)] <- 0

#how to pick up only few variables for clustering all observations
# apply k prototypes
kprot <- kproto(df2, 4,iter.max = 10, nstart = 1, na.rm = TRUE, keep.data = TRUE, verbose = TRUE)
clprofiles(kprot, df2)


# calculate cindex-value
cindex_value <- cindex_kproto(object = kprot)

# calculate optimal number of cluster
k_opt <- cindex_kproto(data = df2, k = 3:5, nstart = 5, verbose=FALSE)

# calculate index-value
gamma_value <- gamma_kproto(object = kprot)

# calculate optimal number of cluster
k_opt <- gamma_kproto(data = df2, k = 3:5, nstart = 5, verbose = FALSE)

#Dissimilarity matrix calculation
daisy.mat <- as.matrix(daisy(df2, metric=gower))

#Clustering by pam algorithm
my.cluster <- pam(daisy.mat, k=4, diss = T)

#Cluster plot
clusplot(daisy.mat, diss = T, my.cluster$clustering, color = T)