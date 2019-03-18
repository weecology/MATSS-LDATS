#' @name build_ts_analysis_plan
#' @title Build a drake plan for TS analysis
#' @description Construct the expanded Drake plan for LDA time series analyses
#' @param methods the drake plan for the methods to run
#' @param datasets the drake plan for the datasets to analyze
#' @param lda_targets the drake plan for the LDA targets 
#'
#' @return a drake plan
#' @export
#'
build_ts_analysis_plan <- function(methods, datasets, lda_targets)
{
  lda_targets <- lda_targets[1:nrow(lda_targets) - 1, ]
  drake::drake_plan(
    analysis = target(fun(lda, data),
                      transform = map(fun = !!rlang::syms(methods$target),
                                      data = !!rlang::syms(datasets$target),
                                      lda = !!rlang::syms(lda_targets$target)
                      )
    ),
    results = target(MATSS::collect_analyses(list(analysis)),
                     transform = combine(analysis, .by = fun))
  )
}

#' @name build_ts_select_plan
#' @title Build a drake plan for select_TS analysis
#' @description Construct the expanded Drake plan for selecting changepoint models
#' @param methods the drake plan for the methods to run
#' @param cpt_targets the drake plan for the changepoint models to construct
#' @return a drake plan
#' @export
#'
build_ts_select_plan <- function(methods, cpt_targets)
{
  cpt_targets <- cpt_targets[1:nrow(cpt_targets) - 1, ]
  drake::drake_plan(
    analysis = target(fun(cpt),
                      transform = map(fun = !!rlang::syms(methods$target),
                                      cpt = !!rlang::syms(cpt_targets$target)                      )
    ),
    results = target(MATSS::collect_analyses(list(analysis)),
                     transform = combine(analysis, .by = fun))
  )
}

