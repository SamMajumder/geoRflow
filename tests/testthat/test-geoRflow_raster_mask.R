
library(here)
library(testthat)
library(terra)

# Load your new data
Rasters <- terra::rast(here("data", "Rasters", "Total_daily_precipitation.nc"))
Israel_Gaza <- terra::vect(here("data", "Israel_Gaza", "Israel_GazaBoundaries.shp"))

# Load your package (assuming the package is called "geoRflow")
devtools::load_all()

test_that("geoRflow_raster_mask function works correctly", {
  # Test the geoRflow_raster_mask function with the new data
  masked_raster <- geoRflow_raster_mask(Rasters, Israel_Gaza, "EPSG:3857", "bilinear")

  # Assertion 1: Check if the result is a SpatRaster object
  expect_true("SpatRaster" %in% class(masked_raster),
              info = "The result should be a SpatRaster object")

  # Assertion 2: Check if the CRS of the result matches the target CRS
  expect_equal(terra::crs(masked_raster), "EPSG:3857",
               info = "The CRS of the result should match the target CRS 'EPSG:3857'")

  # Assertion 3: Check if the number of rows and columns in the result match the input raster
  expect_equal(terra::nrow(masked_raster), terra::nrow(Rasters),
               info = "Number of rows in the result should match the input raster")
  expect_equal(terra::ncol(masked_raster), terra::ncol(Rasters),
               info = "Number of columns in the result should match the input raster")

  # Assertion 4: Check if the extent of the result matches the target extent
  expect_equal(terra::ext(masked_raster), terra::ext(Rasters),
               info = "The extent of the result should match the target extent")

  # Assertion 5: Check if the values in the masked raster are within a valid range
  expect_true(all(terra::values(masked_raster) >= 0 & terra::values(masked_raster) <= 100),
              info = "Values in the masked raster should be within the range [0, 100]")

  # Assertion 6: Check if the result has the same number of layers as the input raster
  expect_equal(terra::nlyr(masked_raster), terra::nlyr(Rasters),
               info = "Number of layers in the result should match the input raster")
})
