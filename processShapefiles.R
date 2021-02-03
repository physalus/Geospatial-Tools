# Convert Shapefile to KML
library(rgdal)
library(raster) 
library(sp)
library(stringr)

# Clip all data to the extent of the HF Radar Data
# bbox = c(49.9920,30.2500,-130.3600,-115.8055)

shpfilename <- file.choose() 
shppathChoice <- dirname(shpfilename)
# This imports all GPS.csv files in the directory chosen
shpfilenames <- list.files(path = shppathChoice, pattern = "*.shp", all.files = FALSE, full.names = TRUE, recursive = FALSE, ignore.case = TRUE)
shpfilenames <- shpfilenames[!grepl(".xml", shpfilenames)]
shapeList <-  unlist(lapply(str_split(basename(shpfilenames),".shp"),function(x) x[1]))

#### Process Features ####
  for(i in 1:length(shapeList)){
    # Import Shapefile
    shape <- readOGR(shpfilenames[i])
    shapeName <- unlist(lapply(str_split(basename(shpfilenames[i]),".shp"),function(x) x[1]))
    # Convert to SpatialPointsdataframe
    shapeWGS <- spTransform(shape, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84"))  
    #plot(shapeWGS)
    # Subset to Eastern North Pacific 
    #shapeWGS <- subset(shapeWGS, Ocean == "North Pacific Ocean") %>% 
    #shapeWGS <- raster::crop(shapeWGS, extent(-130.36, -115.80, 29.5, 50.00))
    if(!is.null(shapeWGS)){
      plot(shapeWGS, main = shapeList[i])
      save(shapeWGS,file=paste0(shapeList[i],".RData"))
      # create CSV dataframe
      # tryCatch(expr={
      #   shapeDF <- as.data.frame(shapeWGS)
      #   shapeDF <- dplyr::select(shapeDF, coords.x1,coords.x2,coords.x3)
      #   colnames(shapeDF) <- c("Long","Lat","Depth")
      # }, error = function(e){
      #   shapeDF <- as.data.frame(shapeWGS)
      # }
      # )
      # write.csv(shapeDF,file=paste0(shapeList[i],".csv"))
      # # Export to KML
      writeOGR(shapeWGS, dsn=paste0(shapeList[i],".kml"), layer = 'SpatialPolygons'  ,driver="KML",overwrite_layer=TRUE)
    }
  }
rm(shpfilename,shppathChoice,shpfilenames,shapeList) # clean up


