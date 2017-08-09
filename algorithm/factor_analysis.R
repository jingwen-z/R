## FIRST METHOD ##
# write Factor Analysis function with the method "Principle Components Analysis"

factor.analysis <- function(x,m) {
  p <- nrow(x)
  x.diag <- diag(x)
  sum.rank <- sum(x.diag)

  rowname <- paste("X", 1:p, sep = "")
  colname <- paste("Factor", 1:m, sep = "")

  A <- matrix(0, nrow = p, ncol = m, dimnames = list(rowname, colname))

  eig <- eigen(x)
  # "eig" includes 2 elements, values are eigenvalue, vectors are eigenvectors

  for (i in 1:m) {
    A[, i] <- sqrt(eig$values[i]) * eig$vectors[, i]
  }

  var.A <- diag(A %*% t(A)) # variance of common factors
  rowname1 <- c("SS loadings", "Proportion Var", "Cumulative Var")

  result <- matrix(0, nrow = 3, ncol = m, dimnames = list(rowname1, colname))

  for (i in 1:m) {
    result[1,i] <- sum(A[, i] ^ 2)
    result[2,i] <- result[1, i] / sum.rank
    result[3,i] <- sum(result[1, 1:i]) / sum.rank
  }

  method <- c("Principle Component Method")

  list(method = method, loadings = A,
       var = cbind(common = var.A, specific = x.diag - var.A),
       result = result)
}

regions <- read.table("/Users/adlz/Documents/RRRRRRR/multi data analysis/PRINCIPAL COMPONENTS ANALYSIS (PCA)/REGPCA.ASC.txt",
                      header = F, sep = "", quote = "", row.names = 1)

colnames(regions) <- c("region", "popul", "tact", "superf",
                       "nbentr", "nbbrev", "chom", "teleph")

regions.bis <- regions[, -1]
R <- cor(regions.bis)
options(digits = 3)
factor.analysis(R, 4)

## SECOND METHOD ##
# use the funcion "factanal()"

factanal(regions.bis, factors = 3)
