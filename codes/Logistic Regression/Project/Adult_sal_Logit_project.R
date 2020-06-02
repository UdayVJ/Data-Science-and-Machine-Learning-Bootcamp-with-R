# Logistic Regression Project
# In this project we will be working with the UCI adult dataset. We will be attempting to predict if people in the data set belong in a certain class by salary, either making <=50k or >50k per year.
# 
# Typically most of your time is spent cleaning data, not running the few lines of code that build your model, this project will try to reflect that by showing different issues that may arise when cleaning data.
# 
# Get the Data
# Read in the adult_sal.csv file and set it to a data frame called adult.
library(dplyr)





df <- read.csv("adult_sal.csv")
print(head(df))
print(str(df))

#You should notice the index has been repeated. Drop this column.

df <- select(df,-X)
print(head(df,2))
print(str(df))
print(summary(df))


# Data Cleaning
# Notice that we have a lot of columns that are cateogrical factors, however a lot of these columns have too many factors than may be necessary. In this data cleaning section we'll try to clean these columns up by reducing the number of factors.
# 
# type_employer column
# Use table() to check out the frequency of the type_employer column.

print(table(df$type_employer))
#How many Null values are there for type_employer? What are the two smallest groups?
# 1836 null values and never-worked and without-pay are the two smallest group

#Combine these two smallest groups into a single group called "Unemployed". There are lots of ways to do this, so feel free to get creative. Hint: It may be helpful to convert these objects into character data types (as.character() and then use sapply with a custom function)


unemp <- function(job){
  job <- as.character(job)
  if(job== "Never-worked"  | job== "Without-pay" ){
    return("Unemployed")
  }else{
    return(job)
  }
}

df$type_employer <- sapply(df$type_employer,unemp)
print(table(df$type_employer))  

#What other columns are suitable for combining? Combine State and Local gov jobs into a category called SL-gov and combine self-employed jobs into a category called self-emp.

employ <- function(job){
  job <- as.character(job)
  if(job== "Local-gov"  | job== "State-gov"){
    return("SL-gov")
  }else if(job== "Self-emp-inc"  | job== "Self-emp-not-inc"){
    return("self-emp")
  }else{
    return(job)
  }
}

df$type_employer <- sapply(df$type_employer,employ)
print(table(df$type_employer))  
# 
# 
# Marital Column
# Use table() to look at the marital column

print(table(df$marital))

# Reduce this to three groups:
#   
#   Married
# Not-Married
# Never-Married

marry <- function(job){
  job <- as.character(job)
  if(job== "Divorced"  | job== "Separated" | job=="Widowed"){
    return("Not-Married")
  }else if(job== "Never-married"){
    return("self-emp")
  }else{
    return("Married")
  }
}

df$marital <- sapply(df$marital,marry)
print(table(df$marital)) 

# Country Column
# Check the country column using table()

print(table(df$country))
#Group these countries together however you see fit. You have flexibility here because there is no right/wrong way to do this, possibly group by continents. You should be able to reduce the number of groups here significantly though.
levels(df$country)
Asia <- c('China','Hong','India','Iran','Cambodia','Japan', 'Laos' ,
          'Philippines' ,'Vietnam' ,'Taiwan', 'Thailand')

North.America <- c('Canada','United-States','Puerto-Rico' )

Europe <- c('England' ,'France', 'Germany' ,'Greece','Holand-Netherlands','Hungary',
            'Ireland','Italy','Poland','Portugal','Scotland','Yugoslavia')

Latin.and.South.America <- c('Columbia','Cuba','Dominican-Republic','Ecuador',
                             'El-Salvador','Guatemala','Haiti','Honduras',
                             'Mexico','Nicaragua','Outlying-US(Guam-USVI-etc)','Peru',
                             'Jamaica','Trinadad&Tobago')
Other <- c('South')

group_country <- function(ctry){
  if (ctry %in% Asia){
    return('Asia')
  }else if (ctry %in% North.America){
    return('North.America')
  }else if (ctry %in% Europe){
    return('Europe')
  }else if (ctry %in% Latin.and.South.America){
    return('Latin.and.South.America')
  }else{
    return('Other')      
  }
}

df$country <- sapply(df$country,group_country)
print(table(df$country))

#Check the str() of adult again. Make sure any of the columns we changed have factor levels with factor()

print(str(df))

df$type_employer <- sapply(df$type_employer,factor)
df$country <- sapply(df$country,factor)
df$marital <- sapply(df$marital,factor)

print(str(df))
# 
# We could still play around with education and occupation to try to reduce the number of factors for those columns, but let's go ahead and move on to dealing with the missing data. Feel free to group thos columns as well and see how they effect your model.
# 
# Missing Data
# Notice how we have data that is missing.
# 
# Amelia
# Install and load the Amelia package.

#install.packages('Amelia',repos = 'http://cran.us.r-project.org')
library(Amelia)

#Convert any cell with a '?' or a ' ?' value to a NA value. Hint: is.na() may be useful here or you can also use brackets with a conditional statement. Refer to the solutions if you can't figure this step out.

df[df == '?'] <- NA
df$type_employer <- sapply(df$type_employer,factor)
df$country <- sapply(df$country,factor)
df$marital <- sapply(df$marital,factor)
df$occupation <- sapply(df$occupation,factor)
print(table(df$type_employer))


print(missmap(df))
#You should have noticed that using missmap(adult) is bascially a heatmap pointing out missing values (NA). This gives you a quick glance at how much data is missing, in this case, not a whole lot (relatively speaking). You probably also noticed that there is a bunch of y labels, get rid of them by running the command below. What is col=c('yellow','black') doing?
print(missmap(df,y.at=c(1),y.labels = c(''),col=c('yellow','black')))

#drop missing data

df <- na.omit(df)
print(missmap(df,y.at=c(1),y.labels = c(''),col=c('yellow','black')))


#### EDA
library(ggplot2)
library(dplyr)
# 
# Although we've cleaned the data, we still have explored it using visualization.
# 
# Check the str() of the data.

print(str(df))

#Use ggplot2 to create a histogram of ages, colored by income.

pl <- ggplot(df,aes(age)) + geom_histogram(aes(fill=income), position=position_stack(reverse=TRUE),color='black',binwidth=1) + theme_bw()
print(pl)

#Plot a histogram of hours worked per week

pl2 <- ggplot(df,aes(hr_per_week))+ geom_histogram()
print(pl2)

# Rename the country column to region column to better reflect the factor levels.

df$region <- df$country
df <- select(df,-country)
print(str(df))

#Create a barplot of region with the fill color defined by income class. Optional: Figure out how rotate the x axis text for readability

pl3 <-  ggplot(df,aes(region),color="black") +geom_bar(aes(fill=income),color="black")+ theme_bw()
print(pl3+theme(axis.text.x = element_text(angle = 90, hjust = 1)))

###data is ready

#spilting data
library(caTools)
set.seed(101)


sample <- sample.split(df$income,SplitRatio = 0.7)
# Train
train <- subset(df,sample==T)
# test
test <- subset(df,sample==F)

## model

model <- glm(income ~ . ,family=binomial(link="logit"),data=train)
summary(model)


new.model <- step(model)

summary(new.model)

#confusion model
test$predicted.income <- predict(model,newdata = test,type="response")
table(test$income,test$predicted.income>0.5)

#What was the accuracy of our model?
print("acc")  
print((6372+1423)/(6372+1423+548+872))

#recall
print("recall")
print(6732/(6372+548))

#precision
print("Precison")
print(6732/(6372+872))