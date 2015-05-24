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
files.to.skip = c("9.25.2013 Ubiome kit 900-009-361.xls", "10.2.2013 Ubiome kit 380-002-047.xls",
                  "10.10.2013 Ubiome kit 900-003-627.xls", "10.23.2013 Ubiome kit 900-003-628.xls",
                  "2.17.2014 Ubiome kit 106-003-133.xls", "5.4.2014 Ubiome kit 151-003-131.xls")
excel.files = setdiff(excel.files, files.to.skip)

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
  date.cols = unname(sapply(names(res[,-1]), FUN = function(x) strsplit(x, split = " abundance")[[1]][1]))
  date.cols = as.Date(date.cols, format='%m.%d.%Y')
  res = res[,c(1,1+order(date.cols))]
  write.csv(res, file = paste0("./processedData/merged-excel-sheets/",sheets[sheet],"-data.csv"), row.names = FALSE, quote = FALSE)
}
