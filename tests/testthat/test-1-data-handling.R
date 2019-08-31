context("Check data subsetting functions")

# load prepackaged data
load(here::here("analysis", "exclosures_data.Rds"))


test_that("exclude transients works", {
    notransients <- remove_transients(portal_annual, threshold = .3)
    expect_equal(nrow(notransients$abundance), nrow(portal_annual$abundance))
    expect_equal(ncol(notransients$abundance), 14)
    
})

test_that("data subsetting works") {
    data_segs <- subset_data(portal_annual, buffer = 2)
    
    expect_equal(length(data_segs), nrow(portal_annual$abundance))
    
    expect_true(nrow(data_segs[[1]]$abundance) < nrow(portal_annual$abundance))
    
    expect_true(nrow(data_segs[[1]]$test_abundance) == 1)
    
    expect_false(data_segs[[1]]$test_covariates$year %in% data_segs[[1]]$covariates$year)
    
}