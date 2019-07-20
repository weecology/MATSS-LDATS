#' @name run_TS
#' @title Run Changepoint Model on LDA + TimeSeries Data
#' @description Run the timeseries model from `ldats` on LDA models and time-series data.
#' @param data The dataset, in the `MATSS` format. Including covariates & metadata.
#' @param ldamodels The LDA model(s) produced by running `run_LDA` on the dataset.
#' @param formulas Defaults to NULL. If nothing supplied, ~timename. If supplied, uses that.
#' @param nchangepoints Vector of integers: which numbers of changepoints to try.
#' @param weighting Weight samples equally or proportional to number of individuals captured. Defaults to `'proprotional'`; any other value will weight samples equally.
#'
#' @inheritParams LDATS::TS_on_LDA
#'
#' @return the changepoint model(s) resulting from running `LDATS::TS_on_LDA`.
#' @export
#'
run_TS <- function(data, ldamodels,
                   formulas = c("intercept", "time"),
                   nchangepoints = 0:6,
                   weighting = 'proportional',
                   control = list())
{
    if (!MATSS::check_data_format(data)) {
        wrongFormat = simpleWarning("Incorrect data structure, see data-formats vignette")
        tryCatch(warning(wrongFormat), finally = return('Incorrect data structure'))
    }

    if (!check_time_data_format(data))
    {
        wrongFormat = simpleWarning("Timename column is cannot be made integers without losing information")
        tryCatch(warning(wrongFormat), finally = return('Incorrect data structure'))
    }

    ## Get formulas
    if(("time" %in% formulas) && ("intercept" %in% formulas)) {
        form <- as.formula(paste0("~ ", data$metadata$timename))
        form2 <- ~1
        formulas <- c(form, form2)
    } else {
        formulas <- formulas
    }

    timename <- data$metadata$timename

    #### Run TS models ####
    if (tolower(weighting) == 'proportional') {
        weights <- LDATS::document_weights(data$abundance)
    } else {
        weights <- NULL
    }

    LDATS::TS_on_LDA(LDA_models = ldamodels,
                     document_covariate_table = as.data.frame(data$covariates),
                     formulas = formulas,
                     nchangepoints = nchangepoints,
                     timename = timename,
                     weights = weights,
                     control = list(nit = 1000, magnitude = max(1, floor(0.03 * nrow(data$abundance)))))
}
