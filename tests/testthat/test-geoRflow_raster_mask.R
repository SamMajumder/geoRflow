
library(here)
library(testthat)
library(terra)  # for SpatRaster, SpatVector, project, mask
library(geoRflow) # replace with the actual name of your package if different



Raster <- terra::rast(here("data","Rasters","1994-01-01_total_precipitation.tif"))


Shape <- terra::vect(here("data","Israel_Gaza",
                       "Israel_GazaBoundaries.shp"))




test_that("geoRflow_raster_mask works correctly", {
  # Create or load a sample SpatRaster object
  # This should be a raster file you have or can create for testing
  sample_raster <- Raster # Update this path

  # Create or load a sample SpatVector object
  # This should be a vector file that corresponds to a geographic area
  sample_vect <- Shape # Update this path

  # Define the target CRS and projection method for the test
  target_crs <- terra::crs(sample_vect) # Example target CRS, update as needed
  projection_method <- "bilinear" # Example projection method

  # Run the function
  result <- geoRflow_raster_mask(sample_raster, sample_vect, target_crs, projection_method)

  # Assertions
  # Check if the result is a SpatRaster
  expect_true(is(result, "SpatRaster"))

  # Check if the CRS of the result matches the target CRS
  expect_equal(crs(result), target_crs)

  # Check if the result has no NA values (if this is the expected behavior)
  # expect_false(any(is.na(values(result))), info = "Result should not contain NA values")

  # Check if the result has any NA values, which might be valid if the mask operation is supposed to set some areas to NA
  expect_true(any(is.na(values(result))), info = "Mask operation should result in some NA values")

  # Check if the result is not empty (i.e., has cells)
  expect_true(ncell(result) > 0)
  # Additional checks can include verifying spatial properties, dimensions, etc.
})

# Use testthat::test_dir() or devtools::test() to run this test script within your package environment.
