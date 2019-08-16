# if(FALSE) {
#     library(drake)
#     library(MATSS)
#     library(matssldats)
#     
#     ## Set up the cache and config
#     db <- DBI::dbConnect(RSQLite::SQLite(), here::here("drake", "drake-cache.sqlite"))
#     cache <- storr::storr_dbi("datatable", "keystable", db)
#     
#     loadd(ts_mtquad_data_lda_mtquad_data_5, cache = cache)
#     ts_list <- ts_mtquad_data_lda_mtquad_data_5
# }

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
#' 
#' #' Generate table of LDA and TS info
#' #'
#' #' @param lda_model_names names of LDA models
#' #' @param ts_model_names names of TS models
#' #'
#' #' @return df of LDA nad TS model info
#' #' @export
#' #' @importFrom dplyr left_join
#' make_lda_ts_table <- function(lda_model_names, ts_model_names) {
#'     ts_table <- make_ts_table(ts_model_names)
#'     lda_table <- make_lda_table(lda_model_names)
#'     
#'     lda_ts_table <- dplyr::left_join(ts_table, lda_table, by = c("seed", "k"))
#'     return(lda_ts_table)
#' }

#' Get beta and theta matrices from lda and ts model
#'
#' @param lda_model LDA model
#' @param ts_model TS model fit using that LDA model
#'
#' @return list of beta_vals and all theta estimats from the TS model
#' @export
#'
get_bt <- function(lda_model, ts_model) {
    betaexp = exp(lda_model@beta)
    all_thetas <- lapply(X = c(1:nrow(ts_model$etas)), FUN = get_theta, ts_model = ts_model)
    return(list(beta_vals = betaexp, thetas = all_thetas))
}

#' Get document-term probabilities and AICc from ts_model
#'
#' @param ts_list result of run_TS
#'
#' @return list of data, lda model, ts model, betas & thetas, and AICc estimates
#' @export
#'
get_full_lik <- function(ts_list) {
    ts_models <- ts_list$ts
    lda_models <- ts_list$lda
    data <- ts_list$data
    model_info <- ts_list$model_info
    
    lda_index_index <- which(colnames(model_info) == "lda_model_index")
    ts_index_index <- which(colnames(model_info) == "ts_model_index")
    
    beta_thetas <- apply(model_info,
                         MARGIN = 1,
                         FUN = function(tablerow) 
                             return(
                                 get_bt(
                                     lda_model = lda_models[[as.integer(tablerow[lda_index_index])]], 
                                     ts_model = ts_models[[as.integer(tablerow[ts_index_index])]]
                                 )
                             )
    )
    
    ts_AICc <- apply(model_info,
                     MARGIN = 1,
                     FUN = function(tablerow) 
                         return(
                             get_all_aiccs(bt_list = beta_thetas[[as.integer(tablerow[ts_index_index])]],
                                           ldamodel = lda_models[[as.integer(tablerow[lda_index_index])]],
                                           tsmodel = ts_models[[as.integer(tablerow[ts_index_index])]],
                                           counts_matrix = data$abundance)
                         ))
    
    return(list(data = data,
                beta_thetas = beta_thetas,
                model_info = model_info,
                ts_AICc = ts_AICc))
    
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


#' Get all AICcs
#' Wrapper for `get_aicc`.
#' @param bt_list list of beta and theta values 
#' @param ldamodel source lda model
#' @param tsmodel source ts model
#' @param counts_matrix abundance
#'
#' @return list of AICcs from each estimate of theta
#' @export
#'
get_all_aiccs <- function(bt_list, ldamodel, tsmodel, counts_matrix) {
    all_aicc <- vapply(X = bt_list$thetas, FUN = get_aicc, beta_matrix = bt_list$beta_vals, counts_matrix = counts_matrix, lda_model = ldamodel, ts_model = tsmodel, FUN.VALUE = 100.1)
    return(as.list(all_aicc))
}

#' Expand full like
#'
#' @param result of get_full_lik
#'
#' @return model info with every AICc on its own line
#' @export
#'
#' @importFrom dplyr bind_rows right_join
#' @importFrom tidyr gather
expand_full_lik_results <- function(full_lik) {
    
    model_info <- full_lik$model_info
    
    aiccs <- full_lik$ts_AICc
    aiccs <- lapply(aiccs, FUN = unlist)
    names(aiccs) <- model_info$ts_model_name
    
    br_aiccs <- dplyr::bind_rows(aiccs) %>%
        tidyr::gather(key = "ts_model_name", value = "TS_AICc")
    
    model_info <- dplyr::right_join(model_info, br_aiccs, by = "ts_model_name")
    
    return(model_info)
    
}

#' Predict abundances given model
#'
#' @param full_lik result of get_full_lik
#' @param seed for reprod
#'
#' @return list of predictions
#' @export
#'
predict_abundances <- function(full_lik, seed = 1977) {
    
    sample_sizes <- rowSums(full_lik$data$abundance)
    
    set.seed(seed)
    
    pars_list <- lapply(full_lik$beta_thetas, FUN = function(beta_theta) return(list(beta_vals = beta_theta$beta_vals, theta_vals = beta_theta$thetas[[ sample(1:length(beta_theta$thetas), size = 1)]])))
    
    p_list <- lapply(pars_list, FUN = function(pars_list) return(pars_list$theta_vals %*% pars_list$beta_vals))
    
    predictions <- lapply(p_list, FUN = sample_corpus, sample_sizes = sample_sizes)
    

    return(list(data = full_lik$data,
                model_info = full_lik$model_info,
                prediction = predictions))
}

#' Sample a corpus given sample sizes and ps of documents
#'
#' @param sample_sizes sizes of documents
#' @param docterm_ps probabilities of terms in each document
#'
#' @return sampled corpus
#' @export
#'
sample_corpus <- function(sample_sizes, docterm_ps) {
    
    document <- apply(as.matrix(1:nrow(docterm_ps)),
                      MARGIN = 1,
                      FUN = function(row_index, sample_sizes, docterm_ps) 
                          return(rmultinom(n = 1, size = sample_sizes[row_index],
                                           prob = docterm_ps[row_index, ])),
                      sample_sizes = sample_sizes, 
                      docterm_ps = docterm_ps) %>%
        as.data.frame() %>%
        t()
    
    return(document)
    
}
