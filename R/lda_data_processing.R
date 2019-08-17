#' Get portal annual data
#'
#' @return dataset of portal annual data
#' @export
#'
#' @importFrom dplyr mutate filter select distinct
get_portal_annual_data <- function() {
    portal_data <- get_portal_rodents()
    
    abund <- portal_data$abundance %>%
        dplyr::mutate(year = as.Date(portal_data$covariates$censusdate)) %>%
        dplyr::mutate(year = as.integer(format(year, "%Y")))
    
    abund_annual <- as.data.frame(t(apply(as.matrix(unique(abund$year)),
                          MARGIN = 1,
                          FUN = function(thisyear)
                              return(colSums(abund %>%
                                                 dplyr::filter(year == thisyear) %>%
                                                 dplyr::select(-year))))))
    class(abund_annual) <- class(abund)
    
    portal_data_annual <- list(
        abundance = abund_annual,
        covariates = abund %>%
            dplyr::select(year) %>%
            dplyr::distinct(year),
        metadata = list(timename = "year", effort = NULL)
    )
    
    return(portal_data_annual)
}

#' Remove transient species
#'
#' Remove species that occur in < X% of samples.
#' 
#' Values for transients could be .1-.35
#' @param document_term_table 
#' @param threshold Cutoff occurrence rate
#'
#' @return dataset with modified document term table
#' @export
remove_transients <- function(dataset, threshold = 0.3) {
    binary_occurrence <- (dataset$abundance >= 1)
    term_occurrence <- colSums(binary_occurrence)
    term_occurrence_rate <- term_occurrence / nrow(dataset$abundance)
    
    terms_to_keep <- which(term_occurrence_rate >= threshold)
    
    dataset$abundance <- dataset$abundance[,terms_to_keep]
    
    return(dataset)
    
}
