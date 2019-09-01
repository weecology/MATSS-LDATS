context("Check TS evaluation functions")

# load prepackaged data
load(here::here("analysis", "exclosures_data.Rds"))


test_that("TS AICc functions work without heldout data", {
    expect_error(one_lda <- run_LDA(data = portal_annual, n_topics = 2, seed = 2), NA)
    set.seed(11)
    expect_error(one_ts <- run_TS(one_lda, formulas = c(~ year), nchangepoints = c(0,1),weighting = "proportional", control = list(nit = 100)), NA)
    expect_true(all(c("ts", "model_info") %in% names(one_ts)))
    expect_equal(length(one_ts$ts), 2)
    
    # Test 
    for(i in 1:2) {
        expect_error(a_theta <- get_theta(one_ts$ts[[i]], sim = 1), NA)
        expect_equal(nrow(a_theta), nrow(portal_annual$abundance))
        expect_true(all(abs(rowSums(a_theta) - 1) <= 0.00000000000001))
    }
    
    # Get a theta matrix by hand
    
    for(i in 1:2) {
        sim = 1
        
        covars <- get_relevant_covars(one_ts$ts[[i]]$data, one_ts$ts[[i]]$formula)
        expect_equal(covars$year, one_ts$ts[[i]]$data$year)
        
        ncovar <- ncol(covars)
        expect_equal(ncovar, 2)
        
        nseg <- ifelse(is.null(one_ts$ts[[i]]$rhos), 1, ncol(one_ts$ts[[i]]$rhos) + 1)
        expect_equal(nseg, i)
        
        ntopics <- ncol(one_ts$ts[[i]]$data$gamma)
        expect_equal(ntopics, 2)
        
        ndocs <- nrow(one_ts$ts[[i]]$data)
        expect_equal(ndocs, nrow(portal_annual$abundance))
        
        X <- matrix(nrow = ndocs, ncol = ncovar, data = unlist(covars), byrow = FALSE)
        expect_equal(X[1, 1], covars$intercept[1])
        expect_equal(X[1, 2], covars$year[1])
        
        model_Eta <- one_ts$ts[[i]]$etas[sim, ]
        
        Eta_matrix <- matrix(nrow = ncovar  * nseg, ncol = ntopics,
                             data = c(rep(0, times = ncovar * nseg), model_Eta), byrow = FALSE)
        
        expect_true(all(Eta_matrix[,1] == 0))
        expect_true(all(Eta_matrix[,2] == model_Eta))
        
        rho = one_ts$ts[[i]]$rhos[sim,]
        
        if (i == 1) {
            expect_null(rho)
        } else {
            expect_true(rho %in% portal_annual$covariates$year)
        }
        
        tD <- unlist(one_ts$ts[[i]]$data[ , one_ts$ts[[i]]$timename])
        
        expect_true(all(tD == portal_annual$covariates$year))
        
        set.seed(11)
        Theta <- LDATS::sim_TS_data(X, Eta_matrix, rho, tD, err = 0)
        
        set.seed(11)
        Theta1 <- get_theta(ts_model = one_ts$ts[[i]], sim = 1)
        
        expect_equal(Theta, Theta1)
        
    }
    
    # Do AICc by hand
    
    for(i in 1:2) {
        betas <- exp(one_lda$lda[[1]]@beta)
        
        expect_equal(nrow(betas), 2)
        expect_equal(ncol(betas), ncol(portal_annual$abundance))
        expect_true(all(abs(rowSums(betas) - 1) <=  0.000000000001))
        
        all_thetas <- lapply(as.list(1:nrow(one_ts$ts[[i]]$etas)), 
                             FUN = get_theta, ts_model = one_ts$ts[[i]])
        
        all_aicc <- vapply(all_thetas, FUN = get_aicc,
                           beta_matrix = betas, lda_model = one_lda$lda[[1]],
                           ts_model = one_ts$ts[[i]], counts_matrix = portal_annual$abundance,
                           FUN.VALUE = 1000)
        
        expect_false(anyNA(all_aicc))
        
        expect_type(all_aicc, "double")
        
        expect_error(docp <- all_thetas[[1]] %*% betas, NA)
        
        expect_error(oneLik <- get_doc_lik(portal_annual$abundance, docp, 1), NA)
    }
})


test_that("TS eval functions work with heldout data", {
    expect_error(data_seg <- subset_data(portal_annual, n_segs = nrow(portal_annual$abundance), sequential = T, buffer = 2, which_seg = 1), NA)
    expect_error(one_lda <- run_LDA(data_seg, n_topics = 2, seed = 2), NA)
    expect_error(one_ts <- run_TS(one_lda, formulas = c( ~ year), nchangepoints = c(0,1),weighting = "proportional", control = list(nit = 100)), NA)
    expect_true(all(c("ts", "model_info") %in% names(one_ts)))
    expect_equal(length(one_ts$ts), 2)
    
    # Test 
    for(i in 1:2) {
        expect_error(a_theta <- get_theta(one_ts$ts[[i]], sim = 1), NA)
        expect_equal(nrow(a_theta), nrow(data_seg$abundance))
        expect_true(all(abs(rowSums(a_theta) - 1) <= 0.00000000000001))
    }
    
    # Get a theta matrix by hand
    
    for(i in 1:2) {
        sim = 1
        
        covars <- get_relevant_covars(one_ts$ts[[i]]$data, one_ts$ts[[i]]$formula)
        expect_equal(covars$year, one_ts$ts[[i]]$data$year)
        
        ncovar <- ncol(covars)
        expect_equal(ncovar, 2)
        
        nseg <- ifelse(is.null(one_ts$ts[[i]]$rhos), 1, ncol(one_ts$ts[[i]]$rhos) + 1)
        expect_equal(nseg, i)
        
        ntopics <- ncol(one_ts$ts[[i]]$data$gamma)
        expect_equal(ntopics, 2)
        
        ndocs <- nrow(one_ts$ts[[i]]$data)
        expect_equal(ndocs, nrow(data_seg$abundance))
        
        X <- matrix(nrow = ndocs, ncol = ncovar, data = unlist(covars), byrow = FALSE)
        expect_equal(X[1, 1], covars$intercept[1])
        expect_equal(X[1, 2], covars$year[1])
        
        model_Eta <- one_ts$ts[[i]]$etas[sim, ]
        
        Eta_matrix <- matrix(nrow = ncovar  * nseg, ncol = ntopics,
                             data = c(rep(0, times = ncovar * nseg), model_Eta), byrow = FALSE)
        
        expect_true(all(Eta_matrix[,1] == 0))
        expect_true(all(Eta_matrix[,2] == model_Eta))
        
        rho = one_ts$ts[[i]]$rhos[sim,]
        
        if (i == 1) {
            expect_null(rho)
        } else {
            expect_true(rho %in% data_seg$covariates$year)
        }
        
        tD <- unlist(one_ts$ts[[i]]$data[ , one_ts$ts[[i]]$timename])
        
        expect_true(all(tD == data_seg$covariates$year))
        
        set.seed(11)
        Theta <- LDATS::sim_TS_data(X, Eta_matrix, rho, tD, err = 0)
        
        set.seed(11)
        Theta1 <- get_theta(ts_model = one_ts$ts[[i]], sim = 1)
        
        expect_equal(Theta, Theta1)
        
    }
    
    # Do test loglik by hand
    
    for(i in 1:2) {
        betas <- exp(one_lda$lda[[1]]@beta)
        
        expect_equal(nrow(betas), 2)
        expect_equal(ncol(betas), ncol(data_seg$abundance))
        expect_equal(ncol(betas), ncol(data_seg$test_abundance))
        expect_true(all(abs(rowSums(betas) - 1) <=  0.000000000001))
        
        heldout_data <- one_ts$ts[[i]]$data[1:nrow(data_seg$test_covariates), ] 
        heldout_data[ , "year"] <- data_seg$test_covariates[ , "year"]
        
        expect_true(heldout_data$year == 1988)
        expect_true(all(c("year", "gamma") %in% colnames(heldout_data)))
        expect_false(heldout_data$year %in% data_seg$covariates$year)

        all_data <- rbind(one_ts$ts[[i]]$data, heldout_data)
        one_ts$ts[[i]]$data <- all_data
        heldout_data_rows <- which(all_data[ ,"year"] %in% unlist(data_seg$test_covariates[ ,"year"]))
    
        all_thetas <- lapply(as.list(1:nrow(one_ts$ts[[i]]$etas)), 
                             FUN = get_theta, ts_model = one_ts$ts[[i]])
        all_thetas <- lapply(all_thetas, 
                             FUN = function(theta_matrix, heldout_rows)
                                 return(theta_matrix[heldout_rows, ]),
                             heldout_rows = heldout_data_rows)
        
        
        expect_error(all_logLik <- vapply(all_thetas, FUN = get_loglik,
                             beta_matrix = betas, counts_matrix = data_seg$test_abundance,
                             FUN.VALUE = 1000), NA)
        
        expect_error(all_ts_test_loglik <-ts_test_loglik(ts_model = one_ts$ts[[i]], 
                                            lda_model = one_lda$lda[[1]], data = data_seg), NA)
        
    }

})
