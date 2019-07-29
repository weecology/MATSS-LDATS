
#' Get fitted proportions from TS model
#'
#' @param x TS model
#' @param selection "median"
#'
#' @return predicted proportions of each topic for each timestep
#' @export
#'
get_fitted_proportions <- function(x, selection = "median") {
    rhos <- x$rhos
    nrhos <- ncol(rhos)
    if (!is.null(nrhos)) {
        if (selection == "median") {
            spec_rhos <- apply(rhos, 2, median)
        }
        else if (selection == "mode") {
            spec_rhos <- apply(rhos, 2, LDATS::modalvalue)
        }
        else {
            stop("selection input not supported")
        }
    }
    else {
        spec_rhos <- NULL
    }
    x$control$timename <- NULL
    seg_mods <- LDATS::multinom_TS(x$data, x$formula, spec_rhos, x$timename, 
                                   x$weights, x$control)
    nsegs <- length(seg_mods[[1]])
    t1 <- min(x$data[, x$timename])
    t2 <- max(x$data[, x$timename])
    ntopics <- ncol(as.matrix(x$data[[x$control$response]]))
    seg1 <- c(0, spec_rhos[-length(rhos)])
    seg2 <- c(spec_rhos, t2)
    time_obs <- rep(NA, nrow(x$data))
    pred_vals <- matrix(NA, nrow(x$data), ntopics)
    sp1 <- 1
    for (i in 1:nsegs) {
        mod_i <- seg_mods[[1]][[i]]
        spec_vals <- sp1:(sp1 + nrow(mod_i$fitted.values) - 
                              1)
        pred_vals[spec_vals, ] <- mod_i$fitted.values
        time_obs[spec_vals] <- mod_i$timevals
        sp1 <- sp1 + nrow(mod_i$fitted.values)
    }
    return(pred_vals)
}   


#' Draw abundances based on topic proportion and topic composition
#'
#' @param fitted_proportions result of get_fitted_proportions
#' @param ldamodel lda model
#' @param abundance_data abundance data (to get how many individuals to draw per timestep)
#'
#' @return simulated dataset with abundance values per time step
#' @export
get_fitted_abundances <- function(fitted_proportions, ldamodel, abundance_data) {
    betas <- exp(ldamodel@beta)
    
    total_abundances <- rowSums(abundance_data)
    
    topic_abundances <- ceiling(fitted_proportions * total_abundances)
    
    censuses <- list()
    blank_species <- matrix(nrow = 1, ncol = ncol(betas))
    blank_species <- as.data.frame(blank_species)
    colnames(blank_species) <- as.character(1:ncol(betas))
    for(i in 1:nrow(fitted_proportions)) {
        censuses[[i]] <- list()
        for(j in 1:ncol(fitted_proportions)) {
            censuses[[i]][[j]] <- sample.int(n = ncol(betas), size = topic_abundances[i, j], prob = betas[j, ], replace = T)
        }
        censuses[[i]] <- as.data.frame(t(as.matrix(table(unlist(censuses[[i]])))))
        
        
        censuses[[i]] <- dplyr::left_join(censuses[[i]], blank_species)
        
        censuses[[i]][which(is.na(censuses[[i]]))] <- as.integer(0)
        
    }
    censuses <- dplyr::bind_rows(censuses)
    return(censuses)
}


#' Add up total mis-assignments in sim
#'
#' @param predicted_census predicted abundance data per time step
#' @param abundance_table real data
#'
#' @return sum of |pred - true| for all species for all time steps
#' @export
get_total_off <- function(predicted_census, abundance_table) {
    
    predicted_census <- dplyr::select(predicted_census,
                                      as.character(c(1:ncol(predicted_census))))
    
    off <- abs(predicted_census - abundance_table)
    
    total_off <- rowSums(off) * (rowSums(abundance_table) / max(rowSums(abundance_table)))
    
    total_total_off <- sum(total_off)
    
    return(total_total_off)
}
