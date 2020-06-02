# Linear Regression Project
# For this project you will be doing the Bike Sharing Demand Kaggle challenge! We won't submit any results to the competition, but feel free to explore Kaggle more in depth. The main point of this project is to get you feeling comfortabe with Exploratory Data Analysis and begin to get an understanding that sometimes certain models are not a good choice for a data set. In this case, we will discover that Linear Regression may not be the best choice given our data!
# 
# Instructions
# Just complete the tasks outlined below.
# 
# Get the Data
# You can download the data or just use the supplied csv in the repository. The data has the following features:
# 
# datetime - hourly date + timestamp
# season - 1 = spring, 2 = summer, 3 = fall, 4 = winter
# holiday - whether the day is considered a holiday
# workingday - whether the day is neither a weekend nor holiday
# weather -
# 1: Clear, Few clouds, Partly cloudy, Partly cloudy
# 2: Mist + Cloudy, Mist + Broken clouds, Mist + Few clouds, Mist
# 3: Light Snow, Light Rain + Thunderstorm + Scattered clouds, Light Rain + Scattered clouds
# 4: Heavy Rain + Ice Pallets + Thunderstorm + Mist, Snow + Fog
# temp - temperature in Celsius
# atemp - "feels like" temperature in Celsius
# humidity - relative humidity
# windspeed - wind speed
# casual - number of non-registered user rentals initiated
# registered - number of registered user rentals initiated
# count - number of total rentals
library(ggplot2)
library(data.table)
library(ggthemes)
library(dplyr)
# Read in bikeshare.csv file and set it to a dataframe called bike.

df <- read.csv("bikeshare.csv")

#Check the head of df

print(head(df))

print(str(df))
print(summary(df))

# Exploratory Data Analysis
# Create a scatter plot of count vs temp. Set a good alpha value.

pl <- ggplot(df,aes(x=temp,y=count))+ geom_point(aes(color=temp),alpha=0.5)
print(pl)

#Plot count versus datetime as a scatterplot with a color gradient based on temperature. You'll need to convert the datetime column into POSIXct before plotting.
df$datetime <- as.POSIXct(df$datetime)

pl1 <- ggplot(df,aes(x=datetime,y=count))+ geom_point(aes(color=temp),alpha=0.5)+scale_color_continuous(low='#55D8CE',high='#FF6E2E')+theme_bw()
print(pl1)
# 
# Hopefully you noticed two things: A seasonality to the data, for winter and summer. Also that bike rental counts are increasing in general. This may present a problem with using a linear regression model if the data is non-linear. Let's have a quick overview of pros and cons right now of Linear Regression:
# 
# Pros:
# 
# Simple to explain
# Highly interpretable
# Model training and prediction are fast
# No tuning is required (excluding regularization)
# Features don't need scaling
# Can perform well with a small number of observations
# Well-understood
# Cons:
#   
#   Assumes a linear relationship between the features and the response
# Performance is (generally) not competitive with the best supervised learning methods due to high bias
# Can't automatically learn feature interactions
# We'll keep this in mind as we continue on. Maybe when we learn more algorithms we can come back to this with some new tools, for now we'll stick to Linear Regression.

#What is the correlation between temp and count?

print(cor(df[,c('temp','count')]))


#let's explore the season data. Create a boxplot, with the y axis indicating count and the x axis begin a box for each season.

pl2 <- ggplot(df,aes(x=factor(season),y=count))+ geom_boxplot(aes(color=factor(season)))+theme_bw()
print(pl2)

#   Notice what this says:
#   A line can't capture a non-linear relationship.
# There are more rentals in winter than in spring
# We know of these issues because of the growth of rental count, this isn't due to the actual season!

#   Feature Engineering
# A lot of times you'll need to use domain knowledge and experience to engineer and create new features. Let's go ahead and engineer some new features from the datetime column.
# 
# Create an "hour" column that takes the hour from the datetime column. You'll probably need to apply some function to the entire datetime column and reassign it. Hint:
# 
# time.stamp <- bike$datetime[4]
# format(time.stamp, "%H")
df$hour <- sapply(df$datetime,function(x){format(x,"%H")})

# Now create a scatterplot of count versus hour, with color scale based on temp. Only use bike data where workingday==1.
# 
# Optional Additions:
#   
#   Use the additional layer: scale_color_gradientn(colors=c('color1',color2,etc..)) where the colors argument is a vector gradient of colors you choose, not just high and low.
# Use position=position_jitter(w=1, h=0) inside of geom_point() and check out what it does.

pl3 <- ggplot(filter(df,workingday==1),aes(x=hour,y=count)) 
pl3 <- pl3 + geom_point(position=position_jitter(w=1, h=0),aes(color=temp),alpha=0.5)

pl3 <- pl3 + scale_color_gradientn(colours = c('dark blue','blue','light blue','light green','yellow','orange','red'))
pl3 + theme_bw()


#Now create the same plot for non working days:

pl4 <- ggplot(filter(df,workingday==0),aes(x=hour,y=count)) 
pl4 <- pl4 + geom_point(position=position_jitter(w=1, h=0),aes(color=temp),alpha=0.5)

pl4 <- pl4 + scale_color_gradientn(colours = c('dark blue','blue','light blue','light green','yellow','orange','red'))
pl4 + theme_bw()
# 
# You should have noticed that working days have peak activity during the morning (~8am) and right after work gets out (~5pm), with some lunchtime activity. While the non-work days have a steady rise and fall for the afternoon
# Now let's continue by trying to build a model, we'll begin by just looking at a single feature.
# 
# Building the Model
# Use lm() to build a model that predicts count based solely on the temp feature, name it temp.model

temp.model <- lm(count ~ temp, data = df)
#Get the summary of the temp.model

print(summary(temp.model))

# Interpreting the intercept (??0):
#   It is the value of y when x=0.
# Thus, it is the estimated number of rentals when the temperature is 0 degrees Celsius.
# Note: It does not always make sense to interpret the intercept.
# Interpreting the "temp" coefficient (??1):
#   It is the change in y divided by change in x, or the "slope".
# Thus, a temperature increase of 1 degree Celsius is associated with a rental increase of 9.17 bikes.
# This is not a statement of causation.
# ??1 would be negative if an increase in temperature was associated with a decrease in rentals.
# How many bike rentals would we predict if the temperature was 25 degrees Celsius? Calculate this two ways:
#   
#   Using the values we just got above
# Using the predict() function
# You should get around 235.3 bikes.

temp.test <- data.frame(temp=c(25))
predict(temp.model,temp.test)


#Use sapply() and as.numeric to change the hour column to a column of numeric values.
df$hour <- sapply(df$hour,as.numeric)

# Finally build a model that attempts to predict count based off of the following features. Figure out if theres a way to not have to pass/write all these variables into the lm() function. Hint: StackOverflow or Google may be quicker than the documentation.
# 
# season
# holiday
# workingday
# weather
# temp
# humidity
# windspeed
# hour (factor)


model <- lm(count ~ . -casual - registered -datetime -atemp,df )

#Get the summary of the model

summary(model)