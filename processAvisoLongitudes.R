# Convert Aviso Longitudes
# This script is used to load Aviso FSLE Data and Save the NetCDF file with +-180 degree longitude
#   NOTE: Aviso Products are in 0-360 for longitude
pkgTest <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}
pkgTest("tidyverse")
pkgTest("ncdf4")



avisofilename <- file.choose() 
avisopathChoice <- dirname(avisofilename)
# This imports all NetCDF files in the directory chosen
avisofilenames <- list.files(path = avisopathChoice, pattern = "*.nc", all.files = FALSE, full.names = TRUE, recursive = FALSE, ignore.case = TRUE)
avisoList <-  unlist(lapply(str_split(basename(avisofilenames),".nc"),function(x) x[1]))

#### Process Features ####
  for(i in 1:length(avisoList)){
    # open NetCDF file
    ncinFSLE <- nc_open(avisofilenames[i], write = TRUE)
    # print(ncinFSLE)
    # Convert Longitude
    lonFSLE <- ncvar_get(ncinFSLE, "lon")
    lon180 <- lonFSLE-360
    # put the 180 degree longitude into NC
    ncvar_put(ncinFSLE,"lon",lon180)
    #close the file to commit changes
    nc_close(ncinFSLE)
    rm(lonFSLE,lon180, ncinFSLE)
  }
rm(avisofilename,avisopathChoice,avisofilenames,avisoList) # clean up


