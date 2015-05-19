## data-transposer.R
## 
## transpose CSV files so that rows are dates

setwd("~/Documents/microbiome-analysis/uBiome-anlaysis/")

df = read.csv("./processedData/merged-excel-sheets/family-data.csv", header = TRUE, stringsAsFactors = FALSE)

# first remember the names
n <- df[,1]

# transpose all but the first column (name)
df.T <- as.data.frame(t(df[,-1]))
colnames(df.T) <- n

df.T$date = sapply(row.names(df.T), FUN = function(x) strsplit(strsplit(x, split = ".abundance")[[1]][1], "X")[[1]][2])

write.csv(df.T, file = "./processedData/merged-excel-sheets/transposed/family-data-TRANSPOSED.csv", row.names = FALSE, quote = FALSE)