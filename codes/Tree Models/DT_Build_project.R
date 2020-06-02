# Tree Methods Project
# For this project we will be exploring the use of tree methods to classify schools as Private or Public based off their features.
# 
# Let's start by getting the data which is included in the ISLR library, the College data frame.
# 
# A data frame with 777 observations on the following 18 variables.
# 
# Private A factor with levels No and Yes indicating private or public university
# Apps Number of applications received
# Accept Number of applications accepted
# Enroll Number of new students enrolled
# Top10perc Pct. new students from top 10% of H.S. class
# Top25perc Pct. new students from top 25% of H.S. class
# F.Undergrad Number of fulltime undergraduates
# P.Undergrad Number of parttime undergraduates
# Outstate Out-of-state tuition
# Room.Board Room and board costs
# Books Estimated book costs
# Personal Estimated personal spending
# PhD Pct. of faculty with Ph.D.'s
# Terminal Pct. of faculty with terminal degree
# S.F.Ratio Student/faculty ratio
# perc.alumni Pct. alumni who donate
# Expend Instructional expenditure per student
# Grad.Rate Graduation rate
# Get the Data
# Call the ISLR library and check the head of College (a built-in data frame with ISLR, use data() to check this.) Then reassign College to a dataframe called df


library(ISLR)
df <- College
print(head(df))

# EDA
# Let's explore the data!
# 
# Create a scatterplot of Grad.Rate versus Room.Board, colored by the Private column.

pl <- ggplot(df,aes(x=Grad.Rate,y=Room.Board))+geom_point(aes(color=factor(Private)))
print(pl)

#Create a histogram of full time undergrad students, color by Private.
pl1 <- ggplot(df,aes(F.Undergrad))+geom_histogram(aes(fill=factor(Private)),position=position_stack(reverse=TRUE),color="black")
print(pl1)

#Create a histogram of Grad.Rate colored by Private. You should see something odd here.

pl2 <- ggplot(df,aes(Grad.Rate))+geom_histogram(aes(fill=factor(Private)),position=position_stack(reverse=TRUE),color="black")
print(pl2)

#What college had a Graduation Rate of above 100% ?

gra <- subset(df,Grad.Rate>100)
print(gra)

#Change that college's grad rate to 100%

df["Cazenovia College","Grad.Rate"] <- 100

# 
# Train Test Split
# Split your data into training and testing sets 70/30. Use the caTools library to do this.

library(caTools)
set.seed(101)
sample <- sample.split(df$Private,SplitRatio = 0.7)
train <- subset(df,sample=T)
test <- subset(df,sample=F)


#########model

library(rpart)
# Train Model

model <- rpart(Private ~ . ,method ="class",data=train)

predi <- predict(model,test)
print(head(predi))

#### simple function
tree.pred <- as.data.frame(predi)
#
joiner <- function(x){
   if(x>=0.5){
     return("Yes")
   }else{
     return("No")
   }
}

tree.pred$Private <- sapply(tree.pred$Yes,joiner) 
print(head(tree.pred))

### confusion matrix
print(table(tree.pred$Private,test$Private))

## plot 
library(rpart.plot)
print(prp(model))



