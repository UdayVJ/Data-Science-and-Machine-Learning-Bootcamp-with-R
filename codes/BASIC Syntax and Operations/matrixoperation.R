# R Matrix Exercises
# Through these exercises we will review the matrix data structure and perhaps introduce you to a few ideas for you to discover on your own! Just answer the questions below written in bold:
#   
#   Ex 1: Create 2 vectors A and B, where A is (1,2,3) and B is (4,5,6). With these vectors, use the cbind() or rbind() function to create a 2 by 3 matrix from the vectors. You'll need to figure out which of these binding functions is the correct choice.

A <- c(1,2,3)
B <- c(4,5,6)
mat <- matrix(A)
colnames(mat) <- 'A'
mat <- cbind(mat,B)
print(mat)

#Ex 2: Create a 3 by 3 matrix consisting of the numbers 1-9. Create this matrix using the shortcut 1:9 and by specifying the nrow argument in the matrix() function call. Assign this matrix to the variable mat

mat1 <- matrix(1:9,nrow=3)
print(mat1)

#Ex 3: Confirm that mat is a matrix using is.matrix()
is.matrix(mat1)

#Ex 4: Create a 5 by 5 matrix consisting of the numbers 1-25 and assign it to the variable mat2. The top row should be the numbers 1-5.
mat2 <- matrix(1:25,byrow=T,nrow=5)
print(mat2)

# Ex 5: Using indexing notation, grab a sub-section of mat2 from the previous exercise that looks like this:
#   [7,8]
# [12,13]

print(mat2[2:3,2:3])

# Ex 6: Using indexing notation, grab a sub-section of mat2 from the previous exercise that looks like this:
#   [19,20]
# [24,25]
print(mat2[4:5,4:5])

#Ex 7: What is the sum of all the elements in mat2?

print(sum(mat2))

#Ex 8: Ok time for our last exercise! Find out how to use runif() to create a 4 by 5 matrix consisting of 20 random numbers (4*5=20).
 runif(1:20,1,100)
mat4 <- matrix(runif(20),nrow=4)
print(mat4)