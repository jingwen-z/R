################ small exercise - Clustering ################

reveduc <- read.table("/Users/adlz/Documents/RRRRRRR/multi data analysis/CLUSTERING (CL)/reveduc.txt", header = FALSE,
                      sep = "", row.names = 1)
colnames(reveduc) <- c("Rev","Educ")
attach(reveduc)
head(reveduc)

#############
## K-Means ##
#############

rd_km <- kmeans(reveduc,3,algorithm = "MacQueen")
# MacQueen: This algorithm works by repeatedly moving all cluster centers to the mean of their respective Voronoi sets.

rd_km$centers
rd_km$cluster

rd_km$totss            # 701.6667
rd_km$tot.withinss     # 15
rd_km$betweenss        # 686.6667
# rd_km$totss <- rd_km$tot.withinss + rd_km$betweenss

plot(reveduc, pch = rd_km$cluster)
points(rd_km$centers, pch = 18)
legend(rd_km$centers[1,1], rd_km$centers[1,2], "Center_1", bty = "n", xjust = 1, yjust = 1, cex = 0.8)
legend(rd_km$centers[2,1], rd_km$centers[2,2], "Center_2", bty = "n", xjust = 0, yjust = 0.5, cex = 0.8)
legend(rd_km$centers[3,1], rd_km$centers[3,2], "Center_3", bty = "n", xjust = 0, yjust = 0.5, cex = 0.8)
