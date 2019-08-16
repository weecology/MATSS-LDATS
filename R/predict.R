if(FALSE) {
    library(drake)
    library(MATSS)
    library(matssldats)
    
    ## Set up the cache and config
    db <- DBI::dbConnect(RSQLite::SQLite(), here::here("drake", "drake-cache.sqlite"))
    cache <- storr::storr_dbi("datatable", "keystable", db)
    
    loadd(ts_mtquad_data_lda_mtquad_data_5, cache = cache)
    ts_list <- ts_mtquad_data_lda_mtquad_data_5
}

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
    
    Theta <- LDATS::sim_TS_data(X, Eta_matrix, rho, tD, err = 0)
    
    return(Theta) 
}


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

make_lda_ts_table <- function(lda_model_names, ts_model_names) {
    ts_table <- make_ts_table(ts_model_names)
    lda_table <- make_lda_table(lda_model_names)
    
    lda_ts_table <- dplyr::left_join(ts_table, lda_table, by = c("seed", "k"))
    return(lda_ts_table)
}

get_docterm_ps <- function(lda_model, ts_model) {
    betaexp = exp(lda_model@beta)
    all_thetas <- lapply(X = c(1:nrow(ts_model$etas)), FUN = get_theta, ts_model = ts_model)
    docterm_ps <- lapply(all_thetas, FUN =  function(theta, beta) return(theta %*% beta),
                         beta = betaexp)
    return(docterm_ps)
    
}

get_DT_list <- function(ts_list) {
    ts_models <- ts_list$ts
    lda_models <- ts_list$upstream$lda
    data <- ts_list$upstream$data
    
    lda_ts_table <- make_lda_ts_table(lda_model_names = names(lda_models),
                                      ts_model_names = names(ts_models))
    dt_prob <- apply(lda_ts_table,
                     MARGIN = 1,
                     FUN = function(tablerow) 
                         return(
                             get_docterm_ps(
                                 lda_model = lda_models[[as.integer(tablerow[8])]], 
                                 ts_model = ts_models[[as.integer(tablerow[6])]]
                                 
                                 
                             )
                         )
    )
    
    return(list(dt_prob = dt_prob,
                upstream = list(data = data,
                                lda = lda_models,
                                ts = ts_models)))
    
}
