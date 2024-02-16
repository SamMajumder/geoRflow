
library(here)
library(terra)
library(raster)
library(testthat)
library(geoRflow)

SpatRaster <- terra::rast(here("data","Rasters","era5-2m-temperature-2021_01.nc"))

RasterBrick <- raster::brick(here("data","Rasters","era5-2m-temperature-2021_01.nc"))


test_that("geoRflow_export_layers works for RasterBrick and SpatRaster", {
  # Temporary directory for test output
  test_output_dir <- tempdir()

  # Load your netCDF file as a RasterBrick
  raster_brick <- RasterBrick

  # Load your netCDF file as a SpatRaster
  spatraster <- SpatRaster

  # Define layer indices to export
  layer_indices <- c(1, 2) # Choose indices that are valid for your netCDF file

  # Test for RasterBrick
  expect_no_warning(
    expect_no_message(
      geoRflow_export_layers(raster_brick, layer_indices, test_output_dir)
    )
  )

  # Test for SpatRaster
  expect_no_warning(
    expect_no_message(
      geoRflow_export_layers(spatraster, layer_indices, test_output_dir)
    )
  )

  # Check if the output files exist
  for (i in layer_indices) {
    # Construct expected file name
    layer_name <- gsub("\\D", "", names(raster_brick)[i])
    if (nchar(layer_name) == 8) {
      # Format the date number if it is 8 digits long
      layer_name <- paste0(substr(layer_name, 1, 4), "-",
                           substr(layer_name, 5, 6), "-",
                           substr(layer_name, 7, 8))
    }
    expected_file <- file.path(test_output_dir, paste0(layer_name, ".tif"))

    # Check for RasterBrick output
    expect_true(file.exists(expected_file))

    # Check for SpatRaster output
    expect_true(file.exists(expected_file))
  }

  # Optionally clean up the temporary directory if you don't want to keep the .tif files
  # unlink(test_output_dir, recursive = TRUE)
})

# Use testthat::test_dir() or devtools::test() to run this test script within your package environment.
