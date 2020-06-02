# Dplyr Exercises
# Perform the following operations using only the dplyr library. We will be reviewing the following operations:
#   
#   filter() (and slice())
# arrange()
# select() (and rename())
# distinct()
# mutate() (and transmute())
# summarise()
# sample_n() and sample_frac()

library(dplyr)
#We will use the mtcars dataframe for this exercise!
  
head(mtcars)

#Return rows of cars that have an mpg value greater than 20 and 6 cylinders.

filter(mtcars,mpg>20,cyl==6)

#Reorder the Data Frame by cyl first, then by descending wt.

head(arrange(mtcars,cyl,desc(wt)))

#Select the columns mpg and hp

head(select(mtcars,mpg,hp))

#Select the distinct values of the gear column.
distinct(transmute(mtcars,gear))

#Create a new column called "Performance" which is calculated by hp divided by wt.

head(mutate(mtcars,performance=hp/wt))


#Find the mean mpg value using dplyr.

summarise(mtcars,avg_mpg=mean(mpg,na.rm=TRUE))


#Use pipe operators to get the mean hp value for cars with 6 cylinders.

mtcars %>% filter(cyl==6) %>% summarise(mean_hp=mean(hp,na.rm=TRUE))