
library(testthat)
library(terra)
library(here)

# Assuming `nc_file` is the path to your NetCDF file
spatraster <- terra::rast(here("data","Rasters",
                               "era5-total_precipitation-2005_01_01.nc"))


# Test for valid layer indices
test_that("Valid layer indices return correct output", {
  layer_indices <- 1:3  # Assuming these are valid indices for your file
  output <- geoRflow_netcdf_df(spatraster, layer_indices)

  expect_true(is.list(output))
  expect_equal(length(output), length(layer_indices))
  expect_true(all(sapply(output, function(df) "data.frame" %in% class(df))))
  expect_true(all(sapply(output, function(df) "date" %in% names(df))))
})

# Test for invalid layer indices
test_that("Invalid layer indices throw an error", {
  invalid_indices <- c(999, 1000) # Indices that don't exist in the file
  expect_error(geoRflow_netcdf_df(spatraster, invalid_indices))
})


