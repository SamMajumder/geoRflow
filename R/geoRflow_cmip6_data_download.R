#' Download CMIP6 Climate Data
#'
#' This function downloads climate data from the CMIP6 dataset. It constructs a URL to
#' access the data based on user-specified parameters, retrieves an XML catalog, and
#' then downloads the files that match the specified criteria (model, timeframe,
#' ensemble, climate variable, and year range). The function checks for the existence
#' of the output directory and creates it if necessary. It handles timeouts and retries
#' for downloads.
#'
#' @param model The climate model used in the dataset.
#' @param timeframe The timeframe for which data is being requested.
#' @param ensemble The ensemble identifier for the dataset.
#' @param climate_variable The specific climate variable required.
#' @param start_year The starting year for the dataset.
#' @param end_year The ending year for the dataset.
#' @param output_folder The directory where the downloaded files will be stored.
#' @param timeout The maximum time in seconds allowed for the download of each file.
#'
#' @return The function does not return a value but downloads files to the specified output folder.
#'
#' @importFrom httr GET status_code
#' @importFrom XML xmlParse xmlGetAttr
#' @importFrom stringr str_detect
#' @importFrom utils download.file
#' @examples
#' \donttest{
#' if (interactive()) {
#'   # Example usage of geoRflow_cmip6_data_download
#'   geoRflow_cmip6_data_download("exampleModel", "timeframe", "ensemble",
#'     "climateVariable", 1990, 2000, "outputFolder", 600)
#' }
#' }
#' @export




geoRflow_cmip6_data_download <- function(model, timeframe, ensemble, climate_variable, start_year, end_year, output_folder,timeout) {
  # Ensure the output directory exists
  if (!dir.exists(output_folder)) {
    dir.create(output_folder, recursive = TRUE)
  }

  # Construct the catalog URL to access the data
  catalog_url <- paste0("https://ds.nccs.nasa.gov/thredds/catalog/AMES/NEX/GDDP-CMIP6/", model, "/", timeframe, "/", ensemble, "/", climate_variable, "/catalog.xml")

  # Retrieve the XML catalog
  ## this step also stops the function if the link is broken
  catalog <- httr::GET(catalog_url)
  if (httr::status_code(catalog) != 200) {
    stop("Failed to retrieve the catalog.")
  }

  # Parse the XML

  ### this step translates the raw content of catalog into a format that the computer can read (the result is a parsed XML document)
  doc <- XML::xmlParse(rawToChar(catalog$content))

  ### This searches the entire translated/parsed XML document and unearths //thredds:dataset. This is relevant to THREDDS
  urls <- XML::xpathSApply(doc, "//thredds:dataset", XML::xmlGetAttr, "urlPath", namespaces = c(thredds = "http://www.unidata.ucar.edu/namespaces/thredds/InvCatalog/v1.0"))

  #### All information is coerced into characters
  urls <- as.character(urls)  # Coerce to character vector

  # Filter URLs by year range
  base_url <- "https://ds.nccs.nasa.gov/thredds/fileServer/"

  ## construcing patterns for each file to be downloaded
  pattern <- paste0("_(", paste(start_year:end_year, collapse = "|"), ")\\.nc")

  filtered_urls <- urls[stringr::str_detect(urls, pattern)]

  # Download each file
  ## tries 3 times to download a file
  options(timeout = timeout)  # Increase timeout to 10 minutes
  for (url_path in filtered_urls) {
    file_url <- paste0(base_url, url_path)
    file_name <- basename(file_url)
    file_path <- file.path(output_folder, file_name)

    success <- FALSE
    attempts <- 0
    while (!success && attempts < 3) {
      try({
        download.file(file_url, file_path, mode = "wb")
        success <- TRUE
      }, silent = TRUE)
      attempts <- attempts + 1
    }
    if (success) {
      cat("Downloaded", file_name, "\n")
    } else {
      cat("Failed to download", file_name, "\n")
    }
  }
}


