

get_doc_lik <- function(counts_matrix, p_matrix, index) {
    counts <- as.integer(counts_matrix[index, ])
    ps <- p_matrix[index, ]
    doc_loglik <- dmultinom(x = counts, prob = ps, log = TRUE)
    return(doc_loglik)
}


get_aicc <- function(beta, theta, lda_model, ts_model, counts_matrix) {
    
    doc_lik1 <- vapply(1:nrow(counts_matrix), FUN = get_doc_lik, counts_matrix = counts_matrix, 
                       p_matrix = P1exp, FUN.VALUE = -1)
    
    ldapars <- attr(logLik(lda_model[[1]]), "df")
    tspars <- attr(logLik(ts_model), "df")
    
    totalpars <- ldapars + tspars
    
    nobs <- attr(logLik(ts_model), "nobs")
    
    AICc <- (-2 * (sum(doc_lik1))) + 2*(totalpars) + 
        (2 * totalpars^2 + 2 * totalpars)/(nobs - totalpars - 1)
    
    return(AICc)
}


get_all_aiccs <- function(lda_model, ts_model, counts_matrix) {
    betaexp <- exp(lda_model[[1]]@beta)
    all_thetas <- lapply(X = c(1:nrow(ts_model$etas)), FUN = get_theta, ts_model = ts_model)
    all_aicc <- vapply(X = all_thetas, FUN = get_aicc, beta = betaexp, lda_model = lda_model, ts_model = ts_model, counts_matrix = counts_matrix, FUN.VALUE = 100.1)
    return(all_aicc)
}

