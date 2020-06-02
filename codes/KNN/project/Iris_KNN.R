# Since KNN is such a simple algorithm, we will just use this "Project" as a simple exercise to test your understanding of the implementation of KNN. By now you should feel comfortable implementing a machine learning algorithm in R, as long as you know what library to use for it.
# 
# So for this project, just follow along with the bolded instructions. It should be very simple, so at the end you'll have an additional optional "bonus" project.
# 
# Get the Data
# Iris Data Set
# We'll use the famous iris data set for this project. It's a small data set with flower features that can be used to attempt to predict the species of an iris flower.
# 
# Use the ISLR libary to get the iris data set. Check the head of the iris Data Frame.
library(ISLR)
print(head(iris))
print(str(iris)

#check null values
print(any(is.na(iris)))


# check the data 
print(var(iris[,1]))
print(var(iris[,2]))

# Standardize Data
# In this case, the iris data set has all its features in the same order of magnitude, but its good practice (especially with KNN) to standardize features in your data. Lets go ahead and do this even though its not necessary for this data!
#   
#   Use scale() to standardize the feature columns of the iris dataset. Set this standardized version of the data as a new variable.

stand.features <- scale(iris[1:4])

#Check that the scaling worked by checking the variance of one of the new columns.
print(var(stand.features[,1]))
print(var(stand.features[,2]))

#Join the standardized data with the response/target/label column (the column with the species names.
final.data <- cbind(stand.features,iris[5])
head(final.data)

# Train and Test Splits
# Use the caTools library to split your standardized data into train and test sets. Use a 70/30 split.

set.seed(101)

library(caTools)

sample <- sample.split(final.data$Species, SplitRatio = .70)
train <- subset(final.data, sample == TRUE)
test <- subset(final.data, sample == FALSE)

# Build a KNN model.
# Call the class library

library(class)
predicted.species <- knn(train[1:4],test[1:4],train$Species,k=1)

#What was your misclassification rate?

print(mean(test$Species != predicted.species))

# Choosing a K Value
# Although our data is quite small for us to really get a feel for choosing a good K value, let's practice.
# 
# Create a plot of the error (misclassification) rate for k values ranging from 1 to 10.

predicted.species <- NULL
error.rate <- NULL

for(i in 1:10){
  set.seed(101)
  predicted.species <- knn(train[1:4],test[1:4],train$Species,k=i)
  error.rate[i] <- mean(test$Species != predicted.species)
}

library(ggplot2)
k.values <- 1:10
error.df <- data.frame(error.rate,k.values)

pl <- ggplot(error.df,aes(x=k.values,y=error.rate)) + geom_point()
print(pl + geom_line(lty="dotted",color='red'))

#You should have noticed that the error drops to its lowest for k values between 2-6. Then it begins to jump back up again, this is due to how small the data set it. At k=10 you begin to approach setting k=10% of the data, which is quite large.

# building a model with k=3
predicted.species.final <- knn(train[1:4],test[1:4],train$Species,k=3)

#What was your misclassification rate?

print(mean(test$Species != predicted.species.final))