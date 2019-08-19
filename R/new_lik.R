#' Generate predictions from ts model
#'
#' @param l row from a model_info table as a list 
#' @param lda_model or you can give lda model
#' @param ts_model and ts model
#' @param data and data
#' @param cache_location cache location
#' @param sim sim to pull?
#' @param seed seed to set?
#'
#' @return matrix of predicted and observed data
#' @export
#'
ts_predict <- function(l = NULL, lda_model = NULL, ts_model = NULL, data = NULL, sim = NULL, seed = 1977) {
    
    if(!is.null(l)) {
        lda_model <- readd(l$lda_object_name, character_only = T, cache = cache)
        data <- lda_model$data  
        lda_model <- lda_model$lda[[l$lda_model_index]]
        
        ts_model <- readd(l$ts_object_name, character_only = T, cache = cache)
        ts_model <- ts_model$ts[[l$ts_model_index]]
    }
    betas <- exp(lda_model@beta)
    
    
    if(is.null(sim)) {
        set.seed(seed)
        sim <- sample(1:nrow(ts_model$etas), size = 1)
    }
    
    thetas <- get_theta(ts_model = ts_model, sim = sim)
    
    docterm_ps <- thetas %*% betas
    obs_dat <- data$abundance
    
    prediction <- sample_corpus(docterm_ps = docterm_ps, obs_dat = obs_dat)
    
    model_name <- NULL
    
    if(!is.null(l)) {
        model_name <- paste0(l$data_object_name, "; ", l$ts_model_desc_k)
    }
    
    return(list(prediction = prediction,
                model_name = model_name)
    )
}




#' All AICc for a single TS model
#'
#' @param ts_model one TS fit
#' @param lda_model upstream LDA model
#' @param data data list
#'
#' @return vector of all AICc
#' @export
ts_AICc <- function(ts_model, lda_model, data) {
    betas <- exp(lda_model@beta)
    
    all_thetas <- lapply(as.list(1:nrow(ts_model$etas)), 
                         FUN = get_theta, ts_model = ts_model)
    
    all_aicc <- vapply(all_thetas, FUN = get_aicc,
                       beta_matrix = betas, lda_model = lda_model,
                       ts_model = ts_model, counts_matrix = data$abundance,
                       FUN.VALUE = 1000)
    return(all_aicc)
    
}

#' Synthesize model info
#'
#' @param ts_result_list All ts results
#'
#' @return joint df of model info
#' @export
#'
#' @importFrom dplyr bind_rows mutate
all_model_info <- function(ts_result_list) {
    
    model_info <- lapply(ts_result_list, FUN = function(ts_result)
        return(ts_result$model_info)) 
    
    model_info <- model_info %>%
        dplyr::bind_rows(model_info, .id = "ts_object_name") %>%
        dplyr::group_by(ts_object_name) %>%
        dplyr::mutate(lda_object_name = substr(ts_object_name, start = 4, stop = nchar(ts_object_name)), 
                      data_object_name = substr(ts_object_name, start = 8, stop = (max(gregexpr('_', ts_object_name)[[1]]) - 1)),
                      ts_model_desc = paste0(changepoints, "; ", formula),
                      ts_model_desc_k = paste0(changepoints, "; ", formula, "; ", k)        ) %>%
        dplyr::ungroup()
    return(model_info)
    
}
