## Clusters are made without the use of true labels.

########################### Clustering with k-means ###########################

# seeds and seeds_type are pre-loaded in your workspace

############# k-means: how well did you do earlier? #############
# Set random seed. Don't remove this line.
set.seed(100)

# Do k-means clustering with three clusters, repeat 20 times: seeds_km
seeds_km <- kmeans(seeds, centers = 3, nstart = 20)

# Print out seeds_km
seeds_km

## K-means clustering with 3 clusters of sizes 77, 72, 61
## Within cluster sum of squares by cluster:
## [1] 195.7453 207.4648 184.1086
##  (between_SS / total_SS =  78.4 %)


# Compare clusters with actual seed types. Set k-means clusters as rows
table(seeds_km$cluster, seeds_type)

##    seeds_type
##      1  2  3
##   1  9  0 68
##   2 60 10  2
##   3  1 60  0

# Plot the length as function of width. Color by cluster
plot(seeds$width, seeds$length, col = seeds_km$cluster)

# These larger groups represent the correspondence between the clusters and the actual types.
# E.g. cluster 1 corresponds to seed_type 3.

############# The influence of starting centroids #############
# Set random seed. Don't remove this line.
set.seed(100)

# Apply kmeans to seeds twice: seeds_km_1 and seeds_km_2
seeds_km_1 <- kmeans(seeds, centers = 5, nstart = 1)
## K-means clustering with 5 clusters of sizes 34, 56, 12, 59, 49
## Within cluster sum of squares by cluster:
## [1]  48.13507 112.33646  20.10499 129.53151 101.66862
##  (between_SS / total_SS =  84.9 %)

seeds_km_2 <- kmeans(seeds, centers = 5, nstart = 1)
## K-means clustering with 5 clusters of sizes 33, 72, 15, 31, 59
## Within cluster sum of squares by cluster:
## [1]  30.16164 173.31124  25.81297  53.13039 126.84505
##  (between_SS / total_SS =  85.0 %)


# Return the ratio of the within cluster sum of squares
seeds_km_1$tot.withinss / seeds_km_2$tot.withinss  # 1.006146

# Compare the resulting clusters
table(seeds_km_1$cluster, seeds_km_2$cluster)
#      1  2  3  4  5
#   1  0 16  0  0 18
#   2  0 56  0  0  0
#   3  0  0 12  0  0
#   4  0  0  0 18 41
#   5 33  0  3 13  0

# As we can see, some clusters remained the same, others have changed. 
# For example, cluster 5 from seeds_km_1 completely contains cluster 1 from seeds_km_2 (33 objects). 
# Cluster 4 from seeds_km_1 is split, 18 objects were put in seeds_km_2's fourth cluster and 41 in its fifth cluster. 
# For consistent and decent results, we should set nstart > 1 or determine a prior estimation of our centroids.

############# Making a scree plot! #############
# The dataset school_result is pre-loaded

# Set random seed. Don't remove this line.
set.seed(100)

# Explore the structure of your data
str(school_result)

# Initialise ratio_ss 
ratio_ss <- rep(0, 7)

# Finish the for-loop. 
for (k in 1:7) {
  
  # Apply k-means to school_result: school_km
  school_km <- kmeans(school_result, centers = k, nstart = 20)
  
  # Save the ratio between of WSS to TSS in kth element of ratio_ss
  ratio_ss[k] <- school_km$tot.withinss / school_km$totss
  
}

# Make a scree plot with type "b" and xlab "k"
plot(ratio_ss, type = "b", xlab = "k")
## The elbow in the scree plot will help you identify this turning point.
# The optimal k is 3 or 4.
# While the elbow is not always unambiguously identified, 
# it gives you an idea of the amount of clusters you should try out.

########################### Performance and scaling issues ###########################

############# Standardized vs non-standardized clustering #############

## exo 1
# The dataset run_record contains the Olympic run records for 50 countries 
# for the 100m, 200m ... to the marathon. The records are all denoted in seconds.

# Set random seed. Don't remove this line.
set.seed(1)

# Explore your data with str() and summary()
str(run_record)
summary(run_record)

# Cluster run_record using k-means: run_km. 5 clusters, repeat 20 times
run_km <- kmeans(run_record, centers = 5, nstart = 20)

# Plot the 100m as function of the marathon. Color using clusters
plot(x = run_record$marathon, y = run_record$X100m, col = run_km$cluster, 
    xlab = "run_record$marathon", ylab = "run_record$X100m")
# As you can see in the plot, the unstandarized clusters are completely dominated by the marathon records; 
# you can even separate every cluster only based on the marathon records! 

# Calculate Dunn's index: dunn_km. Print it.
dunn_km <- dunn(clusters = run_km$cluster, Data = run_record)
dunn_km  # 0.05651773
# Dunn's index seems to be quite low. 
# Compare your results with the standardized version in the next exercise

## exo 2
# The dataset run_record as well as run_km are available

# Set random seed. Don't remove this line.
set.seed(1)

# Standardize run_record, transform to a dataframe: run_record_sc
run_record_sc <- as.data.frame(scale(run_record))

# Cluster run_record_sc using k-means: run_km_sc. 5 groups, let R start over 20 times
run_km_sc <- kmeans(run_record_sc, centers = 5, nstart = 20)

# Plot records on 100m as function of the marathon. Color using the clusters in run_km_sc
plot(x = run_record$marathon, y = run_record$X100m, col = run_km_sc$cluster,
    xlab = "run_record$marathon", ylab = "run_record$X100m")
#  The plot now shows the influence of the 100m records on the resulting clusters!

# Compare the resulting clusters in a nice table
table(run_km$cluster, run_km_sc$cluster)

# Calculate Dunn's index: dunn_km_sc. Print it.
dunn_km_sc <- dunn(clusters = run_km_sc$cluster, Data = run_record_sc)
dunn_km_sc  # 0.1453556
# Dunn's index is clear about it, the standardized clusters are more compact or/and better separated!

###########################  ###########################

#############  #############







#############  #############






#############  #############
