#' Spatial Join of a Data Frame with a SpatVector
#'
#' Converts a data frame into a SpatVector object, performs a spatial join with
#' another SpatVector, and then converts the result back into a data frame. This
#' function is useful for integrating non-spatial data with spatial data based on
#' geographic coordinates.
#'
#' @param df A data frame to be spatially joined.
#' @param lon The name of the column in `df` representing longitude.
#' @param lat The name of the column in `df` representing latitude.
#' @param SpatVect A SpatVector object to join with the data frame.
#'
#' @return A data frame resulting from the spatial join of `df` with `SpatVect`.
#'
#' @importFrom terra vect intersect crs
#' @examples
#' # geoRflow_join_df_vect(df, "lon", "lat", SpatVect)
#'
#' @export

geoRflow_join_df_vect <- function(df,lon,lat,SpatVect) {

  # Convert df to SpatVector

  df_vect <- terra::vect(df, geom = c(lon, lat),
                         crs = terra::crs(SpatVect))

  # Perform spatial join
  spatial_joined <- terra::intersect(df_vect, SpatVect)

  # Convert back to dataframe if needed
  as.data.frame(spatial_joined)
}
