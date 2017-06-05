### Chapter 6: Basic graphs

## 6.1 bar plots
# simple bar plots
library(vcd)
barplot(table(Arthritis$Improved),
        main = "Simple Bar Plot",
        xlab = "Improvement",
        ylab = "Frequency")

barplot(table(Arthritis$Improved),
        main = "Simple Bar Plot",
        xlab = "Improvement",
        ylab = "Frequency",
        horiz = TRUE)

plot(Arthritis$Improved)

# stacked and grouped bar plots
counts <- table(Arthritis$Improved, Arthritis$Treatment)
barplot(counts,
        main = "Stacked Bar Plot",
        xlab = "Treatment",
        ylab = "Frequency",
        col = c("red", "yellow", "green"),
        legend = rownames(counts))

barplot(counts,
        main = "Grouped Bar Plot",
        xlab = "Treatment",
        ylab = "Frequency",
        col = c("red", "yellow", "green"),
        legend = rownames(counts),
        beside = TRUE)

# mean bar plots
states <- data.frame(state.region, state.x77)
illiteracyMeans <- aggregate(states$Illiteracy,
                             by = list(state.region),
                             FUN = mean)
illiteracyMeans <- illiteracyMeans[order(illiteracyMeans$x), ]

barplot(illiteracyMeans$x,
        names.arg = illiteracyMeans$Group.1,
        main = "Mean Illiteracy Rate")

# tweaking bar plots
par(mar = c(5, 8, 4, 2), las = 2)
improvedCounts <- table(Arthritis$Improved)
barplot(improvedCounts,
        main = "Treatment Outcome",
        horiz = TRUE,
        cex.names = 0.8,
        names.arg = c("No Improvement",
                      "Some Improvement",
                      "Marked Improvement"))

# spinogram
spine(table(Arthritis$Treatment, Arthritis$Improved), main = "Spinogram Example")
