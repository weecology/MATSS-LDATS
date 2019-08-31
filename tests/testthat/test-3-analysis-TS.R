context("Check TS analysis function")

# load prepackaged data
load(here::here("analysis", "exclosures_data.Rds"))


test_that("run_TS function works without heldout data", {
    expect_error(one_lda <- run_LDA(data = portal_annual, n_topics = 2, seed = 2), NA)
    
    expect_error(one_ts <- run_TS(one_lda, formulas = c("intercept", "time"), nchangepoints = c(0,1),weighting = "proportional", control = list(nit = 100)), NA)
    expect_true(all(c("ts", "model_info") %in% names(one_ts)))
    expect_type(one_ts$model_info, "list")
    expect_equal(nrow(one_ts$model_info), length(one_ts$ts))
    expect_equal(length(one_ts$ts), 4)
    for(i in 1:4) {
    expect_true(names(one_ts$ts)[i] == one_ts$model_info$ts_model_name[i])
    }
    expect_true(all(c("TS_fit", "list") %in% class(one_ts$ts[[1]])))
    
    expect_false("testll" %in% colnames(one_ts$model_info))
    
    })
test_that("run_TS function works with heldout data", {
  # to write
})
