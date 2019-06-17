add_toy_covariates <- function(dataset, is_portal = TRUE) {
    if(is_portal) {
    dataset$covariates$month <- as.numeric(format(dataset$covariates$censusdate, "%m"))
    }
    dataset$covariates$timestep <- c(1:nrow(dataset$covariates))
    
    dataset$covariates$normalnoise <- rnorm(n = nrow(dataset$covariates), mean = 100, sd = 20)
    
    return(dataset)

}