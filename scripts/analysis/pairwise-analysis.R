### dist-corr-ubiome.R


library(pairwiseDist)

ubiome.amgut = read.delim("~/Desktop/ubiome/bray_curtis_ubiome_amgut.txt", header = TRUE, stringsAsFactors = FALSE)

ubiome = ubiome.amgut[c(1:38), c(1:39)]

names(ubiome)[1] = "sample.date"

source.matrix = as.matrix(ubiome[,-1])
rownames(source.matrix) = colnames(source.matrix)
target.data= data.frame(ubiome$sample.date, key = colnames(source.matrix))

#change to a date data type
target.data$ubiome.sample.date = sapply(target.data$ubiome.sample.date, FUN = function(x) as.POSIXct(x, format = "%m.%d.%Y"))

# target.source.diff = function(target.key, target.df, source.key, source.df, target.matrix = FALSE, source.matrix = FALSE, 
#                               target.method = "euclidean", target.p = 2, source.method = "euclidean", source.p = 2)
#   
pairwise.res = target.source.diff(target.key = target.data$key, target.df = target.data[,1], source.df = source.matrix, source.key = colnames(source.matrix), source.matrix = TRUE)
names(pairwise.res)[2] = "time.difference"

get.base.year = function(x){
  year.1.chars = strsplit(as.character(x), split = "-")[[1]][1]
  year.2.chars = strsplit(as.character(x), split = "-")[[1]][2]
  year.1 = as.numeric(substr(year.1.chars, nchar(year.1.chars)-4, nchar(year.1.chars)))
  year.2 = as.numeric(substr(year.2.chars, nchar(year.2.chars)-4, nchar(year.2.chars)-1))
  return(min(year.1, year.2))
}

pairwise.res$base.year = sapply(pairwise.res$pairs, get.base.year)

library(ggplot2)
ggplot(pairwise.res, aes(x = time.difference, y = source.matrix.distances, label = pairs)) + geom_text() -> p
library(plotly)
py = plotly()
py$ggplotly(p, kwargs=list(filename="LS-ubiome", fileopt="overwrite"))


source.matrix.noise = matrix(runif(38*38, min = .16, max = .66), ncol=38, nrow = 38)
rownames(source.matrix.noise) = rownames(source.matrix)
colnames(source.matrix.noise) = colnames(source.matrix)
pairwise.res.noise = target.source.diff(target.key = target.data$key, target.df = target.data[,1], 
                                  source.df = source.matrix.noise, source.key = colnames(source.matrix.noise), source.matrix = TRUE)

names(pairwise.res.noise)[2] = "time.difference"
ggplot(pairwise.res.noise, aes(x = time.difference, y = source.matrix.noise.distances, label = pairs)) + geom_text() -> p.noise
py$ggplotly(p.noise, kwargs=list(filename="noise-data", fileopt="overwrite"))
