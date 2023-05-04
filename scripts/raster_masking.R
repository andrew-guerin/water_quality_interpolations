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
us <- ne_countries(country = "united states of america", scale = "large", returnclass = "sf" ) %>% st_transform(crs = crs2) 
can <- ne_countries(country = "canada", scale = "large", returnclass = "sf" ) %>% st_transform(crs = crs2)
n.amer <- rbind(us, can)

#load raw rasters

KRcalc <- raster("rasters/raw/calcium-KR-97648-median-10km-LGT-ZN.tif")
KRcalcvar <- raster("rasters/raw/calcium-KR-97648-median-10km-LGT-ZN_variance.tif")

KRph <- raster("rasters/raw/ph-KR-208784-median_10km_UT_ZN.tif")
KRphvar <- raster("rasters/raw/ph-KR-208784-median_10km_UT_ZN_variance.tif")

#mask rasters

KRcalc_masked <- mask(KRcalc,n.amer)
KRcalcvar_masked <- mask(KRcalcvar,n.amer)

KRph_masked <- mask(KRph,n.amer)
KRphvar_masked <- mask(KRphvar,n.amer)

#save the masked rasters

writeRaster(KRcalc_masked, "rasters/masked/calcium-KR-97648-median_10km_LT_ZN_masked.tif", overwrite=TRUE)
writeRaster(KRcalcvar_masked, "rasters/masked/calcium-KR-97648-median_10km_LT_ZN_variance_masked.tif", overwrite=TRUE)

writeRaster(KRph_masked, "rasters/masked/ph-KR-208784-median_10km_UT_ZN_masked.tif", overwrite=TRUE)
writeRaster(KRphvar_masked, "rasters/masked/ph-KR-208784-median_10km_UT_ZN_variance_masked.tif", overwrite=TRUE)







