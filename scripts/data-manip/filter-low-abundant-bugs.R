## filter-low-abundant-bugs.R
##

setwd("~/Documents/uBiome-analysis/")


df = read.csv("./processedData/merged-excel-sheets/genus-data.csv", header = TRUE, stringsAsFactors = FALSE)

filter_thresh = 1e-4
df[is.na(df)] = 0
max.bugs = apply(df[,-1], 1, FUN = function(x) max(x, na.rm = TRUE))

df.filtered = df[which(max.bugs > filter_thresh),]

write.csv(df.filtered, file = "./processedData/high-abundant-bugs/genus-data-high-abundant.csv", row.names = FALSE, quote = FALSE)