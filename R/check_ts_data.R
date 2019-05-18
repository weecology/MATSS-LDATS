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

  # check if the time column can be coerced to integers
  if (length(unique(as.integer(unlist(data$covariates[,data$metadata$timename])))) != NROW(data$covariates))
  {
    message("The timename column cannot be coerced to integers without losing information.")
    return(FALSE)
  }

  return(TRUE)
}

#' @title Check changepoint model format for TS select
#'
#' @description Check whether the changepoint model is a changepoint model
#'
#' @param cpt_model model to check
#'
#' @return TRUE or FALSE
#'
#' @export

check_cpt_format <- function(cpt_model)
{
  # check if timename column exists
  if (!(class(cpt_model) == 'TS_on_LDA'))
  {
    message("Not a changepoint model")
    return(FALSE)
  }

  return(TRUE)
}
