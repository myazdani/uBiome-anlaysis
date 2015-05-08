### PCA-abundance.R
###
### MDS on Bray Curtis distances of uBiome data

setwd("~/Documents/uBiome-analysis/")

df = read.csv("./processedData/species-data.csv", header = TRUE, stringsAsFactors = FALSE)

df[is.na(df)] = 0

df.pca = prcomp(as.matrix(df[,-1]))
