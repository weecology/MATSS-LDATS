#' Extract results from LDA results
#' @param lda_result an LDA model
#' @param variable_name "ntopics", "ntimeseries", or "ntimesteps"
#' @return value of that variable
#' @export
extract_lda_variable <- function(lda_result, variable_name) {
    if(variable_name == "ntopics") {
        return(lda_result$k@k)
    }
    
    if(variable_name == "ntimeseries") {
        return(as.integer(length(lda_result$k@terms)))
    }
    
    if(variable_name == "ntimesteps") {
        return(lda_result$k@wordassignments$nrow)
    }
    
    return("Variable not recognized")
    
}


#' Get max topics
#'
#' @param lda_name lda name
#'
#' @return limit on number of topics
#' @export
extract_max_topics <- function(lda_name) {
    maxtopics <- unlist(strsplit(lda_name, split = "_"))
    maxtopics <- maxtopics[ length(maxtopics)]
    maxtopics <- as.numeric(maxtopics)
    return(maxtopics)
}

#' Make LDA result summary table
#' @param lda_results lda_results
#' @return table of lda name, ntopics, nterms (species), ntimesteps
#' @export
collect_lda_result_summary <- function(lda_results) {
    lda_result_summary <- data.frame(
        lda_name = names(lda_results),
        ntopics = vapply(lda_results, FUN = extract_lda_variable, variable_name = "ntopics", FUN.VALUE = 3),
        maxtopics = vapply(names(lda_results), extract_max_topics, FUN.VALUE = 10),
        ntimeseries = vapply(lda_results, FUN = extract_lda_variable, variable_name = "ntimeseries", FUN.VALUE = 3),
        ntimesteps = vapply(lda_results, FUN = extract_lda_variable, variable_name = "ntimesteps", FUN.VALUE = 3),
        stringsAsFactors = FALSE,
        row.names = NULL
    )
    
    return(lda_result_summary)
}

#' Extract results from TS results
#' @param ts_result a TS model
#' @param variable_name "nchangepoints", "formula", "AIC", to be expanded
#' @return value of that variable
#' @export
extract_ts_variable <- function(ts_result, variable_name) {
    if(!is.null(names(ts_result))) {
        if(variable_name == "nchangepoints") {
            return(ts_result$nchangepoints)
        }
        if(variable_name == "formula") {
            return(deparse(ts_result$formula))
        }
        if(variable_name == "AIC") {
            return(deparse(ts_result$AIC))
        }
        return("Variable not recognized")
    } else {
        return()
    }
}

#' Make TS result summary table
#' @param ts_results ts_results
#' @return table of ts name, nchangepoints
#' @export
collect_ts_result_summary <- function(selected_ts_results) {
    
    successful_ts_select_results <- selected_ts_results[ which(unlist(lapply(selected_ts_results, FUN = is.list)))]
    
    ts_result_summary <- data.frame(
        ts_name = names(successful_ts_select_results),
        nchangepoints = vapply(successful_ts_select_results, FUN = try(extract_ts_variable), variable_name = "nchangepoints", FUN.VALUE = 3),
        formula = vapply(successful_ts_select_results, FUN = try(extract_ts_variable), variable_name = "formula", FUN.VALUE = "~1"),
        stringsAsFactors = FALSE,
        row.names = NULL
    )
    
    return(ts_result_summary)
}

#' Collect LDA and TS summaries in one df
#' @param lda_result_summary lda_result_summary
#' @param ts_result_summary ts_result_summary
#' @return df of tables joined
#' @export
#' @importFrom dplyr mutate left_join
#' @importFrom stringr str_split
collect_lda_ts_results <- function(lda_result_summary, ts_result_summary){
    lda_result_summary <- lda_result_summary %>%
        dplyr::mutate(data = stringr::str_split(lda_result_summary$lda_name, 
                                                "select_lda_", simplify = T)[,2])
    ts_result_summary <- ts_result_summary %>%
        dplyr::mutate(data = stringr::str_split(ts_result_summary$ts_name, "select_lda_", simplify = T)[,2])
    
    lda_ts_result_summary <- dplyr::left_join(lda_result_summary, ts_result_summary, by = "data")
    
    return(lda_ts_result_summary)
}


#' Make detailed TS result summary table
#' @param ts_results All ts results (not selected)
#' @return table of ts name, nchangepoints, formula, and AIC for each model
#' @export
collect_ts_result_models_summary <- function(ts_results) {
    
    successful_ts_results <- ts_results[ which(unlist(lapply(ts_results, FUN = is.list)))]
    
    # do this per dataset
    ts_result_summaries <- list()
    
    for(i in 1:length(successful_ts_results)) {
        this_ts <- successful_ts_results[[i]]
        ts_result_summaries[[i]] <- data.frame(
            ts_name = names(successful_ts_results)[i],
            nchangepoints = vapply(this_ts, FUN = try(extract_ts_variable), variable_name = "nchangepoints", FUN.VALUE = 3),
            formula = vapply(this_ts, FUN = try(extract_ts_variable), variable_name = "formula", FUN.VALUE = "~1"),
            AIC = vapply(this_ts, FUN = try(extract_ts_variable), variable_name = "AIC", FUN.VALUE = "430"),
            stringsAsFactors = FALSE,
            row.names = NULL
        )
    }
    
    ts_result_summary <- dplyr::bind_rows(ts_result_summaries)
    
    return(ts_result_summary)
}
