add_toy_covariates <- function(dataset) {

    dataset$covariates$timestep <- c(1:nrow(dataset$covariates))
    
    dataset$covariates$normalnoise <- rnorm(n = nrow(dataset$covariates), mean = 100, sd = 20)
    
    return(dataset)

}



