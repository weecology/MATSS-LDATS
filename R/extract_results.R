#' #' Extract results from LDA results
#' #' @param lda_result an LDA model
#' #' @param variable_name "ntopics", "ntimeseries", or "ntimesteps"
#' #' @return value of that variable
#' #' @export
#' extract_lda_variable <- function(lda_result, variable_name) {
#'     if(variable_name == "ntopics") {
#'         return(lda_result$k@k)
#'     }
#'     
#'     if(variable_name == "ntimeseries") {
#'         return(as.integer(length(lda_result$k@terms)))
#'     }
#'     
#'     if(variable_name == "ntimesteps") {
#'         return(lda_result$k@wordassignments$nrow)
#'     }
#'     
#'     return("Variable not recognized")
#'     
#' }
#' 
#' 
#' #' Get max topics
#' #'
#' #' @param lda_name lda name
#' #'
#' #' @return limit on number of topics
#' #' @export
#' extract_max_topics <- function(lda_name) {
#'     maxtopics <- unlist(strsplit(lda_name, split = "_"))
#'     maxtopics <- maxtopics[ length(maxtopics)]
#'     maxtopics <- as.numeric(maxtopics)
#'     return(maxtopics)
#' }
#' 
#' #' Make LDA result summary table
#' #' @param lda_results lda_results
#' #' @return table of lda name, ntopics, nterms (species), ntimesteps
#' #' @export
#' collect_lda_result_summary <- function(lda_results) {
#'     lda_result_summary <- data.frame(
#'         lda_name = names(lda_results),
#'         ntopics = vapply(lda_results, FUN = extract_lda_variable, variable_name = "ntopics", FUN.VALUE = 3),
#'         maxtopics = vapply(names(lda_results), extract_max_topics, FUN.VALUE = 10),
#'         ntimeseries = vapply(lda_results, FUN = extract_lda_variable, variable_name = "ntimeseries", FUN.VALUE = 3),
#'         ntimesteps = vapply(lda_results, FUN = extract_lda_variable, variable_name = "ntimesteps", FUN.VALUE = 3),
#'       filtered  = vapply(names(lda_results), FUN = get_filtered, FUN.VALUE = "complete"),
#'       data_name =  vapply(names(lda_results),
#'                           FUN = get_data_names,
#'                           model_type = "lda_selected",
#'                           FUN.VALUE = "maizuru_data"),
#'         stringsAsFactors = FALSE,
#'         row.names = NULL
#'     )
#' 
#'     
#'     return(lda_result_summary)
#' }
#' 
#' #' Extract results from TS results
#' #' @param ts_result a TS model
#' #' @param variable_name "nchangepoints", "formula", "AIC", to be expanded
#' #' @return value of that variable
#' #' @export
#' extract_ts_variable <- function(ts_result, variable_name) {
#'     if(!is.null(names(ts_result))) {
#'         if(variable_name == "nchangepoints") {
#'             return(ts_result$nchangepoints)
#'         }
#'         if(variable_name == "formula") {
#'             return(deparse(ts_result$formula))
#'         }
#'         if(variable_name == "AIC") {
#'             return(deparse(ts_result$AIC))
#'         }
#'         return("Variable not recognized")
#'     } else {
#'         return()
#'     }
#' }
#' 
#' #' Make TS result summary table
#' #' @param ts_results ts_results
#' #' @return table of ts name, nchangepoints
#' #' @export
#' collect_ts_result_summary <- function(selected_ts_results) {
#'     
#'     successful_ts_select_results <- selected_ts_results[ which(unlist(lapply(selected_ts_results, FUN = is.list)))]
#'     
#'     ts_result_summary <- data.frame(
#'         ts_name = names(successful_ts_select_results),
#'         nchangepoints = vapply(successful_ts_select_results, FUN = try(extract_ts_variable), variable_name = "nchangepoints", FUN.VALUE = 3),
#'         formula = vapply(successful_ts_select_results, FUN = try(extract_ts_variable), variable_name = "formula", FUN.VALUE = "~1"),
#'         maxtopics = vapply(names(successful_ts_select_results), extract_max_topics, FUN.VALUE = 10),
#'         filtered  = vapply(names(successful_ts_select_results), FUN = get_filtered, FUN.VALUE = "complete"),
#'         data_name = vapply(names(successful_ts_select_results),
#'                             get_data_names,
#'                             model_type = "ts_selected",
#'                             FUN.VALUE = "maizuru_data"),
#'         stringsAsFactors = FALSE,
#'         row.names = NULL
#'     )
#'     
#'     ts_result_summary$gen_formula <- vapply(ts_result_summary$formula,
#'                                                 generalize_formula,
#'                                                 FUN.VALUE = "gamma ~ 1")
#'     
#'     return(ts_result_summary)
#' }
#' 
#' #' Collect LDA and TS summaries in one df
#' #' @param lda_result_summary lda_result_summary
#' #' @param ts_result_summary ts_result_summary
#' #' @return df of tables joined
#' #' @export
#' #' @importFrom dplyr mutate left_join
#' collect_lda_ts_results <- function(lda_result_summary, ts_result_summary){
#'     lda_result_summary$data_name <- vapply(lda_result_summary$lda_name,
#'                                            get_data_names,
#'                                            model_type = "lda_selected",
#'                                            FUN.VALUE = "maizuru_data")
#'                       
#' 
#'     lda_ts_result_summary <- dplyr::left_join(lda_result_summary, ts_result_summary, by = c("filtered", "data_name", "maxtopics"))
#'     
#'     ts_result_summary$filtered_topics <- paste(ts_result_summary$filtered, ts_result_summary$max_topics,
#'                                                sep = "_")
#'     
#'     ts_result_summary$cpts_formula <- paste(ts_result_summary$nchangepoints,
#'                                             ts_result_summary$gen_formula,
#'                                             sep = "_")
#'     
#'     return(lda_ts_result_summary)
#' }
#' 
#' 
#' #' Get data name out of model name
#' #'
#' #' @param model_name model name, string to process
#' #' @param model_type "ts_notselected", "ts_selected", "lda_selected"
#' #'
#' #' @return data name
#' #' @export
#' get_data_names <- function(model_name, model_type = "ts_notselected") {
#'     if(model_type == "ts_notselected") {
#'         if(grepl("ts_select", model_name)) {
#'             model_name <- unlist(strsplit(model_name, split = "ts_select_"))[2]
#'         }
#'         data_name <- unlist(strsplit(model_name, split = "ts_"))[2]
#'         data_name <- unlist(strsplit(data_name, split = "_lda_select"))[1]
#'         if(grepl("filtered", data_name)){
#'             data_name <- unlist(strsplit(data_name, split = "filtered_"))[2]
#'         }
#'     }
#'     if(model_type %in% c("lda_selected", "ts_selected")) {
#'         data_name <- unlist(strsplit(model_name, split = "select_lda_"))[2]
#'         if(grepl("filtered", data_name)) {
#'             data_name <- unlist(strsplit(data_name, split = "filtered_"))[2]
#'         }
#'         max_topics <- unlist(strsplit(data_name, split = "_"))[length(unlist(strsplit(data_name, split = "_")))]
#'         max_topics <- paste0("_", max_topics)
#'         data_name <- substr(data_name, 0, nchar(data_name) - nchar(max_topics))
#'     }
#'     return(data_name)
#' }
#' 
#' #' Get whether a model was run on filtered data
#' #' From model name
#' #'
#' #' @param model_name string to process
#' #'
#' #' @return "filtered", "complete"
#' #' @export
#' get_filtered <- function(model_name) {
#'     if(grepl("filtered", model_name)){
#'         return("filtered")
#'     }
#'     return("complete")
#' }
#' 
#' #' Get generalized formula for TS model
#' #'
#' #' @param model_formula  string to process
#' #'
#' #' @return formula as "gamma ~ time" instead of "gamma ~ TIMENAME"
#' #' @export
#' generalize_formula <- function(model_formula) {
#'     if(!grepl("1", model_formula)) {
#'         model_formula = "gamma ~ time"
#'     }
#'     return(model_formula)
#' }
#' 
#' #' Make detailed TS result summary table
#' #' @param ts_results All ts results (not selected)
#' #' @return table of ts name, nchangepoints, formula, and AIC for each model
#' #' @export
#' collect_ts_result_models_summary <- function(ts_results) {
#'     
#'     successful_ts_results <- ts_results[ which(unlist(lapply(ts_results, FUN = is.list)))]
#'     
#'     # do this per dataset
#'     ts_result_summaries <- list()
#'     
#'     for(i in 1:length(successful_ts_results)) {
#'         this_ts <- successful_ts_results[[i]]
#'         ts_result_summaries[[i]] <- data.frame(
#'             ts_name = names(successful_ts_results)[i],
#'             nchangepoints = vapply(this_ts, FUN = try(extract_ts_variable), variable_name = "nchangepoints", FUN.VALUE = 3),
#'             formula = vapply(this_ts, FUN = try(extract_ts_variable), variable_name = "formula", FUN.VALUE = "~1"),
#'             AIC = vapply(this_ts, FUN = try(extract_ts_variable), variable_name = "AIC", FUN.VALUE = "430"),
#'             stringsAsFactors = FALSE,
#'             row.names = NULL
#'         )
#'     }
#'     
#'     ts_result_summary <- dplyr::bind_rows(ts_result_summaries)
#'     
#'     
#'     
#'     ts_result_summary$gen_formula <- vapply(ts_result_summary$formula,
#'                                             generalize_formula,
#'                                             FUN.VALUE = "gamma ~ 1")
#'     ts_result_summary$data_name <- vapply(ts_result_summary$ts_name,
#'                                           get_data_names,
#'                                           FUN.VALUE = "maizuru_data",
#'                                           model_type = "ts_notselected")
#'     ts_result_summary$max_topics <- vapply(ts_result_summary$ts_name,
#'                                            extract_max_topics,
#'                                            FUN.VALUE = 16)
#'     ts_result_summary$filtered <- vapply(ts_result_summary$ts_name,
#'                                          get_filtered,
#'                                          FUN.VALUE = "filtered")
#'     ts_result_summary$filtered_topics <- paste(ts_result_summary$filtered, ts_result_summary$max_topics,
#'                                                sep = "_")
#'     
#'     ts_result_summary$cpts_formula <- paste(ts_result_summary$nchangepoints,
#'                                             ts_result_summary$gen_formula,
#'                                             sep = "_")
#'     return(ts_result_summary)
#' }
#' 
#' 
