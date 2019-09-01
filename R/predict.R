#' Extract the covariates used in a formula
#'
#' @param covariates_table from a data object
#' @param ts_formula formula for a ts model
#'
#' @return the subset of columns in the covariates table used in the formula
#' @export
#'
get_relevant_covars <- function(covariates_table, ts_formula) {
    formula_string <- unlist(as.character(ts_formula))
    
    formula_string <- formula_string[ which((formula_string != "~") & (formula_string != "gamma") & (formula_string != "1"))]
    
    covariates_table$intercept <- 1
    covars <- as.data.frame(covariates_table[ , c("intercept", formula_string)])
    
    return(covars)
}

#' Get theta from a ts model 
#' 
#' The thetas are the document-topic probabilities for each draw from the posterior for Eta and rho. 
#' 
#' @param ts_model TS_on_LDA
#' @param sim which draw from the posterior
#'
#' @return Theta matrix for that draw
#' @export
#'
#' @importFrom LDATS sim_TS_data
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
    
    Theta <- LDATS::sim_TS_data(X, Eta_matrix, rho, tD, err = 0)
    
    return(Theta) 
}


#' Generate table of LDA model info
#'
#' @param lda_model_names names of an LDA_set
#'
#' @return dataframe of name, index, seed, and k
#' @export
#'
#' @importFrom dplyr mutate
make_lda_table <- function(lda_model_names) {
    lda_table <- lapply(lda_model_names, FUN = function(x) return(unlist(strsplit(x, split = ", "))))
    names(lda_table) <- 1:length(lda_table)
    
    lda_table <- as.data.frame(lda_table) %>% 
        t() %>%
        as.data.frame()
    
    colnames(lda_table) <- c("k", "seed")
    
    lda_table <- lda_table %>%
        dplyr::mutate(k = vapply(k, FUN = function(K) return(as.integer(unlist(strsplit(as.character(K), split = "k: "))[[2]])), FUN.VALUE = 1),
                      seed = vapply(seed, FUN = function(S) return(as.integer(unlist(strsplit(as.character(S), split = "seed: "))[[2]])), FUN.VALUE = 2),
                      lda_model_name = lda_model_names,
                      lda_model_index = 1:length(lda_model_names)
        )
    return(lda_table)
}


#' Generate table of TS model info
#'
#' @param ts_model_names names of a set of TS models
#'
#' @return data frame of corresponding TS model name, index, k, seed, nchangepoints, formula
#' @export
#'
#' @importFrom dplyr mutate
make_ts_table <- function(ts_model_names) {
    ts_table <- lapply(ts_model_names, FUN = function(x) return(unlist(strsplit(x, split = ", "))))
    names(ts_table) <- 1:length(ts_table)
    
    ts_table <- as.data.frame(ts_table) %>% 
        t() %>%
        as.data.frame()
    
    colnames(ts_table) <- c("k", "seed", "formula", "changepoints")
    
    ts_table <- ts_table %>%
        dplyr::mutate(k = vapply(k, FUN = function(K) return(as.integer(unlist(strsplit(as.character(K), split = "k: "))[[2]])), FUN.VALUE = 1),
                      seed = vapply(seed, FUN = function(S) return(as.integer(unlist(strsplit(as.character(S), split = "seed: "))[[2]])), FUN.VALUE = 2),
                      formula = as.character(formula),
                      changepoints = vapply(changepoints, FUN = function(cpts) return(as.integer(unlist(strsplit(as.character(cpts), split = " changepoints"))[[1]])), FUN.VALUE = 1),
                      ts_model_name = ts_model_names,
                      ts_model_index = 1:length(ts_model_names)
        )
    return(ts_table)
}

#' Compute loglikelihood of observed data given probabilities
#'
#' @param counts_matrix observed abundance data
#' @param p_matrix predicted abundance probabilities
#' @param index which document; for iterating over all documents
#'
#' @return loglik of a single document
#' @export
#'
get_doc_lik <- function(counts_matrix, p_matrix, index) {
    counts <- as.integer(counts_matrix[index, ])
    ps <- p_matrix[index, ]
    doc_loglik <- dmultinom(x = counts, prob = ps, log = TRUE)
    return(doc_loglik)
}


#' Calculate AICc of observed data given estimates of beta and theta
#'
#' @param beta_matrix topic-term probabilities
#' @param theta_matrix document-topic probabilties
#' @param lda_model lda model, for df
#' @param ts_model ts model, for df
#' @param counts_matrix observed abundance data
#'
#' @return AICc
#' @export
#'
get_aicc <- function(beta_matrix, theta_matrix, lda_model, ts_model, counts_matrix) {
    doc_ps <-  theta_matrix %*% beta_matrix
    doc_lik1 <- vapply(1:nrow(counts_matrix), FUN = get_doc_lik, counts_matrix = counts_matrix, 
                       p_matrix = doc_ps, FUN.VALUE = -1)
    ldapars <- attr(logLik(lda_model), "df")
    tspars <- attr(logLik(ts_model), "df")
    totalpars <- ldapars + tspars
    nobs <- attr(logLik(ts_model), "nobs")
    AICc <- (-2 * (sum(doc_lik1))) + 2*(totalpars) + 
        (2 * totalpars^2 + 2 * totalpars)/(nobs - totalpars - 1)
    return(AICc)
}

#' Predict abundances for new data based on TS model
#'
#' @param ts_model one TS fit
#' @param lda_model the upstream LDA model
#' @param data base data
#' @param predict_data list of abundance and covariates for timesteps to predict over
#' @param draw which draw from the posterior
#'
#' @return sampled corpus
#' @export
ts_predict_corpus <- function(ts_model, lda_model, data, predict_data = NULL, draw = 1) {
    betas <- exp(lda_model@beta)
    
    if(!is.null(predict_data)) {
    
    heldout_data <- ts_model$data [1:nrow(predict_data$covariates), ] 
    heldout_data[ , data$metadata$timename] <- predict_data$covariates[ , data$metadata$timename]
    
    all_data <- rbind(ts_model$data, heldout_data)
    
    ts_model$data <- all_data
    
    heldout_data_rows <- which(all_data[ ,data$metadata$timename] %in% unlist(predict_data$covariates[ , data$metadata$timename]))
    }
    
    all_thetas <- lapply(as.list(1:nrow(ts_model$etas)), 
                         FUN = get_theta, ts_model = ts_model)
    if(!is.null(predict_data)) {
        all_thetas <- lapply(all_thetas, 
                         FUN = function(theta_matrix, heldout_rows)
                             return(theta_matrix[heldout_rows, ]),
                         heldout_rows = heldout_data_rows)
    }
    
    this_docp <-all_thetas[[draw]] %*% betas
    
    if(!is.null(predict_data)) {
    this_corpus <- sample_corpus(docterm_ps = this_docp, obs_dat = predict_data$abundance)
    } else {
        this_corpus <- sample_corpus(docterm_ps = this_docp, obs_dat = data$abundance)
    }
        
        
    return(this_corpus)
    
}



#' Calculate loglik of observed data given estimates of beta and theta
#'
#' @param beta_matrix topic-term probabilities
#' @param theta_matrix document-topic probabilties
#' @param counts_matrix observed abundance data
#'
#' @return loglik
#' @export
#'
get_loglik <- function(beta_matrix, theta_matrix, counts_matrix) {
    doc_ps <-  theta_matrix %*% beta_matrix
    doc_lik1 <- vapply(1:nrow(counts_matrix), FUN = get_doc_lik, counts_matrix = counts_matrix, 
                       p_matrix = doc_ps, FUN.VALUE = -1)
    return(sum(doc_lik1))
}

#' Sample a corpus given sample sizes and ps of documents
#'
#' @param docterm_ps probabilities of terms in each document
#' @param obs_dat abundance matrix
#' @return sampled corpus
#' @export
#'
sample_corpus <- function(docterm_ps, obs_dat) {
    
    sample_sizes <- rowSums(obs_dat)
    
    document <- apply(as.matrix(1:nrow(docterm_ps)),
                      MARGIN = 1,
                      FUN = function(row_index, sample_sizes, docterm_ps) 
                          return(rmultinom(n = 1, size = sample_sizes[row_index],
                                           prob = docterm_ps[row_index, ])),
                      sample_sizes = sample_sizes, 
                      docterm_ps = docterm_ps)
    document <- document %>%
        as.data.frame() %>%
        t()
    
    obs_dat <- obs_dat %>%
        dplyr::mutate(timestep = 1:nrow(obs_dat),
                      source = "observed")
    
    colnames(document) <- colnames(obs_dat)[1:(ncol(obs_dat) - 2)]
    pred_dat <- as.data.frame(document) %>%
        dplyr::mutate(timestep = obs_dat$timestep, 
                      source = "pred")
    
    all_dat <- dplyr::bind_rows(obs_dat, pred_dat) %>%
        tidyr::gather(key = "species", value = "abundance", -timestep, -source)
    
    
    return(all_dat)
    
}
