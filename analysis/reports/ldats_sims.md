LDA\_TS simulations
================
Renata Diaz
8/5/2019

Make some simulated LDA\_TS data...

``` r
set.seed(1)


N <- sample(x = c(50:100), size = 50, replace = TRUE)
tD <- 1:length(N)
rho <- as.numeric(sample(tD, size = 1))
X <- matrix(c(c(rep.int(x = 1, times = 25), rep.int(x = 0, times = 25)),
                c(rep.int(x = 0, times = 25), rep.int(x = 2, times = 25)),
                c(rep.int(x = 0, times = 25), rep.int(x = .5, times = 25)),
              c(rep.int(x = 0, times = 25), rep.int(x =4, times = 25))), 
            nrow = length(tD), ncol = 4, byrow = FALSE)
Eta <- matrix(c(0.5, 1.2, 0.3, 1.1, 0.9, 0.1, 0.5, 0.5), 
              nrow = ncol(X), ncol = 2, byrow = TRUE)
Beta <- matrix(c(.1, .4, .2, .15, 0, .15, 0, 0, 0, 0,
                 0, .05, 0, .1, 0, 0, .25, .2, .3, .1), 2, 10, byrow = TRUE)
err <- 0.5
seed <- 352

simdat <- sim_LDA_TS_data(N, Beta, X, Eta, rho, tD, err, seed)

library(matssldats)

sim_dat_list <- list(abundance = as.data.frame(simdat),
                     covariates = data.frame(time = 1:length(N)),
                     metadata = list(timename = "time")
)


sim_ldas <- run_LDA(sim_dat_list, max_topics = 6, nseeds = 2)
```

    ## Running LDA with 2 topics (seed 2)

    ## Running LDA with 2 topics (seed 4)

    ## Running LDA with 3 topics (seed 2)

    ## Running LDA with 3 topics (seed 4)

    ## Running LDA with 4 topics (seed 2)

    ## Running LDA with 4 topics (seed 4)

    ## Running LDA with 5 topics (seed 2)

    ## Running LDA with 5 topics (seed 4)

    ## Running LDA with 6 topics (seed 2)

    ## Running LDA with 6 topics (seed 4)

``` r
plot(sim_ldas[[1]])
```

![](ldats_sims_files/figure-markdown_github/simulate%20LDA_TS%20data-1.png)

``` r
sim_lda_selected <- select_LDA(sim_ldas)

sim_ts_list <- run_TS(data = sim_dat_list, ldamodels = sim_lda_selected,
                      formulas = c("intercept", "time"), nchangepoints = c(0, 1), 
                      weighting = "proportional")
```

    ## Running TS model with 0 changepoints and equation gamma ~ time on LDA model k: 2, seed: 2

    ## Running TS model with 0 changepoints and equation gamma ~ 1 on LDA model k: 2, seed: 2

    ## Running TS model with 1 changepoints and equation gamma ~ time on LDA model k: 2, seed: 2

    ##   Estimating changepoint distribution

    ##   Estimating regressor distribution

    ## Running TS model with 1 changepoints and equation gamma ~ 1 on LDA model k: 2, seed: 2

    ##   Estimating changepoint distribution

    ##   Estimating regressor distribution

``` r
sim_ts_selected <- select_TS(sim_ts_list)

plot(sim_ts_selected)
```

![](ldats_sims_files/figure-markdown_github/simulate%20LDA_TS%20data-2.png)

``` r
save.image(here::here("analysis", "reports", "ldats_sims_stash", "ldats_sims_stash.RData"))
```

RMD: I thought this dataset should have one changepoint around ~25, but the selected TS model has no changepoints. I think this has something to do with the covariate matrix X and the regression coefficient matrix - probably these need to fit together in some way? Note to ask Juniper specifically how X relates to the changepoint locations and formulas within segments, and how to generate a document\_covariate\_matrix for the TS model based on sim parameters (? this may not be an issue as long as timestep is the only covariate).
