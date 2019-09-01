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



#' All loglik for a single TS model vs. hold-out data
#'
#' @param ts_model one TS fit
#' @param lda_model upstream LDA model
#' @param data data list
#'
#' @return vector of all logliks
#' @export
ts_test_loglik <- function(ts_model, lda_model, data) {
    betas <- exp(lda_model@beta)
    
    heldout_data <- ts_model$data [1:nrow(data$test_covariates), ] 
    heldout_data[ , data$metadata$timename] <- data$test_covariates[ , data$metadata$timename]
    
    all_data <- rbind(ts_model$data, heldout_data)
    
    ts_model$data <- all_data
                                  
    heldout_data_rows <- which(all_data[ ,data$metadata$timename] %in% unlist(data$test_covariates[ , data$metadata$timename]))
       
    all_thetas <- lapply(as.list(1:nrow(ts_model$etas)), 
                         FUN = get_theta, ts_model = ts_model)
    all_thetas <- lapply(all_thetas, 
                         FUN = function(theta_matrix, heldout_rows)
                             return(theta_matrix[heldout_rows, ]),
                         heldout_rows = heldout_data_rows)
    
    all_logLik <- vapply(all_thetas, FUN = get_loglik,
                       beta_matrix = betas, counts_matrix = data$test_abundance,
                       FUN.VALUE = 1000)
    return(all_logLik)
    
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


#' Subset data into training & test sets
#'
#' @param data Beginning data
#' @param n_segs nb of segments
#' @param sequential sequential or not - to be added
#' @param buffer buffer or not - to be added
#' @param which_seg which segment to return - for drake
#'
#' @return list of subsetted data, covariates, metadata, test data, test covs, OR list of all above lists
#' @export
#'
subset_data <- function(data, n_segs = NULL, sequential = T, buffer = NULL, which_seg = NULL) {
    
    if(is.null(n_segs)) {
        n_segs <- nrow(data$abundance)
    }
    
    timesteps <- data$covariates[ , data$metadata$timename]
    
    if(sequential) {
        
        chunk_size <- floor(nrow(timesteps) / n_segs)
        
        assignment_breaks <- 1:n_segs * chunk_size
        
        timesteps$assignments <- NA
        
        for(i in 1:nrow(timesteps)) {
            timesteps$assignments[i] <- min(n_segs, min(which(assignment_breaks >= i)))
        }
    }
    
    
    data_out <- list()
    
    for(i in 1:n_segs) {
        this_metadata <- data$metadata
        this_metadata$segment <- i
        this_metadata$assignments <- timesteps
        
        
        timesteps_out <- which(timesteps$assignments == i)
        
        if(!is.null(buffer)) {
        timesteps_out <- which(abs(1:nrow(timesteps) - timesteps_out) <= buffer)
        }
        
        data_out[[i]] <- list(
            abundance = data$abundance[ -timesteps_out, ],
            covariates = data$covariates[ -timesteps_out, ],
            metadata = this_metadata,
            test_abundance = data$abundance[ which(timesteps$assignments == i), ],
            test_covariates = data$covariates[ which(timesteps$assignments == i), ]
        )
    }
    if(!is.null(which_seg)) {
        return(data_out[[ which_seg]])
    } else {
        return(data_out)
    }
}

