#' @title Check data format for TS anaylysis
#'
#' @description Check whether the timename column exists & is integers
#'
#' @param data dataset to check
#'
#' @return TRUE or FALSE
#'
#' @export

check_time_data_format <- function(data)
{
  # check if timename column exists
  if (!(data$metadata$timename %in% colnames(data$covariates)))
  {
    message("The timename column does not exist.")
    return(FALSE)
  }

  # check if top-level is a data.frame
  if (length(unique(as.integer(unlist(data$covariates[,data$metadata$timename])))) != NROW(data$covariates))
  {
    message("The timename column cannot be coerced to integers without losing information.")
    return(FALSE)
  }

  return(TRUE)
}
