############################## small exercise - FA ################################

# in fact, we usually use the method "Principle Components Analysis" to estimate loading factors
# thus, we'll firstly write Factor Analysis function with the method "Principle Components Analysis"

factor.analysis <- function(x,m) {
  p=nrow(x); x.diag=diag(x); sum.rank=sum(x.diag)
  rowname=paste("X",1:p,sep = "")
  colname=paste("Factor",1:m,sep="")
  
  # create loading factor matrix A, initial value is 0
  A <- matrix(0,nrow=p,ncol=m,dimnames=list(rowname,colname))
  eig <- eigen(x) # "eig" includes 2 elements, values are eigenvalue, vectors are eigenvectors
  
  for (i in 1:m) {
    A[,i] <- sqrt(eig$values[i])*eig$vectors[,i] # fill in the values of matrix A
  }
  
  var.A <- diag(A%*%t(A)) # variance of common factors
  rowname1 <- c("SS loadings","Proportion Var","Cumulative Var")
  
  # create matrix of output, initial value is 0
  result <- matrix(0, nrow = 3, ncol = m,dimnames = list(rowname1, colname))
  
  for (i in 1:m) {
    result[1,i] = sum(A[,i]^2) # the variance of each factor
    result[2,i] = result[1,i]/sum.rank # contribution rate of variance
    result[3,i] = sum(result[1,1:i])/sum.rank # cumulative contribution rate of variance
  }
  
  method <- c("Principle Component Method")
  
  list(method=method,loadings=A,var=cbind(common=var.A,specific=x.diag-var.A),result=result)
}

regions <- read.table("/Users/adlz/Documents/RRRRRRR/multi data analysis/PRINCIPAL COMPONENTS ANALYSIS (PCA)/REGPCA.ASC.txt",
                      header=FALSE,sep = "",quote="",row.names = 1)
colnames(regions) <- c('region','popul','tact','superf','nbentr','nbbrev','chom','teleph')
head(regions)
regions.bis <- regions[,-1]
R <- cor(regions.bis)
options(digits = 3)
factor.analysis(R,5)

