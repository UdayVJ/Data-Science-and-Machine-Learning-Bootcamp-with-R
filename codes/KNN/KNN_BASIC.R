install.packages("ISLR")
library(ISLR)
str(Caravan)

#check null values
print(any(is.na(Caravan)))


# check the data 
print(var(Caravan[,1]))
print(var(Caravan[,2]))
## scaling the data

purchase <- Caravan[,86]

standard.df <- scale(Caravan[,-86])
print(var(standard.df[,1]))
print(var(standard.df[,2]))

## train test split
test.index <- 1:1000
test.data <- standard.df[test.index,]
test.purchase <- purchase[test.index]

## traun split
train.data <- standard.df[-test.index,]
train.purchase <- purchase[-test.index]

###########
#KNN MODEL
###########

library(class)
set.seed(101)

predicted.purchase <- knn(train.data,test.data,train.purchase,k=1)

print(head(predicted.purchase))


## 

misclass.error <- mean(test.purchase != predicted.purchase)

print(misclass.error)



## chooseing the best K value
##example for k=5
predicted.purchase1 <- knn(train.data,test.data,train.purchase,k=5)

misclass.error1 <- mean(test.purchase != predicted.purchase1)

print(misclass.error1)

## for best K value

predicted.purchase2 <- NULL
error.rate <- NULL
for (i in 1:20){
  set.seed(101)
  predicted.purchase2 <- knn(train.data,test.data,train.purchase,k=i)
  error.rate[i] <- mean(test.purchase != predicted.purchase2)
}

print(error.rate)


## Visulize K Elbow method
library(ggplot2)
k.value <- 1:20
error.df <- data.frame(error.rate,k.value)

plo <- ggplot(error.df,aes(x=k.value,y=error.rate))+ geom_point()+geom_line(lty="dotted",color="red")
print(plo)

## for K=9 we get the least error

predicted.purchase.final <- knn(train.data,test.data,train.purchase,k=9)

misclass.error.final <- mean(test.purchase != predicted.purchase.final)

print(misclass.error.final)