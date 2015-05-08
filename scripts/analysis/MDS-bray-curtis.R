### MDS-bray-curtis.R
###
### MDS on Bray Curtis distances of uBiome data

setwd("~/Documents/uBiome-analysis/")

ubiome.amgut = read.delim("./processedData/FromJustine/bray_curtis_ubiome_amgut.txt", header = TRUE, stringsAsFactors = FALSE)

ubiome = ubiome.amgut[c(1:38), c(1:39)]

names(ubiome)[1] = "sample.date"

source.matrix = as.matrix(ubiome[,-1])
rownames(source.matrix) = colnames(source.matrix)
target.data= data.frame(ubiome$sample.date, key = colnames(source.matrix))

library(MASS)
d = as.dist(source.matrix)

fit <- isoMDS(d, k=2) # k is the number of dim
fit # view results

# plot solution 
res = data.frame(x = fit$points[,1], y = fit$points[,2], dates = target.data$ubiome.sample.date)
library(ggplot2)

ggplot(res, aes(x = x, y = y, label = dates)) + geom_text() -> p