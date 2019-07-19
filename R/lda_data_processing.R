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
