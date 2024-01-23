# water_quality_interpolations

This repository contains rasters of freshwater calcium concentration and pH data layers for Canada and the continental USA, along with some associated scripts and data. 

Rasters and other data will also be made available via datadryad (link will be added when available). 

All rasters are provided in the North America Albers Equal Area projection (ESRI:102008), at 10 x 10 km resolution. Rasters were generated using ordinary kriging, with the nugget set to zero.

Rasters are provided 'unmasked', thus including oceanic areas, and must be masked using country outlines prior to use. Example code for masking the raw rasters is included. For reprojecting the data into other projections (eg. latitude-longitude) it is recommended to perform the reprojection on the unmasked rasters, and then mask the raster using your preferred country outlines in the appropriate projection. Example code is also provided for this operation.

The full calcium and pH databases used to generate the interpolations cannot be shared, since these include data from individuals / organisations who did not explicitly agree to open sharing of their data. However 'redacted' databases, including all shareable data, are provided. To view locations with data (shareable and non-shareable / proprietary), use the Shiny apps provided here or accessible at: 

https://andrew-guerin.shinyapps.io/Calcium_data_map/

https://andrew-guerin.shinyapps.io/pH_data_map/

Please note that these apps use large amounts of data and make take a few moments to load.

Raster file names provide detail on data and interpolations used to generate the layers. 
Format: variable-interpolation method-number of data points used-measure interpolated-resolution-nugget settings.

eg. calcium-KR-97648-median-10km-ZN means
- calcium = calcium concentration (mg/l)
- KR = kriging
- 97648 = data from 97648 sites used
- median = median value for each site used
- 10km = 10 x 10km resolution  
- ZN = nugget fixed at zero (if ZN not included in file name, nugget was not constrained during variogram fitting, and was selected automatically)

Contents:

Data
- Freshwater calcium concentration and pH rasters (.tif). 
- Kriging variance rasters for above interpolations (.tif)
- Point data for sites with shareable pH and calcium data (.csv)
- metadata documents for the calcium and pH databases (.xlsx)

Code
- scripts used to generate the calcium and pH interpolations from the corresponding data
WARNING: the above scripts were written for the full databases, which are not provided, and would need to be modified to run on other datasets 
- scripts to mask the raw rasters using country outlines from the rnaturalearth package
- scripts to reproject the rasters into latitude and longitude, followed by masking with country outlines
- Shiny apps to generate interactive maps showing locations with calcium and pH data used for the interpolations

Other documents
- This readme file
- pdfs of associated publications will be added as these become available
