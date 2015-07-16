library(dplyr)
library(ggplot2)

if (!exists("NEI")){
        NEI <- readRDS("Raw_Data/summarySCC_PM25.rds")
}
grouped_by_fips_year  <- NEI %>% group_by(year, fips, type) %>% filter(fips == "24510")
year_totals <- summarise(grouped_by_fips_year, PM25_Total = sum(Emissions))
year_totals$year <- factor(year_totals$year)
png("plot3.png")
g <- ggplot(year_totals, aes(year, PM25_Total)) + geom_bar(stat = "identity")
g + facet_grid(type ~ ., scales = "free") + ylab(expression(PM[25])) + xlab("Year") +
        ggtitle(expression(paste("Baltimore ",PM[25], " Totals by Year by Type")))
dev.off()