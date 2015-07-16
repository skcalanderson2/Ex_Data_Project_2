library(dplyr)
if (!exists("NEI")){
        NEI <- readRDS("Raw_Data/summarySCC_PM25.rds")
}
grouped_by_fips_year  <- NEI %>% group_by(fips, year) %>% filter(fips == "24510")
year_totals <- summarise(grouped_by_fips_year, PM25_Total = sum(Emissions))
png("plot2.png")
bp <- barplot(year_totals$PM25_Total, names.arg  = year_totals$year, ylab = "")
fit <- lm(PM25_Total ~ year, year_totals)
lines(bp, fitted(fit), col = "red")
title(ylab = expression(PM[25]), main = expression(paste("Baltimore ",PM[25], " Totals by Year")))
dev.off()