# K Means Clustering Project
# Usually when dealing with an unsupervised learning problem, its difficult to get a good measure of how well the model performed. For this project, we will use data from the UCI archive based off of red and white wines (this is a very commonly used data set in ML).
# 
# We will then add a label to the a combined data set, we'll bring this label back later to see how well we can cluster the wine into groups.
# 
# Get the Data
# Download the two data csv files from the UCI repository (or just use the downloaded csv files).
# 
# Use read.csv to open both data sets and set them as df1 and df2. Pay attention to what the separator (sep) is.

df1 <- read.csv("winequality-red (2).csv",sep = ";")
df2 <- read.csv("winequality-white.csv",sep = ";")
print(head(df1,2))
print(head(df2,2))

#Now add a label column to both df1 and df2 indicating a label 'red' or 'white'.

df1$label <- sapply(df1$pH,function(x){'red'})
df2$label <- sapply(df2$pH,function(x){'white'})
print(head(df1,2))
print(head(df2,2))


#Combine df1 and df2 into a single data frame called wine.

wine <- rbind(df1,df2)
str(wine)


# EDA
# Let's explore the data a bit and practice our ggplot2 skills!
# 
# Create a Histogram of residual sugar from the wine data. Color by red and white wines.

library(ggplot2)
pl <- ggplot(wine,aes(x=residual.sugar)) + geom_histogram(aes(fill=label),position=position_stack(reverse=TRUE),color='black',bins=50)
print(pl+scale_fill_manual(values = c('#ae4554','#faf7ea')) + theme_bw())

#Create a Histogram of citric.acid from the wine data. Color by red and white wines.
pl1 <- ggplot(wine,aes(x=citric.acid)) + geom_histogram(aes(fill=label),position=position_stack(reverse=TRUE),color='black',bins=50)
print(pl1+scale_fill_manual(values = c('#ae4554','#faf7ea')) + theme_bw())

#Create a Histogram of alcohol from the wine data. Color by red and white wines.
pl2 <- ggplot(wine,aes(x=alcohol)) + geom_histogram(aes(fill=label),position=position_stack(reverse=TRUE),color='black',bins=50)
print(pl2+scale_fill_manual(values = c('#ae4554','#faf7ea')) + theme_bw())


#Create a scatterplot of residual.sugar versus citric.acid, color by red and white wine.

pl3 <- ggplot(wine,aes(x=citric.acid,y=residual.sugar)) + geom_point(aes(color=label),alpha=0.2)
# Optional adding of fill colors
print(pl3 + scale_color_manual(values = c('#ae4554','#faf7ea')) +theme_dark())

#Create a scatterplot of volatile.acidity versus residual.sugar, color by red and white wine.

pl4 <- ggplot(wine,aes(x=volatile.acidity,y=residual.sugar)) + geom_point(aes(color=label),alpha=0.2)
# Optional adding of fill colors
print(pl4 + scale_color_manual(values = c('#ae4554','#faf7ea')) +theme_dark())

#Grab the wine data without the label and call it clus.data

clus.data <- wine[,1:12]

#Check the head of clus.data

print(head(clus.data))

# Building the Clusters
# Call the kmeans function on clus.data and assign the results to wine.cluster.

wine.cluster <- kmeans(clus.data,2)
#Print out the wine.cluster Cluster Means and explore the information.

print(wine.cluster$centers)

# Evaluating the Clusters
# You usually won't have the luxury of labeled data with KMeans, but let's go ahead and see how we did!
#   
# Use the table() function to compare your cluster results to the real results. Which is easier to correctly group, red or white wines?

table(wine$label,wine.cluster$cluster)

# We can see that red is easier to cluster together, which makes sense given our previous visualizations. There seems to be a lot of noise with white wines, this could also be due to "Rose" wines being categorized as white wine, while still retaining the qualities of a red wine. Overall this makes sense since wine is essentially just fermented grape juice and the chemical measurements we were provided may not correlate well with whether or not the wine is red or white!
#   
#   It's important to note here, that K-Means can only give you the clusters, it can't directly tell you what the labels should be, or even how many clusters you should have, we are just lucky to know we expected two types of wine. This is where domain knowledge really comes into play.

###Ploting
library(cluster)
print(clusplot(wine,wine.cluster$cluster,color=T,shade=T,label=0,lines=0))
