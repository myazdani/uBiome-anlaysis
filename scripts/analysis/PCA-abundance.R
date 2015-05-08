### PCA-abundance.R
###
### MDS on Bray Curtis distances of uBiome data

setwd("~/Documents/uBiome-analysis/")

df = read.csv("./processedData/species-data.csv", header = TRUE, stringsAsFactors = FALSE)

df[is.na(df)] = 0

pca.result = prcomp(as.matrix(df[,-1]))

pca.df = as.data.frame(pca.result$x)
pca.df$sample.date = df[,1]

library(ggplot2)
library(GGally)

#ggpairs(pca.df, columns = c(1:4), title = "uBiome Species for LS", params=list(corSize=2))

ggplot(pca.df, aes(x = PC1, y = PC2, label = sample.date)) +geom_text() -> p

library(plotly)
py = plotly()
py$ggplotly(p, kwargs=list(filename="LS-ubiome-species-PCA", fileopt="overwrite"))
