df.train <- read.csv("titanic_train.csv")
df.test <- read.csv("titanic_test.csv")

print(head(df.train))
library(Amelia)
library(ggplot2)
library(ggthemes)
library(dplyr)

missmap(df.train,main="Missing Map",col =c("yellow","black"),legend=FALSE)

#Exploratory Data Analysis


sur <- ggplot(df.train,aes(Survived))+ geom_bar()
Pclass <- ggplot(df.train,aes(Pclass))+ geom_bar(aes(fill=factor(Pclass)))
sex <- ggplot(df.train,aes(Sex))+ geom_bar(aes(fill=factor(Sex)))
age <- ggplot(df.train,aes(Age))+ geom_histogram(bins=20,alpha=0.5,fill="blue")
Sib <- ggplot(df.train,aes(SibSp))+ geom_bar(aes(fill=factor(Survived)))
fare <- ggplot(df.train,aes(Fare))+ geom_histogram(alpha=0.5,fill="Green",color="black")

print(sur)

#NUll Values Treatment

pl <- ggplot(df.train,aes(Pclass,Age))
pl <- pl+ geom_boxplot(aes(group=Pclass,fill=factor(Pclass),alpha=0.5))
pl+scale_y_continuous(breaks = seq(min(0),max(80),by=2))+theme_bw()

## imputation of age based on class

impute_age <- function(age,class){
  out <-age
  for (i in 1:length(age)){
    if(is.na(age[i])){
      if(class[i]==1){
        out[i] <- 37
      }else if(class[i]==2){
        out[i] <- 29
      }else {
        out[i]<- 24
      }
    }else{
      out[i]<- age[i]
    }
  }
  return(out)
}


###########
fixed_age <- impute_age(df.train$Age,df.train$Pclass)


df.train$Age <- fixed_age
missmap(df.train,main="Missing Map",col =c("yellow","black"),legend=FALSE)

#droping some feature
df.train <- select(df.train,-PassengerId,-Name,-Ticket,-Cabin)
print(head(df.train))
print(str(df.train))


df.train$Survived <- factor(df.train$Survived)
df.train$Pclass <- factor(df.train$Pclass)
df.train$SibSp <- factor(df.train$SibSp)
df.train$Parch <- factor(df.train$Parch)

print(str(df.train))

log.model <- glm(Survived ~ .,family=binomial(link="logit"),data=df.train)
print(summary(log.model))

library(caTools)
set.seed(101)
split <- sample.split(df.train$Survived,SplitRatio=0.7)
final.train <- subset(df.train,split==TRUE)
final.test <- subset(df.train,split==FALSE)

finallog.model <- glm(Survived ~ .,family=binomial(link="logit"),data=df.train)
print(summary(finallog.model))

fitted.prob <- predict(finallog.model,final.test,type='response')
fitted.results <- ifelse(fitted.prob>0.5,1,0)
error <- mean(fitted.results !=final.test$Survived)
print(1-error)

## Confusion Matrix

table(final.test$Survived,fitted.results)


## doing the same operation on Test Data
print(str(df.test))
print(missmap(df.test,main="MissingMap test",col =c("yellow","black"),legend=FALSE))



## imputing the values in age and fair 


pl1 <- ggplot(df.test,aes(Pclass,Age))
pl1 <- pl1+ geom_boxplot(aes(group=Pclass,fill=factor(Pclass),alpha=0.5))
pl1+scale_y_continuous(breaks = seq(min(0),max(80),by=2))+theme_bw()



impute_agetest <- function(age,class){
  out <-age
  for (i in 1:length(age)){
    if(is.na(age[i])){
      if(class[i]==1){
        out[i] <- 42
      }else if(class[i]==2){
        out[i] <- 28
      }else {
        out[i]<- 22
      }
    }else{
      out[i]<- age[i]
    }
  }
  return(out)
}


###########
fixed_age1 <- impute_agetest(df.test$Age,df.test$Pclass)

df.test$Age <- fixed_age1
missmap(df.test,main="Missing Map",col =c("yellow","black"),legend=FALSE)


##### fareprice 

pl2 <- ggplot(df.test,aes(Pclass,Fare))
pl2 <- pl2+ geom_boxplot(aes(group=Pclass,fill=factor(Pclass),alpha=0.5))
pl2+scale_y_continuous(breaks = seq(min(0),max(1000),by=15))+theme_bw()


impute_faretest <- function(fare,class){
  out <-fare
  for (i in 1:length(fare)){
    if(is.na(fare[i])){
      if(class[i]==1){
        out[i] <- 62
      }else if(class[i]==2){
        out[i] <- 18
      }else {
        out[i]<- 15
      }
    }else{
      out[i]<- fare[i]
    }
  }
  return(out)
}


###########
fixed_fare <- impute_agetest(df.test$Fare,df.test$Pclass)
df.test$Fare <- fixed_fare
print(missmap(df.test,main="Missing Map",col =c("yellow","black"),legend=FALSE))

df.test <- select(df.test,-PassengerId,-Name,-Ticket,-Cabin)
print(head(df.test))
print(str(df.test))

for (i in 1:length(df.test$Parch)){
  if(df.test$Parch[i]==9){
    df.test$Parch[i]=0
  }
}

df.test$Pclass <- factor(df.test$Pclass)
df.test$SibSp <- factor(df.test$SibSp)
df.test$Parch <- factor(df.test$Parch)

print(str(df.test))
print(str(df.train))
fitted.prob1 <- predict(log.model,df.test,type='response')
fitted.results1 <- ifelse(fitted.prob1>0.5,1,0)

df.test$Survived <- fitted.results1

write.csv(df.test,file="Titanic_final_Submission.csv")
