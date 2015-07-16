library(dplyr)
if (!exists("NEI")){
        NEI <- readRDS("Raw_Data/summarySCC_PM25.rds")
}
grouped_by_year  <- group_by(NEI, year)
year_totals <- summarise(grouped_by_year, PM25_Total = sum(Emissions))
png("plot1.png")
bp <- barplot(year_totals$PM25_Total, names.arg  = year_totals$year, ylab = "")
fit <- lm(PM25_Total ~ year, year_totals)
lines(bp, fitted(fit), col = "red")
title(ylab = expression(PM[25]), main = expression(paste(PM[25], " Totals by Year")))
dev.off()