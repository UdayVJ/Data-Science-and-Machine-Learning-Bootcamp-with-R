# NEURAL NETWORK
#install.packages("MASS")

library(MASS)
print(head(Boston))
print(str(Boston))

## check null value

print(any(is.na(Boston)))
data <- Boston

## NORMALIZE YOUR DATA

maxs <- apply(data,2,max)
print(maxs)
mins <- apply(data,2,min)
print(mins)

scaled.data <- scale(data,center = mins, scale=maxs-mins)
scaled <- as.data.frame(scaled.data)
print(head(scaled))


# train test split

library(caTools)
sample <- sample.split(scaled$medv,SplitRatio=0.7)
train <- subset(scaled,sample==T)
test <- subset(scaled,sample==F)

print(head(train))

## MODEL
#install.packages("neuralnet")
library(neuralnet)

n <- names(train)
f <- as.formula(paste("medv ~",paste(n[!n %in% "medv"],collapse = " + ")))

nn <- neuralnet(f,data = train,hidden=c(5,3),linear.output = TRUE)
print(plot(nn))

###  PREDICTION

prd.nn.val <- compute(nn,test[1:13])
str(prd.nn.val)


true.pred <- prd.nn.val$net.result * (max(data$medv)-min(data$medv))+min(data$medv)
test.r <- (test$medv) *(max(data$medv)-min(data$medv))+min(data$medv)

MSE.nn <- sum((test.r - true.pred)^2)/(nrow(test))
print(MSE.nn)



error.df <- data.frame(test.r,true.pred)
print(head(error.df))

## ploting
library(ggplot2)
pl <- ggplot(error.df,aes(x=test.r,y=true.pred))+geom_point()+stat_smooth()
print(pl)

