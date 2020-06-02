# ggplot2 Exercises
# Recreate the following plots shown below. Don't worry if your plots don't match exactly what is shown below, as long as you have a general understanding of ggplot2 and the grammar of graphics
# 
# Important Note!
#   Some of the images may be distorted from the conversion to a web format
# 
# For the first few plots, use the mpg dataset

library(ggplot2)
library(ggthemes)
head(mpg)

# Histogram of hwy mpg values:

pl <- ggplot(mpg,aes(x=hwy))
print(pl + geom_histogram(fill="red",alpha=0.5))

#Barplot of car counts per manufacturer with color fill defined by cyl count

pl1 <- ggplot(mpg,aes(x=manufacturer))
print(pl1 + geom_bar(aes(fill=factor(cyl))))


#Switch now to use the txhousing dataset that comes with ggplot2

head(txhousing)

#Create a scatterplot of volume versus sales. Afterwards play around with alpha and color arguments to clarify information.
pl2 <- ggplot(txhousing,aes(x=sales,y=volume))
pl3 <- pl2 + geom_point(color="blue",alpha=0.35)
print(pl3)
#Add a smooth fit line to the scatterplot from above. Hint: You may need to look up geom_smooth()


print(pl3+geom_smooth(color="red"))
