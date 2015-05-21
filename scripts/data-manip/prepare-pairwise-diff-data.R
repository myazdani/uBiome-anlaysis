## prepare-pairwise-diff-data.R
##


setwd("~/Documents/uBiome-analysis/")

df = read.csv("./processedData/merged-excel-sheets/transposed/genus-data-TRANSPOSED.csv", header = TRUE, stringsAsFactors = FALSE)

df[is.na(df)] = 0

#change to a date data type
df$date = as.Date(df$date, format='%m.%d.%Y')



pairwise.abs.diff = function(df, desired.key = TRUE){
  if(class(df) != "data.frame"){
    df = as.data.frame(df)
  }
  indx = as.data.frame(combn(c(1:nrow(df)), 2))
  take.diff = function(x){
    row.diff = as.data.frame(df[x[1], ] - df[x[2],])
    row.names(row.diff) = paste(x[1], "-", x[2])
    return(row.diff)
  }
  res = lapply(indx, take.diff)
  res = do.call(rbind,res)
  row.names(res) = sapply(indx, FUN = function(x) paste(x[1], "-", x[2]))
  return(abs(res))
}

df.pairs = as.data.frame(pairwise.abs.diff(df[,-which(names(df) %in% "date")]))
df.pairs$row.key = row.names(df.pairs)


dates.in.unix = sapply(df[,which(names(df) %in% "date")], FUN = function(x) as.POSIXct(x))/100
date.pairs = as.data.frame(pairwise.abs.diff(dates.in.unix))
names(date.pairs) = "date.difference"
date.pairs$row.key = row.names(date.pairs)

df.res = merge(date.pairs, df.pairs)

write.csv(df.res, file = "./processedData/pairwise-differences/genus-pairwise-time-diff.csv", row.names = FALSE, quote = FALSE)