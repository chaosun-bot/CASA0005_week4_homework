title: "wk4_homework"
name: "Chao Sun"

##install
install.packages(c("dplyr", "sf", "ggplot2", "tmap", "stringr", "here"))
library(dplyr)
library(sf)
library(tmap)
library(readr)
library(here)
library(tidyr)
library(ggplot2)

##read
gender_data <- read.csv("/Users/gb/Documents/CASA/GISS/wk4/homework/HDR23-24_Statistical_Annex_GII_Table.csv")
world_map <- st_read("/Users/gb/Documents/CASA/GISS/wk4/homework/World_Countries_(Generalized).geojson")

install.packages("countrycode")

library(remotes)
install_github('vincentarelbundock/countrycode')

##################################join
gender_inequality <- global_gender_inequality_data %>%
  select(iso3, contains("gii"))

gender_inequality_data <- gender_inequality %>%
  mutate(gii_2019_2010 = gii_2019 - gii_2010)

world_countries <- world_map %>%
  mutate(ISO3 = countrycode(ISO,"iso2c","iso3c"))

global_gender_inequality_final <- world_countries %>%
  left_join(gender_inequality_data, by = c("ISO3" = "iso3"))

#################recreate
gender

GII_1 <- global_gender_inequality_data %>%
  select(iso3, contains("gii"))

GII_2 <- GII_1 %>%
  mutate(gii_2019_2010 = gii_2019 - gii_2010)


##############join again
GII_001 <- read.csv("/Users/gb/Documents/CASA/GISS/wk4/homework/HDR23-24_Composite_indices_complete_time_series.csv")

GII_002 <- GII_001 %>%
  select(iso3, contains("gii"))

GII_003 <- GII_002 %>%
  mutate(gii_2019_2010 = gii_2019 - gii_2010)

final_global_gender_inequality <- world_countries %>%
  left_join(GII_003, by = c("ISO3" = "iso3"))

################################Data Visualisation
ggplot(final_global_gender_inequality) + 
  geom_sf(aes(fill = gii_2019_2010), 
          color = "#A9A9A9", 
          size = 0.1) + scale_fill_gradient2(low = "#FDB927", mid = "#FFFFFF", 
                                             high = "#552583", #colour
                                             midpoint = mean(final_global_gender_inequality$gii_2019_2010, na.rm = TRUE), 
                                             na.value = "#D3D3D3", 
                                             name = "GII Difference") + 
  theme_minimal() + labs(title = "Global Gender Inequality Index Difference 2010-2019") + theme(plot.title = element_text(hjust = 0.5))
