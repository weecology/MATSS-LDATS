
#' @name build_ts_analysis_plan
#' @title Build a drake plan for TS analysis
#' @description
#' @param methods
#' @param lda_targets
#' @param datasets
#'
#' @return a drake plan
#' @export
#'
build_ts_analysis_plan <- function(methods, datasets, lda_targets){
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

