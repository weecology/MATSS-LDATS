library(MATSS)
library(matssldats)
library(dplyr)

sequential <- TRUE

data <- get_portal_annual_data()

nseg <- 5
if(!sequential) {
    
    data$covariates$data_assignments <- sample.int(nseg, size = nrow(data$abundance), replace = T)
    
    data_groups <- list() 
    
    
    for (i in 1:nseg) {
        data_groups[[i]] <- data
        
        data_groups[[i]]$abundance <- as.data.frame(data_groups[[i]]$abundance[ - which(data_groups[[i]]$covariates$data_assignments == i), ])
        data_groups[[i]]$covariates <- data_groups[[i]]$covariates[ - which(data_groups[[i]]$covariates$data_assignments == i), ]
        data_groups[[i]]$metadata$group <- i
    }
} else {
    
    seg_starts <- floor(seq.int(0, nrow(data$abundance) +1, length.out = 6))
    
    data_groups <- list()
    
    for (i in 1:nseg) {
        data_groups[[i]] <- data
        
        data_groups[[i]]$abundance <- as.data.frame(data_groups[[i]]$abundance[ - which((c(1:nrow(data_groups[[i]]$covariates)) > seg_starts[i]) & (c(1:nrow(data_groups[[i]]$covariates)) <= seg_starts[i + 1])), ])
        data_groups[[i]]$covariates <- data_groups[[i]]$covariates[ - which((c(1:nrow(data_groups[[i]]$covariates)) > seg_starts[i]) & (c(1:nrow(data_groups[[i]]$covariates)) <= seg_starts[i + 1])), ]
        data_groups[[i]]$metadata$group <- i
        
    }
}

lda_models <- list()
for(i in 1:nseg) {
    lda_models[[i]] <- run_LDA(data = data_groups[[i]], n_topics = c(3, 6, 12), nseeds = 20)
}

if(!sequential) {
    for(i in 1:nseg) {
        this_seg <- list()
        this_seg$lda_models <- lda_models[[i]]
        this_seg$ts_models  <- run_TS(ldamodels = this_seg$lda_models, nchangepoints = c(0,1), formulas = c("time", "intercept"), control = list(nit = 1000))
        save(this_seg, file = here::here("analysis", "loo", paste0("loo_ts_", i, ".Rds")))
    }
} else {
    for(i in 1:nseg) {
        this_seg <- list()
        this_seg$lda_models <- lda_models[[i]]
        this_seg$ts_models  <- run_TS(ldamodels = this_seg$lda_models, nchangepoints = c(0,1), formulas = c("time", "intercept"), control = list(nit = 1000))
        save(this_seg, file = here::here("analysis", "loo", paste0("loo_ts_sequential", i, ".Rds")))
    }
}
