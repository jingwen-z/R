########## Clustering with k-means ##########

### k-means: how well did you do earlier? ###
set.seed(100)

seeds_km <- kmeans(seeds, centers = 3, nstart = 20)
seeds_km

# Compare clusters with actual seed types. Set k-means clusters as rows
table(seeds_km$cluster, seeds_type)

# Plot the length as function of width. Color by cluster
plot(seeds$width, seeds$length, col = seeds_km$cluster)

### The influence of starting centroids ###
set.seed(100)

# Apply kmeans to seeds twice: seeds_km_1 and seeds_km_2
seeds_km_1 <- kmeans(seeds, centers = 5, nstart = 1)
seeds_km_2 <- kmeans(seeds, centers = 5, nstart = 1)

# Return the ratio of the within cluster sum of squares
seeds_km_1$tot.withinss / seeds_km_2$tot.withinss

# Compare the resulting clusters
table(seeds_km_1$cluster, seeds_km_2$cluster)

### Making a scree plot! ###
set.seed(100)

str(school_result)
ratio_ss <- rep(0, 7)

# Finish the for-loop.
for (k in 1:7) {
  school_km <- kmeans(school_result, centers = k, nstart = 20)
  ratio_ss[k] <- school_km$tot.withinss / school_km$totss

}

# Make a scree plot with type "b" and xlab "k"
plot(ratio_ss, type = "b", xlab = "k")


########## Performance and scaling issues ##########

### Standardized vs non-standardized clustering ###

## exo 1
set.seed(1)

# Explore your data with str() and summary()
str(run_record)
summary(run_record)

# Cluster run_record using k-means: run_km. 5 clusters, repeat 20 times
run_km <- kmeans(run_record, centers = 5, nstart = 20)

# Plot the 100m as function of the marathon. Color using clusters
plot(x = run_record$marathon,
     y = run_record$X100m,
     col = run_km$cluster,
     xlab = "run_record$marathon",
     ylab = "run_record$X100m")

# Calculate Dunn's index: dunn_km. Print it.
dunn_km <- dunn(clusters = run_km$cluster, Data = run_record)
dunn_km

## exo 2
set.seed(1)

# Standardize run_record, transform to a dataframe: run_record_sc
run_record_sc <- as.data.frame(scale(run_record))

run_km_sc <- kmeans(run_record_sc, centers = 5, nstart = 20)

# Plot records on 100m as function of the marathon. Color using the clusters in run_km_sc
plot(x = run_record$marathon,
     y = run_record$X100m,
     col = run_km_sc$cluster,
     xlab = "run_record$marathon",
     ylab = "run_record$X100m")

# Compare the resulting clusters in a nice table
table(run_km$cluster, run_km_sc$cluster)

dunn_km_sc <- dunn(clusters = run_km_sc$cluster, Data = run_record_sc)
dunn_km_sc


########## Hierarchical Clustering ##########

### Single Hierarchical Clustering ###
run_dist <- dist(run_record_sc)

# Apply hclust() to run_dist: run_single
run_single <- hclust(run_dist, method = "single")

# Apply cutree() to run_single: memb_single
memb_single <- cutree(run_single, k = 5)

# Apply plot() on run_single to draw the dendrogram
plot(run_single)

# Apply rect.hclust() on run_single to draw the boxes
rect.hclust(run_single, k = 5, border = 2:6)

### Complete Hierarchical Clustering ###
# Code for single-linkage
run_dist <- dist(run_record_sc, method = "euclidean")
run_single <- hclust(run_dist, method = "single")
memb_single <- cutree(run_single, 5)
plot(run_single)

rect.hclust(run_single, k = 5, border = 2:6)
run_complete <- hclust(run_dist, method = "complete")
memb_complete <- cutree(run_complete, k = 5)
plot(run_complete)
rect.hclust(run_complete, k = 5, border = 2:6)

# table() the clusters memb_single and memb_complete. Put memb_single in the rows
table(memb_single, memb_complete)

### Hierarchical vs k-means ###
set.seed(100)

dunn_km <- dunn(clusters = run_km_sc$cluster,
                Data = run_record_sc,
                method = "euclidean")

dunn_single <- dunn(clusters = memb_single, Data = run_record_sc, method = "euclidean")

dunn_complete <- dunn(clusters = memb_complete, Data = run_record_sc, method = "euclidean")

# Compare k-means with single-linkage
table(run_km_sc$cluster, memb_single)

# Compare k-means with complete-linkage
table(run_km_sc$cluster, memb_complete)

### Clustering US states based on criminal activity ###
set.seed(1)

crime_data_sc <- scale(crime_data)
crime_km <- kmeans(crime_data_sc, centers = 4, nstart = 20)

dist_matrix <- dist(crime_data_sc)

## Calculate the clusters using hclust(): crime_single
crime_single <- hclust(dist_matrix, method = "single")

## Cut the clusters using cutree: memb_single
memb_single <- cutree(crime_single, k = 4)

# Calculate the Dunn's index for both clusterings: dunn_km, dunn_single
dunn_km <- dunn(clusters = crime_km$cluster, Data = crime_data_sc)
dunn_single <- dunn(clusters = memb_single, Data = crime_data_sc)
