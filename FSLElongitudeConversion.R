# This script is used to load Aviso FSLE Data and Save the NetCDF file with +-180 degree longitude
#NOTE: Aviso Products are in 0-360 for longitude

# open NetCDF file
ncnameFSLE <- file.choose()
ncinFSLE <- nc_open(ncnameFSLE, write = TRUE)
print(ncinFSLE)

lonFSLE <- ncvar_get(ncinFSLE, "lon")
nlonFSLE <- dim(lonFSLE)
latFSLE <- ncvar_get(ncinFSLE, "lat", verbose = F)
nlatFSLE <- dim(latFSLE)
lon180 <- lonFSLE-360
# put the 18 degree longitude into NC
ncvar_put(ncinFSLE,"lon",lon180)
#close the file to commit changes
nc_close(ncinFSLE)
