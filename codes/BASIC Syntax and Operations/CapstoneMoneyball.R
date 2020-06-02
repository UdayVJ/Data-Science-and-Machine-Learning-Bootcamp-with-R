# Data
# We'll be using data from Sean Lahaman's Website a very useful source for baseball statistics. The documentation for the csv files is located in the readme2013.txt file. You may need to reference this to understand what acronyms stand for.
# 
# Use R to open the Batting.csv file and assign it to a dataframe called batting using read.csv

batting <- read.csv("Batting.csv")

#Use head() to check out the batting
head(batting)


#Use str() to check the structure. Pay close attention to how columns that start with a number get an 'X' in front of them! You'll need to know this to call those columns!

print(str(batting))

#Make sure you understand how to call the columns by using the $ symbol.
#Call the head() of the first five rows of AB (At Bats) column

print(head(batting$X2B,3))

# Quick Note: If you used fread() to use data.table, then you won't need to worry about these X in front of numbers, instead you would use something like:
# 
# batting[,'2B',with=FALSE]


# Feature Engineering
# We need to add three more statistics that were used in Moneyball! These are:
#   
#   Batting Average
# On Base Percentage
# Slugging Percentage
# Click on the links provided and search the wikipedia page for the formula for creating the new statistic! For example, for Batting Average, you'll need to scroll down until you see:
# 
# AVG=HAB
#  
# Which means that the Batting Average is equal to H (Hits) divided by AB (At Base). So we'll do the following to create a new column called BA and add it to our data frame:


batting$BA <- batting$H / batting$AB

#After doing this operation, check the last 5 entries of the BA column of your data frame and it should look like this:
  
tail(batting$BA,5)

# 
# Now do the same for some new columns! On Base Percentage (OBP) and Slugging Percentage (SLG). Hint: For SLG, you need 1B (Singles), this isn't in your data frame. However you can calculate it by subtracting doubles,triples, and home runs from total hits (H): 1B = H-2B-3B-HR
# 
# Create an OBP Column
# Create an SLG Column

batting$OBP <- (batting$H +batting$BB + batting$HBP)/(batting$AB +batting$BB +  batting$HBP + batting$SF)

batting$X1B <- batting$H-batting$X2B-batting$X3B-batting$HR
batting$SLG <- ((1*batting$X1B )+ (2*batting$X2B)+(3*batting$X3B)+(4*batting$HR))/(batting$AB)

str(batting)

# 
# Merging Salary Data with Batting Data
# We know we don't just want the best players, we want the most undervalued players, meaning we will also need to know current salary information! We have salary information in the csv file 'Salaries.csv'.
# 
# Complete the following steps to merge the salary data with the player stats!
# 
# Load the Salaries.csv file into a dataframe called sal using read.csv

sal <-  read.csv("Salaries.csv")
print(head(sal))
# 
# Use summary to get a summary of the batting data frame and notice the minimum year in the yearID column. Our batting data goes back to 1871! Our salary data starts at 1985, meaning we need to remove the batting data that occured before 1985.
# 
# Use subset() to reassign batting to only contain data from 1985 and onwards

summary(batting)

batting <- subset(batting, yearID>=1985)
summary(batting)
# 
# 
# Now it is time to merge the batting data with the salary data! Since we have players playing multiple years, we'll have repetitions of playerIDs for multiple years, meaning we want to merge on both players and years.
# 
# Use the merge() function to merge the batting and sal data frames by c('playerID','yearID'). Call the new data frame combo

combo <- merge(batting,sal,by=c("playerID","yearID"))

summary(combo)


# Analyzing the Lost Players
# As previously mentioned, the Oakland A's lost 3 key players during the off-season. We'll want to get their stats to see what we have to replace. The players lost were: first baseman 2000 AL MVP Jason Giambi (giambja01) to the New York Yankees, outfielder Johnny Damon (damonjo01) to the Boston Red Sox and infielder Rainer Gustavo "Ray" Olmedo ('saenzol01').
# 
# Use the subset() function to get a data frame called lost_players from the combo data frame consisting of those 3 players. Hint: Try to figure out how to use %in% to avoid a bunch of or statements!

lostplayers <- subset(combo,playerID %in% c("giambja01","damonjo01","saenzol01"))
lostplayers

# Since all these players were lost in after 2001 in the offseason, let's only concern ourselves with the data from 2001.
# 
# Use subset again to only grab the rows where the yearID was 2001.

lostplayers <- subset(lostplayers,yearID==2001)

lostplayers <-  lostplayers[,c("playerID","H","X2B","X3B","HR","OBP","SLG","BA","AB")]
head(lostplayers)

# Replacement Players
# Now we have all the information we need! Here is your final task - Find Replacement Players for the key three players we lost! However, you have three constraints:
#   
#   The total combined salary of the three players can not exceed 15 million dollars.
# Their combined number of At Bats (AB) needs to be equal to or greater than the lost players.
# Their mean OBP had to equal to or greater than the mean OBP of the lost players
# Use the combo dataframe you previously created as the source of information! Remember to just use the 2001 subset of that dataframe. There's lost of different ways you can do this, so be creative! It should be relatively simple to find 3 players that satisfy the requirements, note that there are many correct combinations available!
# 
# Helpful info on sorting data frames
# 
# (Or just use the dplr package with arrange())
# 
# There are a lot of correct answers for this part! This is where you can really have fun and explore the data with ggplot, figure out which are good data points to split your data on to find replacement players. This ending is left intentionally more open-ended so you can get a feel for exploring real data! Check out the solutions for an example of one way to solve this part.


combo <- subset(combo,yearID==2011)
str(combo)

library(ggplot)
pl <- ggplot(combo,aes(x=OBP,y=salary))+geom_point(size=2)

combo <- subset(combo,salary < 8000000 & OBP >0)
str(combo)

combo <- subset(combo,AB>=450)
str(combo)


options <- head(arrange(combo,desc(OBP)),10)
options[,c("playerID","AB","salary","OBP")]