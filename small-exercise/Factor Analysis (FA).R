############################## small exercise - FA ################################

### FIRST METHOD ###
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
factor.analysis(R,4)

## according to "factor.analysis(R,4)$loadings", we can get the following regressions of initial variable and 4 factors
# X1 = 0.9578*F1 - 0.2555*F2 - 0.0444*F3 - 0.0888*F4
# X2 = 0.7272*F1 + 0.5926*F2 + 0.1493*F3 + 0.3077*F4
# X3 = -0.0155*F1 - 0.3319*F2 + 0.9420*F3 + 0.0320*F4
# X4 = 0.9489*F1 - 0.2798*F2 + 0.0809*F3 - 0.0765*F4
# X5 = 0.9735*F1 + 0.0224*F2 - 0.1575*F3 + 0.0620*F4
# X6 = -0.2999*F1 - 0.8812*F2 - 0.2579*F3 + 0.2588*F4
# X7 = 0.9722*F1 - 0.2180*F2 - 0.0536*F3 - 0.0497*F4

## according to the real meaning of initial variables, we can summarize these 7 variables as 4 aspects
# The loading coefficients between Factor 1 and X1(population), X4(number of firms of the region), 
# X5(number of patents taken out during the year), X7(number of telephone lines in place in the region) are 
# larger than 0.8, which indicates high positive correlation, thus Factor 1 refelcts the economic development of the regions.

# The loading coefficient between Factor 2 and X6(unemployment rate) is higher, which indicates the chomage.

# The loading coefficient between Factor 3 and X3(surface of the region) is higher, which reflects the surface of the region.

# Factor 4 indicates people's general situation in the region.

### SECOND METHOD ###
# we can use the funcion "factanal()" directly

factanal(regions.bis,factors = 3)

## According to "factanal(regions.bis,factors = 3)$loadings", we can observe that when the number of factor is 3, the cumulative variance is larger than 0.8.
## Thus, we could make sure that the number of factor is 3, this result is NOT the same as the one above. 
## But in my opinion, this method is more reasonale. 
## Then, we get the following regressions between each factor and variables.
# F1 = 0.991*popul + 0.442*tact + 0.980*nbentr + 0.907*nbbrev + 0.990*teleph
# F2 = 0.893*tact + 0.101*nbentr + 0.335*nbbrev - 0.781*chom + 0.132*teleph
# F3 = 0.875*superf + 0.158*nbentr - 0.193*nbbrev

## According to the regressions above, we can get the real explanatory meaning as following.
# Factor 1 is highly correlated to population, number of firms of the region, number of patents taken out during the year and 
# number of telephone lines in place in the region, thus Factor 1 refelcts the economic development of the regions.
# Factor 2 is highly correlated to activity rate of the region and unemployment rate, which means Factor 2 indicates 
# people's general situation in the region.
# Factor 3 is highly correlated to surface of the region, which reflects Factor 3 indicates the surface of the region.
