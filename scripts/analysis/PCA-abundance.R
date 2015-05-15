### PCA-abundance.R
###
### 

setwd("~/Documents/uBiome-analysis/")

df = read.csv("./processedData/species-data.csv", header = TRUE, stringsAsFactors = FALSE)

df[is.na(df)] = 0

pca.result = prcomp(as.matrix(df[,-1]))

pca.df = as.data.frame(pca.result$x)
pca.df$bug = df[,1]

library(ggplot2)
library(GGally)

#ggpairs(pca.df, columns = c(1:4), title = "uBiome Species for LS", params=list(corSize=2))

ggplot(pca.df, aes(x = PC1, y = PC2, label = bug)) +geom_text() -> p

library(plotly)
py = plotly()
#py$ggplotly(p, kwargs=list(filename="LS-ubiome-species-PCA", fileopt="overwrite"))

##-----------------------------------------------------
## TRANSPOSE DATA FRAME
##-----------------------------------------------------

df$species = sapply(df$species, FUN = function(x) gsub(" ", ".", x))

# first remember the names
n <- df$species

# transpose all but the first column (name)
df.T <- as.data.frame(t(df[,-1]))
colnames(df.T) <- n
row.names(df.T) = unname(sapply(names(df[-1]), FUN = function(x) strsplit(x, split = ".abundance")[[1]][1]))
#df.T$myfactor <- factor(row.names(df))

pca.result = prcomp(as.matrix(df.T))

pca.df = as.data.frame(pca.result$x)
pca.df$sample.date = sapply(rownames(df.T), FUN = function(x) strsplit(x, split = "X")[[1]][2])

#ggpairs(pca.df, columns = c(1:4), title = "uBiome Species for LS", params=list(corSize=2))
ggplot(pca.df, aes(x = PC1, y = PC2, label = sample.date)) +geom_text() -> p

#py$ggplotly(p, kwargs=list(filename="LS-ubiome-time-samples-species-PCA", fileopt="overwrite"))

##-----------------------------------------------------
## Plot time series of PC's
##-----------------------------------------------------
pca.df$sample.date = as.Date(pca.df$sample.date, format='%m.%d.%Y')

library(reshape)
pca.m = melt(pca.df[,c("PC1", "PC2", "PC3","sample.date")], id = "sample.date")

ggplot(pca.m, aes(x = sample.date, y = value)) + geom_point() + 
  facet_wrap(~variable, nrow = 3, scales = "free_y") + stat_smooth() -> p

#py$ggplotly(p, kwargs=list(filename="LS-ubiome-time-vs-PC1-species", fileopt="overwrite"))
##-----------------------------------------------------
## Plot loadings of first three PCs
##-----------------------------------------------------

pca.loadings = as.data.frame(pca.result$rotation[,c(1:3)])
pca.loadings$bug = rownames(pca.loadings)

pca.loadings.m = melt(pca.loadings, id = "bug")
ggplot(pca.loadings.m, aes(x = bug, y = value)) + geom_point() +  
  facet_wrap(~variable, nrow = 1, scales = "free_y")  + xlab("") + scale_x_discrete(breaks=NULL)-> p 

#py$ggplotly(p, kwargs=list(filename="LS-ubiome-species-PCA-loadings", fileopt="overwrite"))
