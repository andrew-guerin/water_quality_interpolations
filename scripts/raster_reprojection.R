
#this script demonstrates reprojection into latitude-longitude - please modify according to needs

library(tidyverse)
library(sf)
library(rnaturalearth)
library(raster) #note  - masks dplyr::select

# preparation
if(!file.exists("rasters/masked")){
  dir.create("rasters/masked")
}

#coordinate reference systems 
crs1 <- 4326 
crs2 <- "ESRI:102008"

#country outlines
us <- ne_countries(country = "united states of america", scale = "large", returnclass = "sf") 
can <- ne_countries(country = "canada", scale = "large", returnclass = "sf") 
n.amer <- rbind(us, can)

#load raw rasters

KRcalc <- raster("rasters/unmasked/calcium-KR-97648-median-10km-ZN.tif")
KRph <- raster("rasters/unmasked/ph-KR-208784-median_10km_ZN.tif")

#CREATE REPROJECTED VERSIONS (latitude-longitude)

#create template raster with desired properties (5 minute resolution)
rast_temp <- raster(xmn=-180,xmx=-45,ymn=20,ymx=89, resolution=0.0833, crs=crs1)

#reproject raw rasters into latitude-longitude
#you may get some warning messages: "Point outside of projection domain (GDAL error 1)" but there is no indication that this has caused any problems in the resulting rasters
KRcalc_latlong <- KRcalc %>% projectRaster(crs = crs1)
KRph_latlong <- KRph %>% projectRaster(crs = crs1)

#resample to get raster with equal x and y resolutions (5 minutes) using template
KRcalc_latlong_5m <- raster::resample(KRcalc_latlong,rast_temp,method="bilinear")
KRph_latlong_5m <- raster::resample(KRph_latlong,rast_temp,method="bilinear")

#mask the rasters
KRcalc_latlong_5m_masked <- mask(KRcalc_latlong_5m, n.amer)
KRph_latlong_5m_masked <- mask(KRph_latlong_5m, n.amer)

#save the rasters
writeRaster(KRcalc_latlong_5m_masked, "rasters/masked/calcium-KR-97648-median-10km-ZN_latlong.tif", overwrite=TRUE)
writeRaster(KRph_latlong_5m_masked, "rasters/masked/ph-KR-208784-median_10km_ZN_latlong.tif", overwrite=TRUE)


