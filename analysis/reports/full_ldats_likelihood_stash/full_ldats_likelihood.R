
get_relevant_covars <- function(covariates_table, ts_formula) {
    formula_string <- unlist(as.character(ts_formula))
    
    formula_string <- formula_string[ which((formula_string != "~") & (formula_string != "gamma") & (formula_string != "1"))]
    
    covariates_table$intercept <- 1
    covars <- as.data.frame(covariates_table[ , c("intercept", formula_string)])
    
    return(covars)
}

get_theta <- function(ts_model, sim = 1){
    
    covars <- get_relevant_covars(ts_model$data, ts_model$formula)
    
    ncovar <- ncol(covars)
    nseg <- ifelse(is.null(ts_model$rhos), 1, ncol(ts_model$rhos) + 1)
    ntopics <- ncol(ts_model$data$gamma)
    
    ndocs <- nrow(ts_model$data)
    
    X <- matrix(nrow = ndocs, ncol = ncovar, data = unlist(covars), byrow = FALSE)
    
    model_Eta <- ts_model$etas[sim, ]
    
    Eta_matrix <- matrix(nrow = ncovar  * nseg, ncol = ntopics,
                         data = c(rep(0, times = ncovar * nseg), model_Eta), byrow = FALSE)
    
    rho = ts_model$rhos[sim,]
    
    tD <- unlist(ts_model$data[ , ts_model$timename])
    
    Theta <- sim_TS_data(X, Eta_matrix, rho, tD, err = 0)
    
    return(Theta) 
}


get_doc_lik <- function(counts_matrix, p_matrix, index) {
    counts <- as.integer(counts_matrix[index, ])
    ps <- p_matrix[index, ]
    doc_loglik <- dmultinom(x = counts, prob = ps, log = TRUE)
    return(doc_loglik)
}


get_aicc <- function(beta, theta, lda_model, ts_model, counts_matrix) {
    P1exp <- theta %*% beta
    
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
