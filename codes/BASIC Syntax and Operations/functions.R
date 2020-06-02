# R Functions Exercises
# Let's test your knowledge of functions in R! For these exercisee you be given instructions to create functions that take in certain inputs and give certain outputs. Just follow any instructions written in bold below. The first two are examples done for you.
# 
# EXAMPLE 1: Create a function that takes in a name as a string argument, and prints out "Hello name"

hello_you <- function(name){
    print(paste('Hello',name))
}

hello_you("UDAY")

#EXAMPLE 2: Create a function that takes in a name as a string argument and returns a string of the form - "Hello name"

hello <- function(name){
  return(paste('Hello',name))
}
hello("UDAY V J")

#Ex 1: Create a function that will return the product of two integers.

prod <- function(x,y){
  return(x*y)
}
prod(2,3)

Ex# 2: Create a function that accepts two arguments, an integer and a vector of integers. It returns TRUE if the integer is present in the vector, otherwise it returns FALSE. Make sure you pay careful attention to your placement of the return(FALSE) line in your function!
  
num_check <- function(x1,y1){
  for (a in y1){
    if(a==x1){
      return(TRUE)
    }
  }
  return(FALSE)
}
num_check(2,c(1,2,3))
num_check(2,c(1,4,5))

#Ex 3: Create a function that accepts two arguments, an integer and a vector of integers. It returns the count of the number of occurences of the integer in the input vector.
num_count <- function(x2,y2){
  c <- 0
  for (a in y2){
    if(a==x2){
      c <- c+1
    }
  }
  return(c)
}
num_count(1,c(1,1,2,2,3,1,4,5,5,2,2,1,3))

# 
# Ex 4: We want to ship bars of aluminum. We will create a function that accepts an integer representing the requested kilograms of aluminum for the package to be shipped. To fullfill these order, we have small bars (1 kilogram each) and big bars (5 kilograms each). Return the least number of bars needed.
# 
# For example, a load of 6 kg requires a minimum of two bars (1 5kg bars and 1 1kg bars). A load of 17 kg requires a minimum of 5 bars (3 5kg bars and 2 1kg bars).

bar_count <- function(num){
  w <- num%/%5
  e <- num  %% 5
  return(w+e)
}

bar_count(6)
bar_count(17)


#Ex 5: Create a function that accepts 3 integer values and returns their sum. However, if an integer value is evenly divisible by 3, then it does not count towards the sum. Return zero if all numbers are evenly divisible by 3. Hint: You may want to use the append() function.

summer <- function(a, b, c){
  out <- c(0)
  if (a %% 3 != 0){
    out <- append(a,out)
  }
  if (b %% 3 != 0){
    out <- append(b,out)
  }
  if (c %% 3 != 0){
    out <- append(c,out)
  }
  print(out)
  return(sum(out))       
}

summer(9,11,12)

#Ex 6: Create a function that will return TRUE if an input integer is prime. Otherwise, return FALSE. You may want to look into the any() function.

prime_check <- function(num){
  if(num==2){
    return(TRUE)
  }
  for (i in 2:(num-1)){
    if ((num%%i)==0){
      return(FALSE)
    }
  }
  return(TRUE)
}

prime_check(846353)
