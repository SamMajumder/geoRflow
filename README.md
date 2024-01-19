![geoRflow hex sticker](geoRflow_hex_sticker.png)

# geoRflow
geoRflow is an R package designed to facilitate automated workflows for processing and analyzing geospatial data. With a focus on simplicity and efficiency, geoRflow provides a suite of functions to handle various geospatial data operations such as loading data, extracting raster layers, resampling, reprojecting, extracting point values, and performing data validation.

## Installation
You can install the development version of geoRflow from GitHub with:
```{r}
# install.packages("devtools")
devtools::install_github("SamMajumder/geoRflow")
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

#### Examples
##### Basic Usage (No Optional Arguments):
This is the simplest form of calling the function, assuming that the mandatory arguments are provided.

```{r}
geoRflow_raster_pipeline_point(inputs = list_of_rasters)
```

#### Specifying the Data Frame:
Adding the data frame that contains the point data.

```{r}
geoRflow_raster_pipeline_point(inputs = list_of_rasters, df = my_data_frame)
```
#### Specifying Latitude and Longitude Columns:
Including the names of the columns that contain the latitude and longitude values.

```{r}
geoRflow_raster_pipeline_point(inputs = list_of_rasters,
                               df = my_data_frame,
                               lat_col = "latitude",
                               lon_col = "longitude")
```

#### Including a Split ID:
Adding a column name to split the data frame for processing.

```{r}
geoRflow_raster_pipeline_point(inputs = list_of_rasters,
                               df = my_data_frame,
                               lat_col = "latitude",
                               lon_col = "longitude",
                               split_id = "region_id")

```

#### Using Search Strings for Filtering:
Although not currently used in the function, we can include it for completeness.

```{r}
geoRflow_raster_pipeline_point(inputs = list_of_rasters,
                               df = my_data_frame,
                               lat_col = "latitude",
                               lon_col = "longitude",
                               split_id = "region_id",
                               search_strings = c("string1", "string2"))

```

#### Changing the Method for Raster Processing:
Switching from the default "stars" method to "terra".

```{r}
geoRflow_raster_pipeline_point(inputs = list_of_rasters,
                               df = my_data_frame,
                               lat_col = "latitude",
                               lon_col = "longitude",
                               split_id = "region_id",
                               method = "terra")

```
#### Adjusting the Resample Factor:
Specifying a numeric value to rescale the raster data.
```{r}
geoRflow_raster_pipeline_point(inputs = list_of_rasters,
                               df = my_data_frame,
                               lat_col = "latitude",
                               lon_col = "longitude",
                               split_id = "region_id",
                               resample_factor = 0.5)

```
#### Changing the Coordinate Reference System (CRS):
Setting a different CRS for the raster data.

```{r}
geoRflow_raster_pipeline_point(inputs = list_of_rasters,
                               df = my_data_frame,
                               lat_col = "latitude",
                               lon_col = "longitude",
                               split_id = "region_id",
                               crs = st_crs(3857))

```

#### Modifying the Resampling Method:
Changing the resampling method when altering raster resolution.

```{r}
geoRflow_raster_pipeline_point(inputs = list_of_rasters,
                               df = my_data_frame,
                               lat_col = "latitude",
                               lon_col = "longitude",
                               split_id = "region_id",
                               method_resampling = "nearest")

```

#### Setting a No Data Value:
Defining a different value for missing data in the raster.

```{r}
geoRflow_raster_pipeline_point(inputs = list_of_rasters,
                               df = my_data_frame,
                               lat_col = "latitude",
                               lon_col = "longitude",
                               split_id = "region_id",
                               no_data_value = -999)

```

#### Cropping with a Reference Shape:
Providing a file path or spatial object for cropping the raster.

```{r}
geoRflow_raster_pipeline_point(inputs = list_of_rasters,
                               df = my_data_frame,
                               lat_col = "latitude",
                               lon_col = "longitude",
                               split_id = "region_id",
                               reference_shape = "path/to/shapefile.shp")

```

#### Disabling Bilinear Interpolation:
Turning off bilinear interpolation when extracting raster values.

```{r}
geoRflow_raster_pipeline_point(inputs = list_of_rasters,
                               df = my_data_frame,
                               lat_col = "latitude",
                               lon_col = "longitude",
                               split_id = "region_id",
                               use_bilinear = FALSE)

```

### 2) geoRflow_export_layers

#### Description
The geoRflow_export_layers function is designed to streamline the process of exporting individual layers from a NetCDF file. It accepts a raster object, either a RasterBrick or SpatRaster, and exports each specified layer as a separate GeoTIFF file.

#### Usage
```{r}

geoRflow_export_layers(raster_object, layer_indices, output_dir = getwd())

```

##### Arguments
`raster_object:` A RasterBrick or SpatRaster object representing the raster data.
`layer_indices:` A numeric vector specifying the indices of the layers to be exported.
`output_dir:` A string representing the directory path where the GeoTIFF files will be saved. If not specified, the current working directory is used by default.

##### Examples
Here are some examples of how to use the geoRflow_export_layers function:

###### Assuming 'raster_brick' is a RasterBrick object with multiple layers

```{r}
geoRflow_export_layers(raster_brick, layer_indices = 1:10, output_dir = "path/to/output")

```

###### If 'spat_raster' is a SpatRaster object with multiple layers

```{r}
geoRflow_export_layers(spat_raster, layer_indices = c(2, 5, 7), output_dir = "path/to/different/output")
```

###### To export all layers from a RasterBrick object

```{r}
all_layers <- 1:nlayers(raster_brick)
geoRflow_export_layers(raster_brick, layer_indices = all_layers, output_dir = "path/to/all/layers")
```

###### To export layers by specifying a range
```{r}
geoRflow_export_layers(raster_brick, layer_indices = 3:8, output_dir = "path/to/selected/layers")
```

###### To export a single layer
```{r}
geoRflow_export_layers(raster_brick, layer_indices = 5, output_dir = "path/to/single/layer")
```

###### Assuming the working directory is the desired output directory
```{r}
geoRflow_export_layers(raster_brick, layer_indices = 1:10)
```

###### Using a SpatRaster object and specifying a non-existent directory (it will be created)
```{r}
geoRflow_export_layers(spat_raster, layer_indices = 1:5, output_dir = "path/to/new/output/dir")
```

### 3) geoRflow_process_dataframes
The geoRflow_process_dataframes function is designed to streamline the process of extracting and processing data frames from a list structure, which is typically the output of the geoRflow_raster_pipeline_point function. This function allows users to specify the element to extract, apply transformations, and combine the results into a single data frame.

#### Description
This function iterates over a list of data frames, extracting specified elements, and optionally renaming columns. It is particularly useful when dealing with the output of geospatial data processing workflows where the results are stored in complex list structures.

#### Usage
```{r}
geoRflow_process_dataframes(temp_list, element_name, new_col_names, extract_index = 1)
```

#### Arguments
`temp_list:` A list containing data frames from which to extract elements.
`element_name:` The name of the element within the list to be processed.
`new_col_names:` A vector of new column names to be assigned to the processed data frames.
`extract_index:` The index of the element to extract from each list-column (default is 1).

### Examples
```{r}
# Assuming 'result_list' is the output from geoRflow_raster_pipeline_point
# and contains an element named 'extracted_values' which is a list of data frames

# Process the 'extracted_values' element with new column names
processed_df <- geoRflow_process_dataframes(
  temp_list = result_list,
  element_name = "extracted_values",
  new_col_names = c("Latitude", "Longitude", "Elevation")
)
```

### Note
Ensure that the new_col_names provided matches the number of columns in the data frames being processed. If they do not match, a warning will be issued.


# 4) geoRflow_join_df_vect

## Description
This function performs a spatial join between a data frame and a SpatVector object. It first converts the data frame into a SpatVector using specified longitude and latitude columns, then performs a spatial join with another SpatVector object. The result of this spatial join is converted back into a data frame. This functionality is particularly useful for integrating non-spatial data with spatial data using geographic coordinates.

## Usage
```{r}
# Assume df is your data frame with columns 'lon' and 'lat'
# Assume SpatVect is a SpatVector object

# Perform the spatial join
joined_df <- geoRflow_join_df_vect(df, "lon", "lat", SpatVect)

# View the result
print(joined_df)

```

## Arguments
- `df`: The data frame to be spatially joined.
- `lon`: The name of the column in `df` representing longitude.
- `lat`: The name of the column in `df` representing latitude.
- `SpatVect`: A SpatVector object to join with the data frame.

## Return
A data frame resulting from the spatial join of `df` with `SpatVect`.

## Example

```{r}
# Sample data frame with longitude and latitude columns
locations_df <- data.frame(
  id = 1:5,
  longitude = c(-0.1257, -0.1425, -0.1189, -0.1353, -0.1561),
  latitude = c(51.5085, 51.5074, 51.5115, 51.5166, 51.5098)
)

# Sample SpatVector object (pseudo code, replace with actual spatial data)
# Here, 'regions_vect' should be an actual SpatVector representing regions
# regions_vect <- read_spatvector("path/to/regions_shapefile.shp")

# Perform the spatial join
joined_df <- geoRflow_join_df_vect(locations_df, "longitude", "latitude", regions_vect)

# View the result
print(joined_df)

```
# 4) geoRflow_netcdf_df

## Description
This function is designed to convert specified layers of a RasterBrick or SpatRaster object into separate data frames. It validates the layer indices, accesses each layer individually, and converts them into data frames. Layers representing dates are formatted into a standard date format. The function displays progress using a progress bar, providing a user-friendly interface for handling large raster datasets.

## Arguments
- `raster_object`: A RasterBrick or SpatRaster object to be processed.
- `layer_indices`: Numeric vector specifying the indices of the layers to convert to data frames.

## Return
A list of data frames, with each data frame corresponding to a layer in the raster object.

## Usage

```{r}
# Assume raster_brick is a RasterBrick object with multiple layers
# This could be a raster of temperature data over several months or years

# Load necessary libraries
library(raster)
library(terra)

# Sample code to read a raster file (replace with actual file path)
# raster_brick <- brick("path/to/multi_layer_raster.tif")

# Define the indices of the layers you want to extract
# For example, extracting the first, third, and fifth layers
layer_indices_to_extract <- c(1, 3, 5)

# Use the geoRflow_netcdf_df function to convert these layers to data frames
list_of_dataframes <- geoRflow_netcdf_df(raster_brick, layer_indices_to_extract)

# You can now work with each data frame separately
# For example, accessing the first data frame in the list
first_df <- list_of_dataframes[[1]]
print(first_df)

# Similarly, access other data frames as needed

```

# 5) geoRflow_process_dataframes

## Description
This function is tailored for processing a list of data frames extracted from the results of the `geoRflow_raster_pipeline_point` function. It enables the extraction of specific elements, flattening of list-columns, and renaming of columns within the data frames. The function is particularly useful for handling complex list structures commonly encountered in geospatial data processing workflows.

## Arguments
- `temp_list`: A list containing results from `geoRflow_raster_pipeline_point`.
- `element_name`: Name of the element within `temp_list` to be processed.
- `new_col_names`: Character vector of new column names for the processed data frames.
- `extract_index`: Index of the elements to extract from list-columns or matrices (default is 1).

## Return
A single data frame combining all processed data frames from the list.

## Usage

```{r}
# Sample output list from a previous geospatial data processing function
# This is a simulated structure. Replace with your actual list structure.
result_list <- list(
  data_frame_1 = data.frame(
    ID = 1:3,
    extracted_values = I(list(
      data.frame(Value1 = c(101, 102, 103), Value2 = c(201, 202, 203))
    ))
  ),
  data_frame_2 = data.frame(
    ID = 4:6,
    extracted_values = I(list(
      data.frame(Value1 = c(104, 105, 106), Value2 = c(204, 205, 206))
    ))
  )
  # Assume more data frames with a similar structure
)

# Using geoRflow_process_dataframes to process and combine these data frames
# Assume we want to extract the 'extracted_values' element and rename its columns
processed_df <- geoRflow_process_dataframes(
  temp_list = result_list,
  element_name = "extracted_values",
  new_col_names = c("New_Value1", "New_Value2"),
  extract_index = 1
)

# View the combined processed data frame
print(processed_df)

```


# 6) geoRflow_raster_mask

## Description
The `geoRflow_raster_mask` function is designed to reproject a SpatRaster to a specified coordinate reference system (CRS) and then mask it using a SpatVector. The function checks and sets the CRS of the SpatRaster to EPSG:4326 if it's not defined. The raster is reprojected using the specified projection method, and if the reprojection fails, an error message is generated.

## Arguments
- `Spatraster`: A SpatRaster object representing the raster to be reprojected and masked.
- `Spatvect`: A SpatVector object used to mask the reprojected raster.
- `project_crs`: Target CRS for reprojection, either as a character string or a `CRS` object.
- `projection_method`: Method used for reprojection, one of the methods supported by `terra::project`.

## Return
A SpatRaster object that is the result of masking the reprojected raster with the SpatVector.

```{r}
# Load necessary library
library(terra)

# Sample code to read a SpatRaster file (replace with actual file path)
# raster_data <- rast("path/to/your/raster_file.tif")

# Sample code to read a SpatVector file (replace with actual file path)
# vector_mask <- vect("path/to/your/vector_file.shp")

# Define the target CRS and the projection method
target_crs <- "EPSG:3857"  # Example: Web Mercator projection
projection_method <- "bilinear"

# Using the geoRflow_raster_mask function to reproject and mask the raster
masked_raster <- geoRflow_raster_mask(raster_data, vector_mask, target_crs, projection_method)

# The result is a masked SpatRaster object focused on the area defined by the vector
# You can now proceed with further analysis or visualization of this masked raster

```


# 7) geoRflow_cmip6_data_download

## Description
This function facilitates the download of climate data from the CMIP6 dataset. It constructs a URL to access the data based on user-specified parameters, retrieves an XML catalog, and downloads the files that match the specified criteria. It ensures the existence of the output directory, handles timeouts, and retries for downloads.

## Arguments
- `model`: Climate model used in the dataset.
- `timeframe`: Timeframe for which data is being requested.
- `ensemble`: Ensemble identifier for the dataset.
- `climate_variable`: Specific climate variable required.
- `start_year`: Starting year for the dataset.
- `end_year`: Ending year for the dataset.
- `output_folder`: Directory where downloaded files will be stored.
- `timeout`: Maximum time in seconds allowed for the download of each file.

## Usage

```{r}

# Example usage of geoRflow_cmip6_data_download

# Define parameters for the data download
model <- "GFDL-ESM4"  # Example climate model
timeframe <- "historical"  # Example timeframe
ensemble <- "r1i1p1f1"  # Example ensemble identifier
climate_variable <- "tas"  # Example variable (e.g., air temperature)
start_year <- 1990  # Start year for the dataset
end_year <- 2000  # End year for the dataset
output_folder <- "path/to/your/download/folder"  # Directory for storing downloaded files
timeout <- 600  # Timeout in seconds

# Call the function with the specified parameters
# Note: Replace "path/to/your/download/folder" with an actual directory path
geoRflow_cmip6_data_download(model, timeframe, ensemble, climate_variable,
                             start_year, end_year, output_folder, timeout)

# After execution, the specified climate data files will be downloaded
# to the 'output_folder'. You can then use these files for your analysis.

```


# 8) geoRflow_cmip6_spatial_subset_download

## Description
This function downloads a spatial subset of climate data from the CMIP6 dataset based on specified parameters. It uses the NetCDF Subset Service (NCSS) to construct URLs and download files matching criteria such as model, timeframe, ensemble, climate variable, year range, and spatial coordinates. The function checks for the existence of the output directory and creates it if necessary. It handles timeouts for downloads.

## Arguments
- `model`: The climate model used in the dataset.
- `timeframe`: The timeframe for which data is being requested.
- `ensemble`: The ensemble identifier for the dataset.
- `climate_variable`: The specific climate variable required.
- `start_year`: The starting year for the dataset.
- `end_year`: The ending year for the dataset.
- `north`: The northern boundary of the spatial subset.
- `south`: The southern boundary of the spatial subset.
- `east`: The eastern boundary of the spatial subset.
- `west`: The western boundary of the spatial subset.
- `output_folder`: The directory where the downloaded files will be stored.
- `timeout`: The maximum time in seconds allowed for the download of each file.

## Usage

```{r}
# Example usage of geoRflow_cmip6_spatial_subset_download

# Define parameters for the data download
model <- "CanESM5"  # Example climate model
timeframe <- "ssp585"  # Example timeframe (e.g., a specific scenario)
ensemble <- "r1i1p1f1"  # Example ensemble identifier
climate_variable <- "pr"  # Example variable (e.g., precipitation)
start_year <- 2021  # Start year for the dataset
end_year <- 2040  # End year for the dataset

# Define spatial boundaries (north, south, east, west) in decimal degrees
north <- 60  # Northern boundary
south <- 40  # Southern boundary
east <- -60  # Eastern boundary
west <- -80  # Western boundary

output_folder <- "path/to/your/spatial_data"  # Directory for storing downloaded files
timeout <- 1200  # Timeout in seconds (e.g., 20 minutes)

# Call the function with the specified parameters
# Note: Replace "path/to/your/spatial_data" with an actual directory path
geoRflow_cmip6_spatial_subset_download(model, timeframe, ensemble, climate_variable,
                                       start_year, end_year, north, south, east, west,
                                       output_folder, timeout)

# After execution, the climate data files for the specified spatial subset and time range
# will be downloaded to the 'output_folder'. These files can then be used for spatial analysis.


```


## License
geoRflow is released under the MIT License.

## 👤 Maintainer:

Sambadi Majumder, PhD
sambadimajumder@gmail.com
