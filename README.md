# water_quality_interpolations

This repository contains rasters and scripts for calcium concentration and pH data layers for Canada and the continental USA, associated with the following publication:

Rasters and other data are also available from: 

All rasters are provided in the North America Albers Equal Area projection, at 10 x 10 km resolution.
Rasters are provided 'unmasked', thus include oceanic areas, and must be masked using country outlines prior to use. Example code for masking the raw rasters is included. For reprojecting the data into other projections (eg. latitude-longitude) it is recommended to perform the reprojection on the unmasked rasters, and then mask the raster using your preferred country outlines. Example code is also provided for this operation.
Rasters were generated using zero-nugget ordinary kriging, calcium data (but not pH data) were log-transformed prior to interpolation.

The full calcium and pH databases cannot be shared, since these include data from individuals / organisations who did not explicitly agree to open sharing of their data.

Raster file names provide detail on data and interpolations used to generate the layers. 
Format: variable-interpolation method-number of data points used-measure interpolated-resolution-data transform-nugget settings.

eg. calcium-KR-97648-median-10km-LGT-ZN means
- calcium = calcium concentration (mg/l)
- KR = kriging
- 97648 = data from 97648 sites used
- median = median value for each site used
- 10km = 10 x 10km resolution
- LGT = log-transformed data used during interpolation (UT = untransformed data)
- ZN = nugget fixed at zero (if ZN not included in file name, nugget was not constrained during variogram fitting, and was selected automatically)

Contents:

Data
- Freshwater calcium concentration and pH rasters (.geotif). 
- Kriging variance rasters for above interpolations (.geotif)
- 'Relative confidence' rasters for the two variables (.geotif). These show how 'confidence' in interpolated values varies spatially in response to four component measures. See the associated publication for full details. Because of the way these rasters were generated, it is not possible to provide unmasked versions.

Code
- scripts used to generate the calcium and pH interpolations from the corresponding data. 
WARNING: the above scripts were written for the full databases, which are not provided, and would need to be modified to run on the restricted databases 
- scripts to mask the raw rasters using country outlines from the rnaturalearth package
- scripts to reproject the rasters into latitude and longitude, followed by masking with country outlines
- scripts to generate map visualisations of the interpolated layers

Other documents
- This readme file
- a pdf of the associated publication from Scientific Data.
