# Conditional Statements Exercises
# For these exercises, use what you have learned about if,else if, and else statements to answer the questions! The first exercise is done for you as an example:
#   
#   Example: Write a script that prints "Hello" if the variable x is equal to 1:

x <- 1
if(x==1){
  print("Hello")
}

# Exercise Problems
# Ex 1: Write a script that will print "Even Number" if the variable x is an even number, otherwise print "Not Even":

x <- 4
if(x%%2 == 0){
  print("Even Number")
}else{
  print("Not Even")
}


#Ex 2: Write a script that will print 'Is a Matrix' if the variable x is a matrix, otherwise print "Not a Matrix". Hint: You may want to check out help(is.matrix)
X <- matrix(1:12,nrow=3)

 if(is.matrix(X)){
   print("X is a Matrix")
 }else {
   print("X is not a Matrix")
 }

#Ex 3: Create a script that given a numeric vector x with a length 3, will print out the elements in order from high to low. You must use if,else if, and else statements for your logic. (This code will be relatively long)

a <- c(4,8,1)

if(length(a)>2){
  print(sort(a),decreasing =FALSE)
}

if(a[1]>a[2]){
  fir <- a[1]
  sec <- a[2]
}else{
  sec <- a[1]
  fir <- a[2]
}

if(a[3] > fir & a[3] > sec){
  thr <- sec
  sec <- fir
  fir <- a[3]
}else if (a[3] < fir & a[3] < sec){
  thr <- a[3]
}else{
  thr <- sec
  sec <- a[3]
}

print(paste(fir,sec,thr))

#Ex 4: Write a script that uses if,else if, and else statements to print the max element in a numeric vector with 3 elements.

b <- c(20, 10, 100)

if(b[1]> b[2] & b[1] > b[3]){
  print(b[1])
}else if(b[2]>b[3]){
  print(b[2])
}else{
  print(b[3])
}