#' @name run_TS
#' @title Run Changepoint Model on LDA + TimeSeries Data
#' @description Run the timeseries model from `ldats` on LDA models and time-series data.
#' @param data The dataset, in the `MATSS` format. Including covariates & metadata.
#' @param ldamodels The LDA model(s) produced by running `run_LDA` on the dataset.
#' @param formulas Defaults to ~1.
#' @param nchangepoints Vector of integers: which numbers of changepoints to try.
#' @param weights Weight samples equally or proportional to number of individuals captured. Defaults to `'proprotional'`; any other value will weight samples equally.
#'
#' @inheritParams LDATS::TS_on_LDA
#'
#' @return the changepoint model(s) resulting from running `LDATS::TS_on_LDA`.
#' @export
#'
run_TS <- function(data, ldamodels,
                   formulas = ~ 1,
                   nchangepoints = c(0:6),
                   weighting = 'proportional',
                    control = LDATS::TS_controls_list()) {
    if (!check_data_format(data)) {
        wrongFormat = simpleWarning("Incorrect data structure, see data-formats vignette")
        tryCatch(warning(wrongFormat), finally = return('Incorrect data structure'))
    }

  if (!check_time_data_format(data))
  {
    wrongFormat = simpleWarning("Timename column is cannot be made integers without losing information")
    tryCatch(warning(wrongFormat), finally = return('Incorrect data structure'))
  }

    #### Run TS models ####
  if(weighting == 'proportional') {
    weights <- LDATS::document_weights(data$abundance)
  } else {
    weights <- NULL
  }

    changepoint_models <- LDATS::TS_on_LDA(LDA_models = ldamodels,
                                    document_covariate_table = as.data.frame(data$covariates),
                                    formulas = formulas,
                                    nchangepoints = nchangepoints,
                                    weights = weights,
                                    control = LDATS::TS_controls_list(nit = 100, timename = data$metadata$timename))
}


#' @name select_TS
#' @title Run Changepoint Model on LDA + TimeSeries Data
#' @description Run the timeseries model from `ldats` on LDA models and time-series data.
#' @param changepoint_models
#' @inheritParams LDATS::TS_on_LDA
#'
#' @return best fit TS model
#' @export
#'
select_TS <- function(changepoint_models) {
  #### Check that changepoint_models is a changepoint model ####

  if (!check_cpt_format(changepoint_models))
  {
    wrongFormat = simpleWarning("Not a TS_on_LDA")
    tryCatch(warning(wrongFormat), finally = return('Incorrect input structure'))
  }
    #### Select the best changepoint ####
    selected_changepoint_model <- LDATS::select_TS(changepoint_models)
}