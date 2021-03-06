#' @name build_ldats_analyses_plan
#' @title Build a drake plan for LDATS analysis
#' @description Construct the expanded Drake plan for LDA time series analyses
#' @param datasets the drake plan for the datasets to analyze
#' @inheritParams run_LDA
#' @inheritParams run_TS
#'
#' @return a drake plan
#' @export
#'
build_ldats_analyses_plan <- function(datasets, max_topics = c(3), nseeds = 4, 
                             nchangepoints = c(2, 3), formulas = c("time", "intercept"))
{
    drake::drake_plan(
        lda = target(run_LDA(data, max_topics = topic_limit, nseeds = !!nseeds),
                     transform = cross(data = !!rlang::syms(datasets$target),
                                       topic_limit = !!(max_topics))),
        lda_select = target(LDATS::select_LDA(lda, control = list(measurer = LDATS::AICc)),
                             transform = map(lda)),
        ts = target(run_TS(data, lda_select, nchangepoints = !!nchangepoints, formulas = !!formulas),
                    transform = map(data = !!rlang::syms(datasets$target),
                                    lda_select)),
        ts_select = target(try(LDATS::select_TS(ts)),
                           transform = map(ts)),
        lda_results = target(collect_analyses(list(lda_select)),
                             transform = combine(lda_select)),
        ts_results = target(collect_analyses(list(ts)),
                            transform = combine(ts)),
        ts_select_results = target(collect_analyses(list(ts_select)),
                                   transform = combine(ts_select))
    )
}


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
build_ts_select_plan <- function(methods, cpt_targets){
  drake::drake_plan(
    analysis = target(fun(cpt),
                      transform = map(fun = !!rlang::syms(methods$target),
                                      cpt = !!rlang::syms(cpt_targets$target)                      )
    ),
    results = target(MATSS::collect_analyses(list(analysis)),
                     transform = combine(analysis, .by = fun))
  )
}
