# libraries
library(ggplot2)
library(dplyr)
library(ggthemes)
#theme_set(theme_map())
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

# get outlines
world <- ne_countries(scale = "large", returnclass = "sf")

# get selected countries
country_list <- world %>% filter(name %in% c("United States of America"))
world$name

# rotate function (see here: https://r-spatial.github.io/sf/articles/sf3.html#affine-transformations
rot <- function(a) matrix(c(cos(a), sin(a), -sin(a), cos(a)), 2, 2)

# make a new geometry that is rotated 90 degrees (but retain original geom)
countries_rot <- country_list %>% 
  mutate(geom_rot = st_geometry(.)*rot(pi/6)) %>%
  st_drop_geometry() %>%
  rename(geometry = geom_rot) %>%
  st_set_geometry("geometry")
st_crs(countries_rot) <- 4326#st_crs(world)
country_list$geometry <- st_geometry(country_list$geometry)*rot(pi/6)
# simple plot
ggplot(data = country_list) +
  geom_sf(aes(fill=name), show.legend = F) +
  labs(subtitle = "Unrotated Countries", 
       caption = "Data source: Natural Earth Data") +
  facet_wrap(.~name, nrow = 2)

# rotated plot
ggplot(data = countries_rot) +
  # note here we can map to a *different* geometry field in the same sf dataframe
  geom_sf(aes(geometry = geometry, fill=name), show.legend = FALSE) +
  labs(subtitle = "Rotated Countries", 
       caption = "Data source: Natural Earth Data") +
  facet_wrap(.~name, nrow = 2)
