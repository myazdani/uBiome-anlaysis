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


##-----------------------------------------------------
## Plot heatmap of PC's
##-----------------------------------------------------

myData <- pca.result$rotation

# Replace with numbers that actually have a relationship:
for(ii in 2:ncol(myData)){  myData[, ii] <- myData[, ii-1] + rnorm(nrow(myData))  }
for(ii in 2:nrow(myData)){  myData[ii, ] <- myData[ii-1, ] + rnorm(ncol(myData))  }

# For melt() to work seamlessly, myData has to be a matrix.
longData <- melt(myData)
head(longData, 20)

# Optionally, reorder both the row and column variables in any order
# Here, they are sorted by mean value
longData$X1 <- factor(longData$X1, names(sort(with(longData, by(value, X1, mean)))))
longData$X2 <- factor(longData$X2, names(sort(with(longData, by(value, X2, mean)))))

# Define palette
myPalette <- colorRampPalette(rev(brewer.pal(11, "Spectral")), space="Lab")

zp1 <- ggplot(longData,
              aes(x = X2, y = X1, fill = value))
zp1 <- zp1 + geom_tile()
zp1 <- zp1 + scale_fill_gradientn(colours = myPalette(100))
zp1 <- zp1 + scale_x_discrete(expand = c(0, 0))
zp1 <- zp1 + scale_y_discrete(expand = c(0, 0))
zp1 <- zp1 + coord_equal()
zp1 <- zp1 + theme_bw()
print(zp1)