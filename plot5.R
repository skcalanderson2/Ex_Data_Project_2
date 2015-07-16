library(dplyr)

if (!exists("NEI")){
        NEI <- readRDS("Raw_Data/summarySCC_PM25.rds")
}

if (!exists("SCC")){
        SCC <- readRDS("Raw_Data/Source_Classification_Code.rds")
}

SCC_IDs <- SCC %>% filter(Data.Category=="Onroad") %>% select(SCC)
SCC_IDs <- SCC_IDs$SCC

grouped_by_fips_year  <- NEI %>% filter(SCC %in% SCC_IDs) %>%  
        group_by(fips, year) %>% filter(fips == "24510")
year_totals <- summarise(grouped_by_fips_year, PM25_Total = sum(Emissions))
png("plot5.png")
bp <- barplot(year_totals$PM25_Total, names.arg  = year_totals$year, ylab = "")
fit <- lm(PM25_Total ~ year, year_totals)
lines(bp, fitted(fit), col = "red")
title(ylab = expression(PM[25]), main = expression(paste("Baltimore Motor Vehicles ",PM[25], " Totals by Year")))
dev.off()