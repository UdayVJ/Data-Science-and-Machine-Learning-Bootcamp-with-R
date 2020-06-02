# read the data (Student data from UCI)

df  <- read.csv("student-mat.csv",sep=";")

#check the sturture and check for null values

print(str(df))
print(any(is.na(df)))

library(ggplot2)
library(ggthemes)
library(dplyr)
library(corrgram)
library(corrplot)

# numeric only

nums.cols <- sapply(df,is.numeric)
 
# finding co relation 
cor.data <- cor(df[,nums.cols])
rint(cor.data)

# visulaize the data
print(corrplot(cor.data,method="color"))

corrgram(df,order=TRUE,lower.panel = panel.shade,
         upper.panel = panel.pie,text.panel = panel.txt)

ggplot(df,aes(x=G3)) + geom_histogram(bins=20,alpha=0.5,fill="blue")

#split the data and set seed
library(caTools)

set.seed(101)

# spliting
sample <- sample.split(df$G3,SplitRatio = 0.7)
# 70% train data
train <- subset(df,sample==TRUE)
# 30% test data
test <- subset(df,sample==FALSE)


# Train and Bulid model
model <- lm(G3 ~., data = train)

#Interpret the model
print(summary(model))

#predictions

G3.predict <- predict(model,test)
results <- cbind(G3.predict,test$G3)

colnames(results) <- c("predict","Actual")

results <- as.data.frame(results)

print(results)


#take care of negative value
 to_zero <- function(x) {
   if(x<0){
     return(0)
   }else{
     return(x)
   }
}
 
 # apply zero function

results$predict <- sapply(results$predict,to_zero)

#Mean square error
mse <- mean((results$Actual - results$predict)^2)
print("MSE")
print(mse)

#RMSE
print("RMSE")
print(mse^0.5)

################## sum of squared error

SSE <- sum((results$Actual - results$predict)^2)
SST <- sum((mean(df$G3)-results$Actual)^2)

R2 <- 1-  SSE/SST
print(paste("R2: ",R2))