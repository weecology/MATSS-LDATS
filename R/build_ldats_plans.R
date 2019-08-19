#' #' @name build_ldats_analyses_plan
#' #' @title Build a drake plan for LDATS analysis
#' #' @description Construct the expanded Drake plan for LDA time series analyses
#' #' @param datasets the drake plan for the datasets to analyze
#' #' @inheritParams run_LDA
#' #' @inheritParams run_TS
#' #'
#' #' @return a drake plan
#' #' @export
#' #'
#' build_ldats_analyses_plan <- function(datasets, max_topics = c(3), nseeds = 4, 
#'                                       nchangepoints = c(2, 3), formulas = c("time", "intercept"), 
#'                                       lda_control = list(), ts_control = list())
#' {
#'     drake::drake_plan(
#'         lda = target(run_LDA(data, max_topics = !!max_topics, nseeds = !!nseeds, control = !!lda_control),
#'                      transform = map(data = !!rlang::syms(datasets$target))),
#'         ts = target(run_TS(data, lda, nchangepoints = !!nchangepoints, formulas = !!formulas, control = !!ts_control),
#'                     transform = map(data = !!rlang::syms(datasets$target),
#'                                     lda)),
#'         lda_results = target(collect_analyses(list(lda)),
#'                              transform = combine(lda)),
#'         ts_results = target(collect_analyses(list(ts)),
#'                             transform = combine(ts)),
#'         full_lik = target(get_full_lik(ts),
#'                           transform = map(ts)),
#'         full_lik_results = target(collect_analyses(list(full_lik)),
#'                                   transform = combine(full_lik)),
#'         pred = target(predict_abundances(full_lik),
#'                       transform = map(full_lik)),
#'         pred_results = target(collect_analyses(list(pred)),
#'                               transform = combine(pred))
#'     )
#' }

#' 
#' #' @name build_ts_analysis_plan
#' #' @title Build a drake plan for TS analysis
#' #' @description Construct the expanded Drake plan for LDA time series analyses
#' #' @param methods the drake plan for the methods to run
#' #' @param datasets the drake plan for the datasets to analyze
#' #' @param lda_targets the drake plan for the LDA targets 
#' #'
#' #' @return a drake plan
#' #' @export
#' #'
#' build_ts_analysis_plan <- function(methods, datasets, lda_targets)
#' {
#'   drake::drake_plan(
#'     analysis = target(fun(lda, data),
#'                       transform = map(fun = !!rlang::syms(methods$target),
#'                                       data = !!rlang::syms(datasets$target),
#'                                       lda = !!rlang::syms(lda_targets$target)
#'                       )
#'     ),
#'     results = target(MATSS::collect_analyses(list(analysis)),
#'                      transform = combine(analysis, .by = fun))
#'   )
#' }
#' 
#' #' @name build_ts_select_plan
#' #' @title Build a drake plan for select_TS analysis
#' #' @description Construct the expanded Drake plan for selecting changepoint models
#' #' @param methods the drake plan for the methods to run
#' #' @param cpt_targets the drake plan for the changepoint models to construct
#' #' @return a drake plan
#' #' @export
#' #'
#' build_ts_select_plan <- function(methods, cpt_targets){
#'   drake::drake_plan(
#'     analysis = target(fun(cpt),
#'                       transform = map(fun = !!rlang::syms(methods$target),
#'                                       cpt = !!rlang::syms(cpt_targets$target)                      )
#'     ),
#'     results = target(MATSS::collect_analyses(list(analysis)),
#'                      transform = combine(analysis, .by = fun))
#'   )
#' }
#' 

#' Build just an LDA plan
#'
#' @param datasets datasets
#' @param max_topics how many topics
#' @param n_topics alternatively, try each number of topics individually
#' @param nseeds how many seeds
#' @param lda_control list passed to run_LDA
#'
#' @return drake plan for just LDAs
#' @export
#'
build_lda_plan <- function(datasets, max_topics = c(3), n_topics = NULL, nseeds = 4, 
                           lda_control = list()) {
    if(is.null(n_topics)) {
        plan <- drake::drake_plan(
            lda = target(run_LDA(data,  max_topics = !!max_topics, nseeds = !!nseeds, control = !!lda_control),
                         transform = map(data = !!rlang::syms(datasets$target))),
            lda_results = target(collect_analyses(list(lda)),
                                 transform = combine(lda))
        )
    } else {
        plan <-  drake::drake_plan(
            lda = target(run_LDA(data, n_topics = ntopics, nseeds = !!nseeds, control = !!lda_control),
                         transform = cross(data = !!rlang::syms(datasets$target), ntopics = !!n_topics)),
            lda_results = target(collect_analyses(list(lda)),
                                 transform = combine(lda))
        )
    }
    return(plan)
}

#' Build just a TS plan
#'
#' @param ldamodels_names Names of LDA models
#' @param nchangepoints n cpts
#' @param formulas formulas
#' @param ts_control passed to run_TS
#'
#' @return drake plan for TS section
#' @export
#' 
build_ts_plan <- function(ldamodels_names, nchangepoints = c(2, 3), formulas = c("time", "intercept"),  ts_control = list()) {
    drake::drake_plan(
        ts = target(run_TS(ldamodels = ldamodels_name, nchangepoints = !!nchangepoints, formulas = !!formulas, control = !!ts_control),
                    transform = map(ldamodels_name = !!rlang::syms(ldamodels_names))),
        ts_results = target(collect_analyses(list(ts)),
                            transform = combine(ts)),
        model_summary = target(all_model_info(ts_result_list = ts_results))
        # ,
        # full_lik = target(get_full_lik(ts),
        #                   transform = map(ts))
        # #,
       # full_lik_results = target(collect_analyses(list(full_lik)),
        #                          transform = combine(full_lik))
        # ,
        # pred = target(predict_abundances(full_lik),
        #               transform = map(full_lik)),
        # pred_results = target(collect_analyses(list(pred)),
        #                       transform = combine(pred))
    )
}