# Load required libraries
library(tidyverse)
library(sf)
library(ggplot2)

# Load California counties shapefile
counties <- st_read("cnty19_1.shp")

# Clean county names
counties$county <- tolower(gsub(" County", "", counties$COUNTY_NAM))

# Load and clean income data
raw_data <- read.csv("HDPulse_data_export.csv", skip = 3, stringsAsFactors = FALSE)

income_data <- raw_data %>%
  rename(
    County = 1,
    FIPS = 2,
    income = 3,
    Rank = 4
  ) %>%
  filter(grepl("County", County)) %>%
  mutate(
    income = as.numeric(gsub(",", "", income)),
    county = tolower(gsub(" County", "", County))
  )

# Merge shapefile and income data
merged_data <- left_join(counties, income_data, by = "county")

# Plot with white-to-dark red gradient
ggplot(merged_data) +
  geom_sf(aes(fill = income), color = "white", linewidth = 0.2) +
  scale_fill_gradient(
    low = "white",
    high = "#99000d",  # dark red
    na.value = "grey80",
    name = "Income ($)"
  ) +
  labs(
    title = "Median Household Income by California County (2019–2023)"
  ) +
  theme_minimal()
