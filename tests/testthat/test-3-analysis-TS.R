context("Check TS analysis function")

# load prepackaged data
load(here::here("analysis", "exclosures_data.Rds"))


test_that("run_TS function works without heldout data", {
    expect_error(output1 <- run_LDA(data = portal_annual, max_topics = 3, nseeds = 2), NA)
    expect_error(output2 <- run_LDA(data = portal_annual, max_topics = 3, seed = 2), NA)
    expect_error(output3 <- run_LDA(data = portal_annual, n_topics = 3, nseeds = 2), NA)
    expect_error(output4 <- run_LDA(data = portal_annual, n_topics = 3, seed = 2), NA)
    
    expect_true(all(c("LDA_set", "list") %in% class(output$lda)))
    lda_model <- output$lda[[1]]
    
    # does the fitted model have the right # of topics
    expect_equal(lda_model@k, m)
    
    # see if we need to swap order of topics
    model_topics <- exp(lda_model@beta)
    idx <- seq_len(m)
    if (sum(sum(abs(model_topics - topics))) > 
        sum(sum(abs(model_topics[rev(idx), ] - topics))))
    {
        idx <- rev(idx)
    }
    expect_equal(model_topics[idx, ], topics, tolerance = 0.05)
    expect_equal(lda_model@gamma[, idx], topic_prop, tolerance = 0.1)
})
test_that("run_LDA function with user specified seed works", {
    # does run_LDA check data format?
    expect_warning(output <- run_LDA(abundance, seed = 20), 
                   "Incorrect data structure, see data-formats vignette")
    expect_equal(output, "Incorrect data structure")
    
    # does run_LDA run and produce a valid output
    data <- list(abundance = data.frame(abundance))
    expect_error(output <- run_LDA(data, max_topics = 2, seed = 10), NA)
    expect_true(all(c("LDA_set", "list") %in% class(output$lda)))
    lda_model <- output$lda[[1]]
    
    # does the fitted model have the right # of topics
    expect_equal(lda_model@k, m)
    
    # see if we need to swap order of topics
    model_topics <- exp(lda_model@beta)
    idx <- seq_len(m)
    if (sum(sum(abs(model_topics - topics))) > 
        sum(sum(abs(model_topics[rev(idx), ] - topics))))
    {
        idx <- rev(idx)
    }
    expect_equal(model_topics[idx, ], topics, tolerance = 0.05)
    expect_equal(lda_model@gamma[, idx], topic_prop, tolerance = 0.1)
})

test_that("model info comes out properly", {
    data <- list(abundance = data.frame(abundance))
    this_seed = 10
    these_topics = c(2,3)
    output <- run_LDA(data, max_topics = 3, seed = this_seed)
    expect_equal(nrow(output$model_info), length(output$lda))
    expect_equal(output$model_info$lda_model_name, names(output$lda))
    expect_true(all(this_seed %in% output$model_info$seed))
    expect_true(all(these_topics %in% output$model_info$k))
    
})
