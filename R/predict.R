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

#' 
#' #' Get all AICcs
#' #' Wrapper for `get_aicc`.
#' #' @param bt_list list of beta and theta values 
#' #' @param ldamodel source lda model
#' #' @param tsmodel source ts model
#' #' @param counts_matrix abundance
#' #'
#' #' @return list of AICcs from each estimate of theta
#' #' @export
#' #'
#' get_all_aiccs <- function(bt_list, ldamodel, tsmodel, counts_matrix) {
#'     all_aicc <- vapply(X = bt_list$thetas, FUN = get_aicc, beta_matrix = bt_list$beta_vals, counts_matrix = counts_matrix, lda_model = ldamodel, ts_model = tsmodel, FUN.VALUE = 100.1)
#'     return(as.list(all_aicc))
#' }
#' 
#' #' Expand full like
#' #'
#' #' @param result of get_full_lik
#' #'
#' #' @return model info with every AICc on its own line
#' #' @export
#' #'
#' #' @importFrom dplyr bind_rows right_join
#' #' @importFrom tidyr gather
#' expand_full_lik_results <- function(full_lik) {
#'     
#'     model_info <- full_lik$model_info
#'     
#'     aiccs <- full_lik$ts_AICc
#'     aiccs <- lapply(aiccs, FUN = unlist)
#'     names(aiccs) <- model_info$ts_model_name
#'     
#'     br_aiccs <- dplyr::bind_rows(aiccs) %>%
#'         tidyr::gather(key = "ts_model_name", value = "TS_AICc")
#'     
#'     model_info <- dplyr::right_join(model_info, br_aiccs, by = "ts_model_name")
#'     
#'     return(model_info)
#'     
#' }
#' 
#' #' Predict abundances given model
#' #'
#' #' @param full_lik result of get_full_lik
#' #' @param seed for reprod
#' #'
#' #' @return list of predictions
#' #' @export
#' #'
#' predict_abundances <- function(full_lik, seed = 1977) {
#'     
#'     if(is.null(full_lik)) {
#'         return()
#'     }
#'     
#'     set.seed(seed)
#'     
#'     pars_list <- lapply(full_lik$beta_thetas, FUN = function(beta_theta) return(list(beta_vals = beta_theta$beta_vals, theta_vals = beta_theta$thetas[[ sample(1:length(beta_theta$thetas), size = 1)]])))
#'     
#'     p_list <- lapply(pars_list, FUN = function(pars_list) return(pars_list$theta_vals %*% pars_list$beta_vals))
#'     
#'     predictions <- lapply(p_list, FUN = sample_corpus, obs_dat = full_lik$data$abundance)
#'     
#'     for(i in 1:length(predictions)) {
#'         predictions[[i]]$model_name <- full_lik$model_info$ts_model_name[i]
#'     }
#' 
#'     return(list(data = full_lik$data,
#'                 model_info = full_lik$model_info,
#'                 prediction = predictions))
#' }

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
