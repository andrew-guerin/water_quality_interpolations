# this script runs the interpolation for calcium concentrations
# it is the 'single thread' version of the process. Considerable speed gains are possible using multi-thread version (provided at the end, as hashed out code)
# this is for the 'best' interpolation, using zero-nugget interpolation based on log-transformed data

library(tidyverse)
library(sf)
library(gstat)
library(raster)
library(automap)

#prep file structure (if required)
if(!file.exists("rasters")){
  dir.create("rasters")
}

if(!file.exists("rasters/raw")){
  dir.create("rasters/raw")
}

#coordinate reference systems 
crs1 <- 4326 
crs2 <- "ESRI:102008"

#import calcium data, log-transform median value, convert to spatial data and project to North America Albers Equal Area Conic
calcium.sites <- read.csv("data/interpolation_data_calcium_97648.csv") %>%
  mutate(MDLG = log1p(MEDIAN)) %>%
  st_as_sf(coords = c("LONGITUDE", "LATITUDE"), crs = crs1, agr = "constant")  %>%
  st_transform(crs = crs2) 

#create interpolation grid encompassing Canada and USA
bbox <- c(
  "xmin" = -5000000,
  "ymin" = -1650000,
  "xmax" = 2990000,
  "ymax" = 4520000)

grid10km <- expand.grid(
  X = seq(from = bbox["xmin"], to = bbox["xmax"], by = 10000),
  Y = seq(from = bbox["ymin"], to = bbox["ymax"], by = 10000)) %>%
  mutate(Z = 0)  %>% 
  raster::rasterFromXYZ(crs = crs2) 

#check projections 
st_crs(calcium.sites)
st_crs(grid10km)

#fit kriging variogram - with fixed zero nugget
varKRca <- autofitVariogram(MDLG ~ 1, 
                            as(calcium.sites, "Spatial"),
                            verbose=TRUE,
                            fix.values = c(0,NA,NA))

#inspect variogram
plot(varKRca)

#interpolation model
KRcamod <- gstat(formula=MDLG~1,
                 locations=as(calcium.sites,"Spatial"),
                 model=varKRca$var_model,
                 nmax=100,
                 nmin=15)

#interpolation - using gstat::predict (more complex to parallelise, so is single-thread here for simplicity - but produces variance map)
KRgrid10km <- as(grid10km, "SpatialGrid")
KRca_interpolation <- predict(KRcamod, KRgrid10km, debug.level = -1)

#convert output to rasters and save 
#note that the main calcium raster is back-transformed to measurement scale
KRca_interpolation_raster <- raster(KRca_interpolation) %>% expm1()
KRca_interpolation_variance_raster <- raster(KRca_interpolation, layer = "var1.var") 

writeRaster(KRca_interpolation_raster, "rasters/raw/calcium-KR-97648-median-10km-LGT-ZN.tif", overwrite=TRUE)
writeRaster(KRca_interpolation_variance_raster, "rasters/raw/calcium-KR-97648-median-10km-LGT-ZN.tif", overwrite=TRUE)


#multi-thread version (considerably faster, but does not generate kriging variance map)
#takes advantage of built in multi-thread support in raster package

#library(snow)

#specify number of cores to use by setting n, or run beginCluster() without specifying - function will set n automatically
#beginCluster(n=***)
#KRca_interpolation_mt <- clusterR(grid10km, interpolate, args=list(KRcamod)) 

#output is already in raster format, but needs to be back-transformed before saving
#KRca_interpolation_mt_bt <- KRca_interpolation_mt %>% expm1()

#final raster will be identical to version produced using single-thread approach above
#writeRaster(KRca_interpolation_raster_mt_bt, "rasters/raw/calcium-KR-97648-median-10km-LGT-ZN.tif")



