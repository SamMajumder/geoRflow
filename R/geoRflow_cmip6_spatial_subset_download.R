#' Download Spatial Subset of CMIP6 Climate Data
#'
#' This function downloads a spatial subset of climate data from the CMIP6 dataset based on
#' specified parameters. It constructs URLs for the NetCDF Subset Service (NCSS) and downloads
#' the files that match the specified criteria (model, timeframe, ensemble, climate variable,
#' year range, and spatial coordinates). The function checks for the existence of the output
#' directory and creates it if necessary. It handles timeouts for downloads.
#'
#' @param model The climate model used in the dataset.
#' @param timeframe The timeframe for which data is being requested.
#' @param ensemble The ensemble identifier for the dataset.
#' @param climate_variable The specific climate variable required.
#' @param start_year The starting year for the dataset.
#' @param end_year The ending year for the dataset.
#' @param north The northern boundary of the spatial subset.
#' @param south The southern boundary of the spatial subset.
#' @param east The eastern boundary of the spatial subset.
#' @param west The western boundary of the spatial subset.
#' @param output_folder The directory where the downloaded files will be stored.
#' @param timeout The maximum time in seconds allowed for the download of each file.
#'
#' @return The function does not return a value but downloads files to the specified output folder.
#'
#' @importFrom utils download.file
#' @examples
#' # Example usage of geoRflow_cmip6_spatial_subset_download
#' geoRflow_cmip6_spatial_subset_download("exampleModel", "timeframe", "ensemble",
#'   "climateVariable", 1990, 2000, 40, -40, 60, -60, "outputFolder", 600)
#'
#' @export




geoRflow_cmip6_spatial_subset_download <- function(model, timeframe, ensemble, climate_variable, start_year, end_year, north, south, east, west, output_folder, timeout) {
  # Ensure the output directory exists
  if (!dir.exists(output_folder)) {
    dir.create(output_folder, recursive = TRUE)
  }

  # Base URL for the NetCDF Subset Service (NCSS)
  ncss_base_url <- paste0("https://ds.nccs.nasa.gov/thredds/ncss/grid/AMES/NEX/GDDP-CMIP6/", model, "/", timeframe, "/", ensemble, "/", climate_variable, "/")

  # Spatial subset and time parameters
  spatial_params <- paste0("?var=", climate_variable, "&north=", north, "&south=", south, "&east=", east, "&west=", west, "&horizStride=1")
  time_params <- "&time_start=<YEAR>-01-01T00:00:00Z&time_end=<YEAR>-12-31T23:59:59Z"
  format_params <- "&accept=netcdf3&addLatLon=true"

  # Array of suffixes to try
  suffixes <- c("_gn_", "_gr_", "_gr1_")

  # Loop through years and construct the URL for each file
  for (year in start_year:end_year) {
    # Replace <YEAR> with the actual year in the time parameters
    year_time_params <- gsub("<YEAR>", year, time_params)

    for (suffix in suffixes) {
      # Construct the final URL with the current suffix
      ncss_url <- paste0(ncss_base_url, climate_variable, "_day_", model, "_", timeframe, "_", ensemble, suffix, year, ".nc", spatial_params, year_time_params, format_params)

      # Download the file
      file_name <- paste0(model, "_", climate_variable, "_", year, ".nc")
      file_path <- file.path(output_folder, file_name)
      if (download_file(ncss_url, file_path, timeout)) {
        break  # Exit the loop if download is successful
      }
    }
  }
}

download_file <- function(url, path, timeout) {
  options(timeout = timeout)
  tryCatch({
    download.file(url, path, mode = "wb")
    message("Downloaded: ", path)
    return(TRUE)
  }, error = function(e) {
    message("Failed to download: ", path, "\nError: ", e$message)
    return(FALSE)
  })
}
