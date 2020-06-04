# Neural Net Project
# Let's wrap up this course by taking a a quick look at the effectiveness of Neural Nets!
# 
# We'll use the Bank Authentication Data Set from the UCI repository.
# 
# The data consists of 5 columns:
#   
#   variance of Wavelet Transformed image (continuous)
# skewness of Wavelet Transformed image (continuous)
# curtosis of Wavelet Transformed image (continuous)
# entropy of image (continuous)
# class (integer)
# Where class indicates whether or not a Bank Note was authentic.

# Get the Data
# Use read.csv to read the bank_note_data.csv file.

df <- read.csv("bank_note_data.csv")

#Check the head of the data frame and its structure.

print(head(df,4))
print(str(df))

# Train Test Split
# Use the caTools library to split the data into training and testing sets.

library(caTools)
set.seed(101)
sample <- sample.split(df$Class,SplitRatio=0.7)
train <- subset(df,sample==T)
test <- subset(df,sample==F)

print(str(train))


#Building the Neural Net
#Call the neuralnet library

library(neuralnet)

#Use the neuralnet function to train a neural net, set linear.output=FALSe and choose 10 hidden neurons (hidden=10)

n <- names(train)
f <- as.formula(paste("Class ~",paste(n[!n %in% "Class"],collapse = " + ")))

nn <- neuralnet(f,data = train,hidden=10,linear.output = F)
# 
# Predictions
# Use compute() to grab predictions useing your nn model on the test set. Reference the lecture on how to do this.

predicted.nn.values <- compute(nn,test[,1:4])

# Check the head of the predicted values. You should notice that they are still probabilities.

head(predicted.nn.values$net.result)

#Apply the round function to the predicted values so you only 0s and 1s as your predicted classes.

predictions <- sapply(predicted.nn.values$net.result,round)

#Use table() to create a confusion matrix of your predictions versus the real values

table(predictions,test$Class)

# 
# You should have noticed that you did very well! Almost suspiciously well! Let's check our results against a randomForest model!
# 
# Comparing Models
# Call the randomForest library




#Run the Code below to set the Class column of the data as a factor (randomForest needs it to be a factor, not an int like neural nets did. Then re-do the train/test split

df$Class <- factor(df$Class)
library(caTools)
set.seed(101)
split = sample.split(df$Class, SplitRatio = 0.70)

train = subset(df, split == TRUE)
test = subset(df, split == FALSE)

#Create a randomForest model with the new adjusted training data.
library(randomForest)
model <- randomForest(Class ~ Image.Var + Image.Skew + Image.Curt + Entropy,data=train)

#Use predict() to get the predicted values from your rf model.

rf.pred <- predict(model,test)

#Use table() to create the confusion matrix.

print(table(rf.pred,test$Class))

### Plot NN

print(plot(nn))

