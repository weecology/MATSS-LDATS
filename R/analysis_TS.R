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
#' @return list of `ts = [the changepoint model(s)], data = data, lda = lda)` resulting from running `LDATS::TS_on_LDA`.
#' @export
#' @importFrom dplyr left_join
#'
run_TS <- function(data, ldamodels,
                   formulas = c("intercept", "time"),
                   nchangepoints = 0:6,
                   weighting = 'proportional',
                   control = list(nit = 1000,
                                  magnitude = max(1, floor(0.03 * nrow(data$abundance)))))
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
    
    ldas <- ldamodels$lda
    
    if(is.null(control$magnitude)) {
        control$magnitude = max(1, floor(0.03 * nrow(data$abundance)))
    }
    
    ts_models <- LDATS::TS_on_LDA(LDA_models = ldas,
                                  document_covariate_table = as.data.frame(data$covariates),
                                  formulas = formulas,
                                  nchangepoints = nchangepoints,
                                  timename = timename,
                                  weights = weights,
                                  control = control)
    
    ts_model_info <- make_ts_table(names(ts_models))
    
    model_info <- dplyr::left_join(ldamodels$model_info, ts_model_info, by = c("k", "seed"))
    
    
    return(list(ts = ts_models,
                lda = ldas,
                data = data,
                model_info = model_info))
}
#' 
#' #' Select TS from list
#' #'
#' #' @param ts_list list of ts, upstream
#' #'
#' #' @return list of selected ts, upstream
#' #' @export
#' #' @importFrom LDATS select_TS
#' select_TS_list <- function(ts_list) {
#'     ts <- ts_list$ts
#'     ts_select <- try(LDATS::select_TS(ts))
#'     
#'     return(list(ts = ts_select,
#'                 upstream = ts_list$upstream))
#' }
