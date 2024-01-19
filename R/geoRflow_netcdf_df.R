#' Convert Raster Layers to Data Frames
#'
#' This function converts specified layers of a RasterBrick or SpatRaster object
#' into data frames. It checks the class of the input raster object, validates the
#' specified layer indices, and extracts each layer as a separate data frame.
#' For layer names that represent dates, it attempts to format them into a standard
#' date format. It shows progress using a progress bar.
#'
#' @param raster_object A RasterBrick or SpatRaster object.
#' @param layer_indices A numeric vector indicating the indices of the layers to be
#'        converted to data frames.
#'
#' @return A list of data frames, each corresponding to a layer in the raster object.
#'
#' @importFrom raster nlayers
#' @importFrom terra nlyr subset
#' @importFrom utils setTxtProgressBar txtProgressBar
#' @examples
#' # geoRflow_netcdf_df(raster_object, c(1, 3, 5))
#'
#' @export


geoRflow_netcdf_df <- function(raster_object, layer_indices) {

  # Determine the class of the raster object (raster or terra)
  raster_class <- class(raster_object)[1]

  # Get the total number of layers in the raster object
  if (raster_class == "RasterBrick") {
    total_layers <- raster::nlayers(raster_object)
  } else if (raster_class == "SpatRaster") {
    total_layers <- terra::nlyr(raster_object)
  } else {
    stop("Input object is neither a RasterBrick nor a SpatRaster.")
  }

  # Ensure the specified layer indices are valid
  if (max(layer_indices) > total_layers) {
    stop("Specified layer indices exceed the number of available layers.")
  }

  # Initialize a list to store data frames
  layer_dfs <- list()

  # Initialize the progress bar
  pb <- txtProgressBar(min = 0, max = length(layer_indices), style = 3)

  # Loop through each layer index
  for (i in seq_along(layer_indices)) {

    # Update the progress bar
    setTxtProgressBar(pb, i)

    # Access the specific layer
    if (raster_class == "RasterBrick") {
      layer <- raster_object[[layer_indices[i]]]
    } else {
      layer <- terra::subset(raster_object, layer_indices[i])
    }

    # Get the layer name from the raster object
    layer_name <- names(raster_object)[layer_indices[i]]

    # Remove non-numeric characters from the layer name
    date_number <- gsub("\\D", "", layer_name)

    # Check if the resulting string is a valid date number (8 digits)
    if (nchar(date_number) == 8) {
      # Insert hyphens to format the date
      date_number <- paste0(substr(date_number, 1, 4), "-",
                            substr(date_number, 5, 6), "-",
                            substr(date_number, 7, 8))
    } else {
      date_number <- layer_name
    }

    # Convert the layer to a dataframe
    layer_df <- as.data.frame(layer, xy = TRUE)

    # Add the date_number as a new column to the dataframe
    layer_df$date <- date_number

    # Store the dataframe in the list
    layer_dfs[[i]] <- layer_df
  }

  # Close the progress bar
  close(pb)

  # Return the combined dataframe
  return(layer_dfs)
}



