#' Mask a Raster with a Vector after Reprojection
#'
#' This function takes a SpatRaster and a SpatVector, reprojects the raster to a
#' specified coordinate reference system (CRS), and then masks it using the vector.
#' The function checks and sets the CRS of the SpatRaster to EPSG:4326 if it's not defined.
#' The raster is reprojected using a specified projection method. If reprojection fails,
#' the function stops with an error message.
#'
#' @param Spatraster A SpatRaster object representing the raster to be reprojected and masked.
#' @param Spatvect A SpatVector object used to mask the reprojected raster.
#' @param project_crs A character string or an object of class `CRS` representing
#'        the target CRS for reprojection.
#' @param projection_method A character string specifying the method used for reprojection.
#'        This should be one of the methods supported by the `terra::project` function.
#'
#' @return A SpatRaster object that is the result of masking the reprojected raster with the SpatVector.
#'
#' @examples
#' # Example usage
#' # geoRflow_raster_mask(raster_object, vector_object, "EPSG:3857", "bilinear")
#'
#' @export
#'
#' @importFrom terra project mask
#' @importFrom sp crs
geoRflow_raster_mask <- function(Spatraster, Spatvect, project_crs,
                                 projection_method) {
  # function body
}


geoRflow_raster_mask <- function(Spatraster, Spatvect, project_crs,
                                 projection_method) {

  # Check if Spatraster has a defined CRS, if not, set it to EPSG:4326
  if (is.na(crs(Spatraster)) || crs(Spatraster) == "") {
    crs(Spatraster) <- "EPSG:4326"
  }

  # Reproject the Spatraster to the specified CRS
  Reprojected_raster <- terra::project(Spatraster, project_crs,
                                       method = projection_method)

  # Check for successful reprojection
  if (is.na(crs(Reprojected_raster))) {
    stop("Reprojection failed, possibly due to an invalid CRS")
  }

  # Mask the reprojected raster with the Spatvect
  Masked_raster <- terra::mask(Reprojected_raster, Spatvect)


  # Return the masked raster
  return(Masked_raster)
}

