# Tree Models

library(rpart)
df <- kyphosis

print(str(df))
print(head(df))

# Model

tree <- rpart(Kyphosis ~ . ,method="class",data=df)
printcp(tree)

plot(tree,uniform = T,main="Tree")
text(tree,use.n=T,all=T)

## easy way

#install.packages("rpart.plot")
library(rpart.plot)
prp(tree)

############
############
#random forest
############

#install.packages("randomForest")
library(randomForest)

rf.model <- randomForest(Kyphosis ~ . ,method="class",data=df)
print(rf.model)
print(rf.model$ntree)