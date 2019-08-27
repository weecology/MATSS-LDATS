library(MATSS)
library(matssldats)
library(dplyr)
library(ggplot2)

full_data <- get_portal_annual_data()

get_interpolated_aicc <- function(ts_model_info_row, this_seg, full_data) {
    this_ts <- this_seg$ts_models$ts[[ts_model_info_row$ts_model_index]]
    this_ts$data <- left_join(full_data$covariates, this_ts$data, by = "year")
    this_lda <- this_seg$lda_models$lda[[ts_model_info_row$lda_model_index]]
    
    betas <- exp(this_lda@beta)
    
    all_aiccs <- vector(length = nrow(this_ts$etas))
    
    for(sim_index in 1:length(all_aiccs)) {
        this_theta <- get_theta(ts_model = this_ts, sim = sim_index)
        
        all_aiccs[sim_index] <- get_aicc(betas, this_theta, this_lda, this_ts, full_data$abundance)
    }        
    
    this_aicc <- mean(all_aiccs)
    return(this_aicc)
}

evaluate_all <- function(section, full_data, sequential = F) {
    # for a single model set
    if(sequential) {
        load(here::here("analysis", "loo", paste0("loo_ts_sequential", section, ".Rds")))
        
    } else {
    load(here::here("analysis", "loo", paste0("loo_ts_", section, ".Rds")))
    }
    
    ts_model_info <- this_seg$ts_models$model_info
    
    info_rows <- list() 
    
    for(i in 1:nrow(ts_model_info)) {
        info_rows[[i]] <- as.list(ts_model_info[i, ])
    }
    
    ts_model_info <- ts_model_info %>%
        mutate(interpolated_aicc = vapply(info_rows, FUN = get_interpolated_aicc, this_seg = this_seg, full_data = full_data, FUN.VALUE = 100),
               segment = this_seg$lda_models$data$metadata$group,
               sequential = sequential)
    return(ts_model_info) 
    
}

# all_model_eval <- apply(as.matrix(c(1:5)), MARGIN = 1, FUN = evaluate_all, full_data = full_data) %>%
#     bind_rows()
# 
# save(all_model_eval, file = here::here("analysis", "loo", "all_model_eval.Rds"))

all_model_eval_s <- apply(as.matrix(c(1:5)), MARGIN = 1, FUN = evaluate_all, full_data = full_data, sequential = T) %>%
    bind_rows()

save(all_model_eval_s, file = here::here("analysis", "loo", "all_model_eval_sequential.Rds"))




