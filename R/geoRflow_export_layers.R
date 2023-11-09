#' Export Each Layer from a NetCDF File
#'
#' @param raster_object A RasterBrick or SpatRaster object.
#' @param layer_indices A numeric vector indicating which layers to export.
#' @param output_dir A string specifying the directory where the GeoTIFF files will be saved.
#' @return Invisible NULL.
#'
#' @examples
#' \dontrun{
#'   # Assuming 'raster_brick' is a RasterBrick object with multiple layers
#'   geoRflow_export_layers(raster_brick, layer_indices = 1:10,
#'                          output_dir = "path/to/output")
#'
#'   # If 'spat_raster' is a SpatRaster object with multiple layers
#'   geoRflow_export_layers(spat_raster, layer_indices = c(2, 5, 7),
#'                          output_dir = "path/to/different/output")
#'
#'   # To export all layers from a RasterBrick object
#'   all_layers <- 1:nlayers(raster_brick)
#'   geoRflow_export_layers(raster_brick, layer_indices = all_layers,
#'                          output_dir = "path/to/all/layers")
#'
#'   # To export layers by specifying a range
#'   geoRflow_export_layers(raster_brick, layer_indices = 3:8,
#'                          output_dir = "path/to/selected/layers")
#'
#'   # To export a single layer
#'   geoRflow_export_layers(raster_brick, layer_indices = 5,
#'                          output_dir = "path/to/single/layer")
#'
#'   # Assuming the working directory is the desired output directory
#'   geoRflow_export_layers(raster_brick, layer_indices = 1:10)
#'
#'   # Using a SpatRaster object and specifying a non-existent directory
#'   # (it will be created)
#'   geoRflow_export_layers(spat_raster, layer_indices = 1:5,
#'                          output_dir = "path/to/new/output/dir")
#'}
#'
#' @export
#'
#' @importFrom raster writeRaster
#' @importFrom terra writeRaster subset nlyr
#' @importFrom utils txtProgressBar setTxtProgressBar

geoRflow_export_layers <- function(raster_object, layer_indices, output_dir = getwd()) {

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

  # Create output directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir)
  }

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
    if (raster_class == "RasterBrick") {
      layer_name <- names(raster_object)[layer_indices[i]]
    } else {
      layer_name <- names(raster_object)[layer_indices[i]]
    }

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

    # Create a file name for the .tif file
    file_name <- file.path(output_dir, paste0(date_number, ".tif"))

    # Export the layer as a .tif file
    if (raster_class == "RasterBrick") {
      writeRaster(layer, filename = file_name, format = "GTiff", overwrite = TRUE)
    } else {
      terra::writeRaster(layer, filename = file_name,overwrite = TRUE)
    }
  }
}

