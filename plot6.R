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
        group_by(fips, year) %>% filter(fips == "24510" | fips == "06037")
year_totals <- summarise(grouped_by_fips_year, PM25_Total = sum(Emissions))
year_totals$year <- factor(year_totals$year)
year_totals <- mutate(year_totals, City = ifelse(fips=="24510", "Baltimore", "LA"))
png("plot6.png")
g <- ggplot(year_totals, aes(year, log(PM25_Total))) + geom_bar(stat = "identity")
g + facet_grid(City ~ .) + ylab(expression(paste("Log(",PM[25],")"))) + xlab("Year") +
        ggtitle(expression(paste("Baltimore & LA Motor Vehicle ",PM[25], " Totals by Year")))
dev.off()