#Unsupervized Learning
#### K_Means


df <- iris
print(head(df))

###plot

library(ggplot2)
pl <- ggplot(df,aes(Petal.Length,Petal.Width,color=Species))
print(pl+geom_point(size=4))

##Kmeans
set.seed(101)
iriscluster <- kmeans(iris[,1:4],3,nstart=20)
print(iriscluster)

print(table(iriscluster$cluster,iris$Species))

###See the clusters
library(cluster)
print(clusplot(iris,iriscluster$cluster,color=T,shade=T,label=0,lines=0))