library(MATSS)
library(matssldats)
library(dplyr)
library(ggplot2)

full_data <- get_portal_annual_data()

get_interpolated_aicc <- function(ts_model_info_row, this_seg, full_data, holdout_only = F) {
    this_ts <- this_seg$ts_models$ts[[ts_model_info_row$ts_model_index]]
    this_ts$data <- left_join(full_data$covariates, this_ts$data, by = "year") 
    
    if(holdout_only) {
        this_ts$data <- filter(this_ts$data, is.na(gamma[,1]))
    }
    
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

evaluate_all <- function(section, full_data, sequential = F, holdout_only = F) {
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
               sequential = sequential, holdout_only = holdout_only)
    return(ts_model_info) 
    
}

# all_model_eval <- apply(as.matrix(c(1:5)), MARGIN = 1, FUN = evaluate_all, full_data = full_data) %>%
#     bind_rows()
# 
# save(all_model_eval, file = here::here("analysis", "loo", "all_model_eval.Rds"))
# 
# all_model_eval_s <- apply(as.matrix(c(1:5)), MARGIN = 1, FUN = evaluate_all, full_data = full_data, sequential = T) %>%
#     bind_rows()
# 
# save(all_model_eval_s, file = here::here("analysis", "loo", "all_model_eval_sequential.Rds"))


all_model_eval_s_h <- apply(as.matrix(c(1:5)), MARGIN = 1, FUN = evaluate_all, full_data = full_data, sequential = T, holdout_only = T) %>%
    bind_rows()

save(all_model_eval_s_h, file = here::here("analysis", "loo", "all_model_eval_sequential_holdout.Rds"))


all_model_eval_h <- apply(as.matrix(c(1:5)), MARGIN = 1, FUN = evaluate_all, full_data = full_data, sequential = F, holdout_only = T) %>%
    bind_rows()

save(all_model_eval_h, file = here::here("analysis", "loo", "all_model_eval_holdout.Rds"))
