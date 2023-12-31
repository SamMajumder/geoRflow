% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geoRflow_process_dataframes.R
\name{geoRflow_process_dataframes}
\alias{geoRflow_process_dataframes}
\title{Process Data Frames Extracted from geoRflow Raster Pipeline}
\usage{
geoRflow_process_dataframes(
  temp_list,
  element_name,
  new_col_names,
  extract_index = 1
)
}
\arguments{
\item{temp_list}{A list containing the results from `geoRflow_raster_pipeline_point`.}

\item{element_name}{The name of the element within `temp_list` to be processed.}

\item{new_col_names}{A character vector of new column names to assign to the processed data frames.}

\item{extract_index}{The index of the elements to extract from list-columns or matrices (default is 1).}
}
\value{
A single data frame that combines all processed data frames from the list.
}
\description{
This function processes a list of data frames extracted from the results of the
`geoRflow_raster_pipeline_point` function. It allows for the extraction of specific elements,
flattening of list-columns, and renaming of columns within the data frames.
}
\examples{
\dontrun{
  # Assuming 'result_list' is the output from geoRflow_raster_pipeline_point
  processed_df <- geoRflow_process_dataframes(
    temp_list = result_list,
    element_name = "extracted_values",
    new_col_names = c("Value1", "Value2", "Value3"),
    extract_index = 1
  )

  # If 'result_list' contains multiple data frames with the same structure
  # and you want to combine them into one data frame with new column names
  combined_df <- geoRflow_process_dataframes(
    temp_list = result_list,
    element_name = "extracted_values",
    new_col_names = c("Elevation", "Temperature", "Precipitation")
  )

  # If you want to extract the second element from list-columns or matrices
  processed_df_with_second_element <- geoRflow_process_dataframes(
    temp_list = result_list,
    element_name = "extracted_values",
    new_col_names = c("Second_Value1", "Second_Value2", "Second_Value3"),
    extract_index = 2
  )
}

}
