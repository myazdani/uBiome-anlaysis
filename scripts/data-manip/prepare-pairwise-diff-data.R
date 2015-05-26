## prepare-pairwise-diff-data.R
##


setwd("~/Documents/uBiome-analysis/")

df = read.csv("./processedData/merged-excel-sheets/transposed/genus-data-TRANSPOSED.csv", header = TRUE, stringsAsFactors = FALSE)

df[is.na(df)] = 0

##
##!!!!---data clean up
##
## remove low abundant data
filter_thresh = 1e-4
max.bugs = sapply(df[,-ncol(df)], max)
df = df[,-which(max.bugs < filter_thresh)]
##
##!!!!
##

#change to a date data type
df$date = as.Date(df$date, format='%m.%d.%Y')



pairwise.abs.diff = function(df, desired.key = TRUE){
  if(class(df) != "data.frame"){
    df = as.data.frame(df)
  }
  indx = as.data.frame(combn(c(1:nrow(df)), 2))
  take.diff = function(x){
    row.diff.temp = df[x[1], ] - df[x[2],]
    if (class(row.diff.temp) == "difftime"){
      row.diff = as.data.frame(as.numeric(row.diff.temp))
    }
    else{

      row.diff = as.data.frame(row.diff.temp)
    }
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

date.pairs = as.data.frame(pairwise.abs.diff(df$date))
names(date.pairs) = "date.difference"
date.pairs$row.key = row.names(date.pairs)

date.pairs$date.diff = sapply(date.pairs$row.key, FUN = function(x) paste(df$date[as.numeric(strsplit(x, split = "-")[[1]][1])], "-", df$date[as.numeric(strsplit(x, split = "-")[[1]][2])]))

df.res = merge(date.pairs, df.pairs)
df.res$row.key = NULL
df.res$mag.dist = apply(df.res[,-c(1,2)], 1, sum)
df.res = df.res[,c("date.difference", "mag.dist", "date.diff",names(df.res[,-c(1,2,ncol(df.res))]))]

write.csv(df.res, file = "./processedData/pairwise-differences/genus-pairwise-time-diff-high-abundant.csv", row.names = FALSE, quote = FALSE)

df.res[,-c(1,2,3)] = df.res[,-c(1,2,3)]/df.res[,1]

write.csv(df.res, file = "./processedData/pairwise-differences/genus-pairwise-DERIVATIVE-high-abundant.csv", row.names = FALSE, quote = FALSE)
