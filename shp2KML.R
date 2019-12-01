# Convert Shapefile to KML
library(rgdal)

shapefileFName <- file.choose() # Choose the SHipping Lane Shapefile
# Convert SHP to KML
shape <- readOGR(shapefileFName)
shapeWGS <- spTransform(shape, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84"))  
# Note: need to change the layer if you want something other than polygons
writeOGR(shapeWGS, dsn="shape.kml", layer = 'SpatialPolygons'  ,driver="KML")