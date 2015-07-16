library(dplyr)
library(ggplot2)

if (!exists("NEI")){
        NEI <- readRDS("Raw_Data/summarySCC_PM25.rds")
}

if (!exists("SCC")){
        SCC <- readRDS("Raw_Data/Source_Classification_Code.rds")
}

SCC_IDs <- SCC %>% filter(grepl("Coal", SCC.Level.Three) & grepl("Combustion", SCC.Level.One)) %>% 
        select(SCC)
SCC_IDs <- SCC_IDs$SCC
pm25US <- NEI %>% filter(SCC %in% SCC_IDs) %>% select(Emissions, year) %>% 
        group_by(year) %>% summarise(pm25total = sum(Emissions))
png("plot4.png")
bp <- barplot(pm25US$pm25total, names.arg  = pm25US$year, ylab = "")
fit <- lm(pm25total ~ year, pm25US)
lines(bp, fitted(fit), col = "red")
title(ylab = expression(PM[25]), main = expression(paste(PM[25], " Totals by Year for US")), 
      xlab="Year", sub = "Emissions from Coal Combustion")
dev.off()