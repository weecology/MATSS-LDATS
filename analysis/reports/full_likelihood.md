Toy full likelihood
================
Renata Diaz
8/6/2019

Full model likelihood
---------------------

Based on Slack & in person conversation with Hao Ye & Juniper Simonis.

Tacking a full likelihood computation on to existing runs of LDA\_TS models, moving towards whole-model evaluation of goodness of fit (instead of evaluting and selecting LDA and TS components separately and sequentially).

Likelihood of observed dataset (observed term frequencies in each document) from LDA and TS model...

``` r
dat1 <- readd(bbs_data_rtrg_1_11, cache = cache)
counts1 <- dat1$abundance
lda1 <- readd(lda_select_lda_bbs_data_rtrg_1_11_5, cache = cache)
ts1 <- readd(ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5, cache = cache)[[4]]

#plot(lda1)

#plot(ts1)
```

``` r
beta1 <- lda1$`k: 5, seed: 122`@beta

beta1exp <- exp(beta1)
```

``` r
ts1
```

    ## $formula
    ## gamma ~ 1
    ## <environment: 0x7ff302181cc8>
    ## 
    ## $nchangepoints
    ## [1] 1
    ## 
    ## $timename
    ## [1] "year"
    ## 
    ## $ptMCMC_diagnostics
    ## $ptMCMC_diagnostics$step_acceptance_rate
    ## [1] 0.826 0.916 0.952 0.970 0.975 0.979
    ## 
    ## $ptMCMC_diagnostics$swap_acceptance_rate
    ## [1] 0.560 0.659 0.833 0.925 0.960
    ## 
    ## $ptMCMC_diagnostics$trip_counts
    ## [1] 31 40 52 39 36 21
    ## 
    ## $ptMCMC_diagnostics$trip_rates
    ## [1] 0.031 0.040 0.052 0.039 0.036 0.021
    ## 
    ## 
    ## $rho_summary
    ##                  Mean Median Mode Lower_95% Upper_95%   SD MCMCerr   AC10
    ## Changepoint_1 1994.02   1993 1992      1989      2003 3.66  0.1157 0.0998
    ##                    ESS
    ## Changepoint_1 219.2858
    ## 
    ## $eta_summary
    ##                    Mean  Median Lower_95% Upper_95%     SD MCMCerr   AC10
    ## 1_2:(Intercept)  1.5478  1.5333   -0.5058    3.5433 1.0517  0.0333 0.0184
    ## 1_3:(Intercept) -0.6933 -0.7647   -3.5545    2.0884 1.4632  0.0463 0.0277
    ## 1_4:(Intercept)  1.2566  1.2651   -0.8518    3.1271 1.0413  0.0329 0.0098
    ## 1_5:(Intercept)  1.8277  1.7765    0.1561    3.8428 0.9970  0.0315 0.0397
    ## 2_2:(Intercept) -2.1856 -2.1874   -4.6315    0.5343 1.3667  0.0432 0.0864
    ## 2_3:(Intercept)  0.6974  0.6255   -0.5075    2.1126 0.6669  0.0211 0.0410
    ## 2_4:(Intercept) -1.0130 -1.0257   -2.9400    0.9087 0.9696  0.0307 0.0019
    ## 2_5:(Intercept) -0.3198 -0.3204   -1.7156    1.0054 0.7177  0.0227 0.0430
    ##                       ESS
    ## 1_2:(Intercept)  523.8988
    ## 1_3:(Intercept)  904.1900
    ## 1_4:(Intercept)  776.2343
    ## 1_5:(Intercept)  524.1081
    ## 2_2:(Intercept) 1000.0000
    ## 2_3:(Intercept)  666.0029
    ## 2_4:(Intercept)  856.7245
    ## 2_5:(Intercept)  921.0687
    ## 
    ## $logLik
    ## [1] -67.63742
    ## 
    ## $nparams
    ## [1] 9
    ## 
    ## $AIC
    ## [1] 153.2748

``` r
get_relevant_covars <- function(covariates_table, ts_formula) {
    formula_string <- unlist(as.character(ts_formula))
    
    formula_string <- formula_string[ which((formula_string != "~") & (formula_string != "gamma") & (formula_string != "1"))]

    covariates_table$intercept <- 1
    covars <- as.data.frame(covariates_table[ , c("intercept", formula_string)])
    
    return(covars)
}

get_theta <- function(ts_model, sim = 1){

covars <- get_relevant_covars(ts_model$data, ts_model$formula)

ncovar <- ncol(covars)
nseg <- ifelse(is.null(ts_model$rhos), 1, ncol(ts_model$rhos) + 1)
ntopics <- ncol(ts_model$data$gamma)

ndocs <- nrow(ts_model$data)

X <- matrix(nrow = ndocs, ncol = ncovar, data = unlist(covars), byrow = FALSE)

model_Eta <- ts_model$etas[sim, ]

Eta_matrix <- matrix(nrow = ncovar  * nseg, ncol = ntopics,
                     data = c(rep(0, times = ncovar * nseg), model_Eta), byrow = FALSE)

rho = ts_model$rhos[sim,]

tD <- unlist(ts_model$data[ , ts_model$timename])

Theta <- sim_TS_data(X, Eta_matrix, rho, tD, err = 0)

return(Theta) 
}

theta1 <- get_theta(ts1)
```

``` r
P1exp <- theta1 %*% beta1exp
```

``` r
get_doc_lik <- function(index, counts_matrix, p_matrix) {
    counts <- as.integer(counts_matrix[index, ])
    ps <- p_matrix[index, ]
    doc_loglik <- dmultinom(x = counts, prob = ps, log = TRUE)
    return(doc_loglik)
}

doc_lik1 <- vapply(1:nrow(counts1), FUN = get_doc_lik, counts_matrix = counts1, 
                   p_matrix = P1exp, FUN.VALUE = -1)

sum(doc_lik1)
```

    ## [1] -25632.66

``` r
ldapars <- attr(logLik(lda1[[1]]), "df")
tspars <- attr(logLik(ts1), "df")

totalpars <- ldapars + tspars

nobs <- attr(logLik(ts1), "nobs")

AICc <- (-2 * (sum(doc_lik1))) + 2*(totalpars) + 
    (2 * totalpars^2 + 2 * totalpars)/(nobs - totalpars - 1)

AICc
```

    ## [1] 51152.1
