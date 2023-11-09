# geoRflow
geoRflow is an R package designed to facilitate automated workflows for processing and analyzing geospatial data. With a focus on simplicity and efficiency, geoRflow provides a suite of functions to handle various geospatial data operations such as loading data, extracting raster layers, resampling, reprojecting, extracting point values, and performing data validation.

## Installation
You can install the development version of geoRflow from GitHub with:
```{r}
# install.packages("devtools")
devtools::install_github("your-username/geoRflow")
```

## Functions 

### 1) geoRflow_raster_pipeline_point

#### Description
This function processes a list of geospatial raster data files or objects, resamples them, reprojects them to a specified CRS, and extracts values at specified point locations from a data frame.

#### Usage
```r
geoRflow_raster_pipeline_point(
  inputs,
  df = NULL,
  lat_col = NULL,
  lon_col = NULL,
  split_id = NULL,
  search_strings = NULL,
  method = "stars",
  resample_factor = NULL,
  crs = st_crs(4326),
  method_resampling = "bilinear",
  no_data_value = -9999,
  reference_shape = NULL,
  use_bilinear = TRUE
)
```

#### Arguments
- `inputs`: A list of file paths or raster objects to be processed.
- `df`: A data frame containing point data (default is NULL).
- `lat_col`: The name of the column in 'df' that contains latitude values (default is NULL).
- `lon_col`: The name of the column in 'df' that contains longitude values (default is NULL).
- `split_id`: The name of the column in 'df' to split the data frame on for processing (default is NULL).
- `search_strings`: A list of strings for filtering files (default is NULL, not currently used in function).
- `method`: The method for loading and processing raster data, either "stars" or "terra" (default is "stars").
- `resample_factor`: A numeric value to rescale the raster data (default is NULL).
- `crs`: The coordinate reference system to be used for the raster data (default is st_crs(4326)).
- `method_resampling`: The method used for resampling when changing raster resolution (default is "bilinear").
- `no_data_value`: The value to be used for missing data in the raster (default is -9999).
- `reference_shape`: A file path or spatial object for cropping the raster (default is NULL).
- `use_bilinear`: Logical, whether to use bilinear interpolation when extracting raster values (default is TRUE).


## License
geoRflow is released under the MIT License.
