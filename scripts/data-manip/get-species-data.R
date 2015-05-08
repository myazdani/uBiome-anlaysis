## get-species-data.R
##

setwd("~/Documents/uBiome-analysis/")
#library(devtools)
#install_github("hadley/readxl")

library(readxl)
data.path = "./data/Excel/"
excel.files = list.files(data.path, full.names = FALSE)
data.files = list()
date.ids = c()
for (i in c(1:length(excel.files))){
  temp.df = as.data.frame(read_excel(paste0(data.path, excel.files[i]), sheet = "species"))
  temp.df = temp.df[,c("species", "abundance")]
  date.id = strsplit(excel.files[i], split = " Ubiome")[[1]][1]
  if (date.id %in% date.ids) {
    date.id = paste0(date.id, "-1")
  }
  date.ids[i] = date.id
  
  names(temp.df)[2] = paste(date.id, "abundance")
  data.files[[i]] = temp.df
}

res = join_all(data.files, type = "full", match = "all")

write.csv(res, file = "./processedData/species-data.csv", row.names = FALSE, quote = FALSE)