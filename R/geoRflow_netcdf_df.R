#' Convert Specified Layers of a SpatRaster Object to a List of Data Frames
#'
#' This function takes a `SpatRaster` object and a set of layer indices,
#' then converts each specified layer into a data frame with xy coordinates
#' and an additional date column derived from the layer names.
#'
#' @param spatraster A `SpatRaster` object from the `terra` package.
#' @param layer_indices A numeric vector indicating the indices of layers
#'        in the `SpatRaster` object that should be converted to data frames.
#'
#' @details
#' The function first checks if the specified layer indices are valid for
#' the given `SpatRaster` object. It then iterates over these indices,
#' extracts each layer, and converts it to a data frame. If the layer name
#' can be interpreted as a date (in the format of eight consecutive digits),
#' it is formatted and added as a new column to the data frame.
#'
#' @return A list of data frames, each corresponding to a layer in the
#'         `SpatRaster` object as specified by `layer_indices`. Each data
#'         frame contains xy coordinates and a date column if applicable.
#'
#' @examples
#' \donttest{
#' library(terra)
#' # Create an example SpatRaster object
#' r <- rast(system.file("ex/logo.tif", package="terra"))
#' # Specify the layer indices to convert
#' layer_indices <- 1:3
#'
#' # Convert the specified layers to data frames
#' layer_dfs <- geoRflow_netcdf_df(r, layer_indices)
#' # Explore the resulting list of data frames
#' str(layer_dfs)
#' }
#'
#' @importFrom terra nlyr
#' @importFrom terra subset
#' @importFrom terra as.data.frame
#' @importFrom terra names
#' @export


geoRflow_netcdf_df <- function(spatraster, layer_indices) {


  # Get the total number of layers in the SpatRaster object
  total_layers <- terra::nlyr(spatraster)

  # Ensure the specified layer indices are valid
  if (any(layer_indices > total_layers)) {
    stop("Specified layer indices exceed the number of available layers.")
  }

  # Initialize a list to store data frames
  layer_dfs <- vector("list", length(layer_indices))

  # Loop through each layer index
  for (i in seq_along(layer_indices)) {
    # Access the specific layer
    layer <- terra::subset(spatraster, layer_indices[i])

    # Get the layer name from the SpatRaster object
    layer_name <- terra::names(layer)

    # Remove non-numeric characters from the layer name to get a date number
    date_number <- gsub("\\D", "", layer_name)

    # Format the date number if it's 8 digits long
    if (nchar(date_number) == 8) {
      date_number <- paste0(substr(date_number, 1, 4), "-",
                            substr(date_number, 5, 6), "-",
                            substr(date_number, 7, 8))
    }

    # Convert the layer to a dataframe with xy coordinates
    layer_df <- terra::as.data.frame(layer, xy = TRUE)

    # Add the date_number as a new column to the dataframe
    layer_df$date <- date_number

    # Store the dataframe in the list
    layer_dfs[[i]] <- layer_df
  }

  # Return the list of dataframes
  return(layer_dfs)
}
