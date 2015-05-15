## merge-sheets-excel.R
##

setwd("~/Documents/uBiome-analysis/")
#library(devtools)
#install_github("hadley/readxl")

#sheets = c("superkingdom", "phylum", "class", "order", "family", "genus", "species")
sheets = c("family", "genus", "species")

library(readxl)
library(plyr)
data.path = "./data/Excel/"
excel.files = list.files(data.path, full.names = FALSE)
for (sheet in c(1:length(sheets))){
  data.files = list()
  date.ids = c()
  for (i in c(1:length(excel.files))){
    temp.df = as.data.frame(read_excel(paste0(data.path, excel.files[i]), sheet = sheets[sheet]))
    temp.df = temp.df[,c(sheets[sheet], "abundance")]
    date.id = strsplit(excel.files[i], split = " Ubiome")[[1]][1]
    if (date.id %in% date.ids) {
      date.id = paste0(date.id, "-1")
    }
    date.ids[i] = date.id
    
    names(temp.df)[2] = paste(date.id, "abundance")
    data.files[[i]] = temp.df
  }
  
  res = join_all(data.files, type = "full", match = "all")
  
  write.csv(res, file = paste0("./processedData/merged-excel-sheets/",sheets[sheet],"-data.csv"), row.names = FALSE, quote = FALSE)
}
