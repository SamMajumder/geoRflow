library(testthat)
library(terra)
library(sf) # For creating a sample SpatVector

# Create a sample dataframe with placeholder points within the Middle East region
places_df <- data.frame(
  place = c("Location1", "Location2", "Location3"),
  lon = c(35, 39, 44), # Longitudes roughly within the region
  lat = c(30, 33, 29)  # Latitudes roughly within the region
)

# Assume we have a SpatVector for the Köppen region encompassing these points
# For the purpose of this test, we'll create a dummy SpatVector with a large enough
# bounding box that would include the points in places_df
bbox <- st_bbox(c(xmin = 25, ymin = 15, xmax = 65, ymax = 40), crs = st_crs(4326))
Koppen_region <- vect(st_as_sfc(bbox))

# Modify the unit test to include the new dataframe and SpatVector
test_that("geoRflow_join_df_vect works correctly with Köppen region", {

  # Test with the new dataframe and Köppen region SpatVector
  result <- geoRflow_join_df_vect(places_df, "lon", "lat", Koppen_region)

  # Check if the result is a data frame
  expect_true(is.data.frame(result))

  # Check if the spatial join is performed correctly
  expect_equal(nrow(result), nrow(places_df))

})

