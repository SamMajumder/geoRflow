#' Process Data Frames Extracted from geoRflow Raster Pipeline
#'
#' This function processes a list of data frames extracted from the results of the
#' `geoRflow_raster_pipeline_point` function. It allows for the extraction of specific elements,
#' flattening of list-columns, and renaming of columns within the data frames.
#'
#' @param temp_list A list containing the results from `geoRflow_raster_pipeline_point`.
#' @param element_name The name of the element within `temp_list` to be processed.
#' @param new_col_names A character vector of new column names to assign to the processed data frames.
#' @param extract_index The index of the elements to extract from list-columns or matrices (default is 1).
#'
#' @return A single data frame that combines all processed data frames from the list.
#'
#' @examples
#' \dontrun{
#'   # Assuming 'result_list' is the output from geoRflow_raster_pipeline_point
#'   processed_df <- geoRflow_process_dataframes(
#'     temp_list = result_list,
#'     element_name = "extracted_values",
#'     new_col_names = c("Value1", "Value2", "Value3"),
#'     extract_index = 1
#'   )
#'
#'   # If 'result_list' contains multiple data frames with the same structure
#'   # and you want to combine them into one data frame with new column names
#'   combined_df <- geoRflow_process_dataframes(
#'     temp_list = result_list,
#'     element_name = "extracted_values",
#'     new_col_names = c("Elevation", "Temperature", "Precipitation")
#'   )
#'
#'   # If you want to extract the second element from list-columns or matrices
#'   processed_df_with_second_element <- geoRflow_process_dataframes(
#'     temp_list = result_list,
#'     element_name = "extracted_values",
#'     new_col_names = c("Second_Value1", "Second_Value2", "Second_Value3"),
#'     extract_index = 2
#'   )
#'}
#'
#' @export
geoRflow_process_dataframes <- function(temp_list, element_name, new_col_names, extract_index = 1) {
  # Check if the element exists in the list
  if (!element_name %in% names(temp_list)) {
    stop("The specified element does not exist in the provided list.")
  }

  # Extract the specified element (assumed to be a list of data frames)
  dataframes_with_values <- temp_list[[element_name]]

  # Initialize an empty list for the processed data frames
  processed_dataframes <- list()

  # Process each dataframe
  for (i in seq_along(dataframes_with_values)) {
    df <- dataframes_with_values[[i]]

    # Create a new dataframe for processed columns
    new_df <- data.frame(matrix(ncol = 0, nrow = nrow(df)))

    # Process each column
    for (col_name in names(df)) {
      if (is.data.frame(df[[col_name]]) || is.matrix(df[[col_name]])) {
        # Extract the part that doesn't contain "ID" and convert to a list
        sub_df <- df[[col_name]][, !grepl("ID", names(df[[col_name]]))]
        new_df[[col_name]] <- as.list(sub_df)
      } else {
        # Keep the column as is
        new_df[[col_name]] <- df[[col_name]]
      }
    }

    # Flatten list-columns
    list_cols <- sapply(new_df, is.list)
    if (any(list_cols)) {
      new_df[list_cols] <- lapply(new_df[list_cols], function(x) sapply(x, function(y) y[[extract_index]]))
    }

    # Rename the columns of the new dataframe
    if (length(new_col_names) == ncol(new_df)) {
      colnames(new_df) <- new_col_names
    } else {
      warning("The number of new column names does not match the number of columns in the dataframe.")
    }

    # Add the new dataframe to the list of processed dataframes
    processed_dataframes[[i]] <- new_df
  }

  # Combine all data frames in 'processed_dataframes' into one large data frame
  final_dataframe <- do.call(rbind, processed_dataframes)

  return(final_dataframe)
}

