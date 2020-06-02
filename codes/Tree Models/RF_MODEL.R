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

##########Random Forest Model

library(randomForest)
rf.model <- randomForest(Private ~ . , data=train,importance= T)
print(rf.model$confusion)
print(rf.model$importance)

###prediction

rf.pred <- predict(rf.model,test)
print(table(rf.pred,test$Private))