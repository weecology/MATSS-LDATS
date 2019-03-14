#' @name run_TS
#' @title Run Changepoint Model on LDA + TimeSeries Data
#' @description Run the timeseries model from `ldats` on LDA models and time-series data.
#' @param data
#' @param ldamodels
#' @param formulas
#' @param nchangepoints
#' @param weights
#' @param max_topics the maximum number of topics to try (the function will
#'   test a number of topics from 2 to `max_topics`)
#' @inheritParams LDATS::TS_on_LDA
#'
#' @return the best fit model object, from running `LDATS::parLDA()`
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
#' @param changepoint_models the maximum number of topics to try (the function will
#'   test a number of topics from 2 to `max_topics`)
#' @inheritParams LDATS::TS_on_LDA
#'
#' @return best fit TS model
#' @export
#'
select_TS <- function(changepoint_models) {
    #### Select the best changepoint ####
    selected_changepoint_model <- LDATS::select_TS(changepoint_models)
}
