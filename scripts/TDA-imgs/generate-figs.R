##
## generate-figs.R
##

setwd("~/Documents/uBiome-analysis/")

library(reshape)
library(ggplot2)

df = read.csv("./processedData/pairwise-differences/genus-pairwise-time-diff-high-abundant-BAD-DATES-REMOVED.csv", header = TRUE, stringsAsFactors = FALSE)

#'melt' the data frame into long format

df.biome = df[,-c(1:2)]

df.melt <- melt(df.biome, id.vars="date.diff")

p =  ggplot(bleh, aes(x = variable, y = value)) + geom_point(size = 1)
p + theme(axis.line=element_blank(),axis.text.x=element_blank(),
      axis.text.y=element_blank(),axis.ticks=element_blank(),
      axis.title.x=element_blank(),
      axis.title.y=element_blank(),legend.position="none",
      panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
      panel.grid.minor=element_blank(),plot.background=element_blank()) -> q


ggsave(filename = "plot.png", width = 4, height = 4, scale = 1, dpi = 300, units = "cm")
