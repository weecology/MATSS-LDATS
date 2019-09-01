context("Check TS predict function")

# load prepackaged data
load(here::here("analysis", "exclosures_data.Rds"))


test_that("predict TS function works without heldout data", {
    expect_error(one_lda <- run_LDA(data = portal_annual, n_topics = 2, seed = 2), NA)
    set.seed(11)
    expect_error(one_ts <- run_TS(one_lda, formulas = c(~ year), nchangepoints = c(0,1),weighting = "proportional", control = list(nit = 100)), NA)
    expect_true(all(c("ts", "model_info") %in% names(one_ts)))
    expect_equal(length(one_ts$ts), 2)
    
    expect_error(pred <- ts_predict_corpus(ts_model = one_ts$ts[[1]], lda_model = one_lda$lda[[1]], data = portal_annual, draw = 1), NA)
    
    pred_abund <- pred %>%
        dplyr::filter(source == "pred") %>%
        dplyr::select(-source) %>%
        tidyr::spread(key = "species", value = "abundance") %>%
        dplyr::select(-timestep)
    
    obs_abund <- pred %>% 
        dplyr::filter(source == "observed") %>%
        dplyr::select(-source) %>%
        tidyr::spread(key = "species", value = "abundance") %>%
        dplyr::select(-timestep)
    
    expect_true(all(colnames(obs_abund) == colnames(pred_abund)))
    
    expect_true(all(rowSums(obs_abund) == rowSums(pred_abund)))
    
    expect_true(all(rowSums(portal_annual$abundance) == rowSums(pred_abund)))
    
    

})


test_that("predict TS works with heldout data", {
    expect_error(data_seg <- subset_data(portal_annual, n_segs = nrow(portal_annual$abundance), sequential = T, buffer = 2, which_seg = 1), NA)
    expect_error(one_lda <- run_LDA(data_seg, n_topics = 2, seed = 2), NA)
    expect_error(one_ts <- run_TS(one_lda, formulas = c( ~ year), nchangepoints = c(0,1),weighting = "proportional", control = list(nit = 100)), NA)
    expect_true(all(c("ts", "model_info") %in% names(one_ts)))
    expect_equal(length(one_ts$ts), 2)
    
    expect_error(pred <- ts_predict_corpus(ts_model = one_ts$ts[[1]], lda_model = one_lda$lda[[1]], data = list(abundance = data_seg$abundance, covariates = data_seg$covariates, metadata = data_seg$metadata), predict_data = list(abundance = data_seg$test_abundance, covariates = data_seg$test_covariates), draw = 1), NA)
    
    pred_abund <- pred %>%
        dplyr::filter(source == "pred") %>%
        dplyr::select(-source) %>%
        tidyr::spread(key = "species", value = "abundance") %>%
        dplyr::select(-timestep)
    
    obs_abund <- pred %>% 
        dplyr::filter(source == "observed") %>%
        dplyr::select(-source) %>%
        tidyr::spread(key = "species", value = "abundance") %>%
        dplyr::select(-timestep)
    
    expect_true(all(colnames(obs_abund) == colnames(pred_abund)))
    
    expect_true(all(rowSums(obs_abund) == rowSums(pred_abund)))
    
    expect_true(all(rowSums(data_seg$test_abundance) == rowSums(pred_abund)))
    
})
