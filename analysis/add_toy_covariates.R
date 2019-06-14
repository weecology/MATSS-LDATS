add_toy_covariates <- function(portal_rodents) {
    
    portal_rodents$covariates$month <- as.numeric(format(portal_rodents$covariates$censusdate, "%m"))
    portal_rodents$covariates$timestep <- c(1:nrow(portal_rodents$covariates))
    
    return(portal_rodents)
}