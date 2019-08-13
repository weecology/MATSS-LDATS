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
dat1 <- get_portal_rodents()

ldas <- LDA_set(dat1$abundance, topics = c(2, 5, 16), nseeds = 1)

ts_fits <- run_TS(dat1, ldas, formulas = c("intercept", "time"), 
                  nchangepoints = c(0, 1), weighting = "proportional")

save(dat1, ldas, ts_fits, file = here::here("analysis", "reports", "full_ldats_likelihood_stash", "models.RData"))
#plot(lda1)

#plot(ts1)
```

``` r
ts_fit_names <- strsplit(names(ts_fits), split = ", ")

ts_fit_data <- data.frame(
    ts_index = 1:length(ts_fits),
    ts_names = unlist(names(ts_fits)),
    k = vapply(X = ts_fit_names, FUN = function(X) return(X[[1]]), FUN.VALUE = "k: 2"),
    seed = vapply(X = ts_fit_names, FUN = function(X) return(X[[2]]), 
                FUN.VALUE = "seed: 1"),
    formula = vapply(X = ts_fit_names, FUN = function(X) return(X[[3]]), 
                FUN.VALUE = "gamma ~ time"),
    changepoints = vapply(X = ts_fit_names, FUN = function(X) return(X[[4]]), 
                FUN.VALUE = "0 changepoints")
)

ts_fit_data$k <- substr(ts_fit_data$k, start = 4, stop = nchar(as.character(ts_fit_data$k)))
ts_fit_data$seed <- substr(ts_fit_data$seed, start = 7, stop = nchar(as.character(ts_fit_data$seed)))
ts_fit_data$changepoints <- substr(ts_fit_data$changepoints, start = 1, stop = nchar(as.character(ts_fit_data$changepoints))- 13)

ts_fit_data$lda_name <- paste0("k: ",
                               ts_fit_data$k, 
                               ", seed: ",
                               ts_fit_data$seed)
ts_fit_data$lda_index <- vapply(ts_fit_data$lda_name, function(x, ldamodels) return(which(names(ldamodels) == x)), ldamodels = ldas, FUN.VALUE = 1)

dat_to_aiccs <- function(data_row, ldamodels, tsmodels, datalist) {
    return(get_all_aiccs(lda_model = ldamodels[as.integer(data_row[8])],
                        ts_model = tsmodels[[as.integer(data_row[1])]],
                        counts_matrix = datalist$abundance))
}
```

``` r
model_aiccs <- apply(ts_fit_data, MARGIN = 1, FUN = dat_to_aiccs,
                     ldamodels = ldas, tsmodels = ts_fits, datalist = dat1)

model_aiccs <- as.data.frame(model_aiccs)

colnames(model_aiccs) <- ts_fit_data$ts_names

model_aiccs <- tidyr::gather(model_aiccs, key = "ts_names", value = "AICc") %>%
    dplyr::left_join(ts_fit_data, by = "ts_names")
```

    ## Warning: Column `ts_names` joining character vector and factor, coercing
    ## into character vector

``` r
library(ggplot2)

all_aicc_plot <- ggplot(data = model_aiccs, aes(x = ts_index, y = AICc, color = k)) + 
    geom_point() +
    theme_bw()

all_aicc_plot
```

![](full_likelihood_files/figure-markdown_github/plot%20AICcs-1.png)

``` r
ts_index_summary <- model_aiccs %>%
    dplyr::select(ts_index, k, changepoints, formula) %>%
    dplyr::distinct()

ts_index_summary
```

    ##    ts_index  k changepoints               formula
    ## 1         1  2            0 gamma ~ newmoonnumber
    ## 2         2  5            0 gamma ~ newmoonnumber
    ## 3         3 16            0 gamma ~ newmoonnumber
    ## 4         4  2            0             gamma ~ 1
    ## 5         5  5            0             gamma ~ 1
    ## 6         6 16            0             gamma ~ 1
    ## 7         7  2            1 gamma ~ newmoonnumber
    ## 8         8  5            1 gamma ~ newmoonnumber
    ## 9         9 16            1 gamma ~ newmoonnumber
    ## 10       10  2            1             gamma ~ 1
    ## 11       11  5            1             gamma ~ 1
    ## 12       12 16            1             gamma ~ 1

``` r
close_models <- model_aiccs %>%
    dplyr::group_by(ts_names) %>%
    dplyr::summarize(mean_aicc = mean(AICc),
                     sd_aicc = sd(AICc)) %>% 
    dplyr::ungroup() %>%
    dplyr::mutate(mean_AICc_close = 2 >= (mean_aicc - min(mean_aicc))) %>%
    dplyr::filter(mean_AICc_close) %>%
    dplyr::mutate(AICc_ismin = mean_aicc == min(mean_aicc)) %>%
    dplyr::arrange(dplyr::desc(AICc_ismin))

close_models
```

    ## # A tibble: 1 x 5
    ##   ts_names                     mean_aicc sd_aicc mean_AICc_close AICc_ismin
    ##   <chr>                            <dbl>   <dbl> <lgl>           <lgl>     
    ## 1 k: 16, seed: 2, gamma ~ new…    17853.    390. TRUE            TRUE

``` r
plot(ldas[[ model_aiccs$lda_index[which(model_aiccs$ts_names == close_models$ts_names[1])][1] ]])
```

![](full_likelihood_files/figure-markdown_github/plot%20selected%20model-1.png)

``` r
plot(ts_fits[[model_aiccs$ts_index[which(model_aiccs$ts_names == close_models$ts_names[1])][1]]])
```

![](full_likelihood_files/figure-markdown_github/plot%20selected%20model-2.png)

Compared to results using select functions (which would have found k = 5, gamma ~ newmoonnumber, and 1 changepoint):

``` r
lda_select <- select_LDA(ldas)

ts_options <- ts_fits[ ts_index_summary$ts_index[which(as.integer(ts_index_summary$k) == lda_select[[1]]@k)]]

ts_aiccs <- vapply(ts_options, FUN = AICc, FUN.VALUE = 101)

ts_aiccs
```

    ## k: 5, seed: 2, gamma ~ newmoonnumber, 0 changepoints 
    ##                                             963.5505 
    ##             k: 5, seed: 2, gamma ~ 1, 0 changepoints 
    ##                                            1006.8742 
    ## k: 5, seed: 2, gamma ~ newmoonnumber, 1 changepoints 
    ##                                             904.0769 
    ##             k: 5, seed: 2, gamma ~ 1, 1 changepoints 
    ##                                             941.1748

``` r
ts_selected <- ts_options[[which(ts_aiccs == min(ts_aiccs))]]

plot(lda_select)
```

![](full_likelihood_files/figure-markdown_github/select%20functions-1.png)

``` r
#plot(ts_selected)
ts_selected
```

    ## $formula
    ## gamma ~ newmoonnumber
    ## <environment: 0x7f95edbe5800>
    ## 
    ## $nchangepoints
    ## [1] 1
    ## 
    ## $timename
    ## [1] "newmoonnumber"
    ## 
    ## $ptMCMC_diagnostics
    ## $ptMCMC_diagnostics$step_acceptance_rate
    ## [1] 0.502 0.800 0.912 0.940 0.954 0.973
    ## 
    ## $ptMCMC_diagnostics$swap_acceptance_rate
    ## [1] 0.505 0.655 0.640 0.837 0.903
    ## 
    ## $ptMCMC_diagnostics$trip_counts
    ## [1] 30 29 19 33 31 21
    ## 
    ## $ptMCMC_diagnostics$trip_rates
    ## [1] 0.030 0.029 0.019 0.033 0.031 0.021
    ## 
    ## 
    ## $rho_summary
    ##                 Mean Median Mode Lower_95% Upper_95%    SD MCMCerr   AC10
    ## Changepoint_1 339.17  336.5  374       296       376 32.38  1.0239 0.2629
    ##                   ESS
    ## Changepoint_1 70.5317
    ## 
    ## $eta_summary
    ##                      Mean  Median Lower_95% Upper_95%     SD MCMCerr
    ## 1_2:(Intercept)    7.3524  7.3242    4.0170   11.6447 1.9294  0.0610
    ## 1_2:newmoonnumber -0.0326 -0.0319   -0.0531   -0.0180 0.0089  0.0003
    ## 1_3:(Intercept)    5.3844  5.5587    1.4684    8.4527 1.7661  0.0558
    ## 1_3:newmoonnumber -0.0179 -0.0190   -0.0292   -0.0025 0.0069  0.0002
    ## 1_4:(Intercept)   -3.3207 -2.6070  -10.1835    1.7589 3.2472  0.1027
    ## 1_4:newmoonnumber  0.0123  0.0089   -0.0047    0.0381 0.0119  0.0004
    ## 1_5:(Intercept)    5.3151  5.3412    1.9217    8.6053 1.6907  0.0535
    ## 1_5:newmoonnumber -0.0188 -0.0189   -0.0335   -0.0069 0.0065  0.0002
    ## 2_2:(Intercept)   -2.4598 -2.7344   -9.1762    5.3894 3.6825  0.1165
    ## 2_2:newmoonnumber  0.0027  0.0031   -0.0148    0.0192 0.0086  0.0003
    ## 2_3:(Intercept)   -2.8437 -3.0948   -8.8958    4.5168 3.5028  0.1108
    ## 2_3:newmoonnumber  0.0049  0.0054   -0.0125    0.0185 0.0082  0.0003
    ## 2_4:(Intercept)   11.1054 10.0640    4.1397   20.7275 4.6805  0.1480
    ## 2_4:newmoonnumber -0.0294 -0.0269   -0.0537   -0.0123 0.0115  0.0004
    ## 2_5:(Intercept)    7.7281  5.6391   -1.1146   19.3653 6.0486  0.1913
    ## 2_5:newmoonnumber -0.0210 -0.0166   -0.0494   -0.0001 0.0143  0.0005
    ##                      AC10       ESS
    ## 1_2:(Intercept)   -0.0031 813.42079
    ## 1_2:newmoonnumber  0.0230 557.59705
    ## 1_3:(Intercept)    0.0719 242.72363
    ## 1_3:newmoonnumber  0.0699 207.20676
    ## 1_4:(Intercept)    0.1060 159.82988
    ## 1_4:newmoonnumber  0.1191 153.58301
    ## 1_5:(Intercept)   -0.0135 798.21081
    ## 1_5:newmoonnumber -0.0341 827.38663
    ## 2_2:(Intercept)    0.0630 223.13277
    ## 2_2:newmoonnumber  0.0577 242.69405
    ## 2_3:(Intercept)    0.0687 276.21954
    ## 2_3:newmoonnumber  0.0696 300.73893
    ## 2_4:(Intercept)    0.1767 102.02795
    ## 2_4:newmoonnumber  0.1637 111.32826
    ## 2_5:(Intercept)    0.2217  81.99684
    ## 2_5:newmoonnumber  0.2156  77.84794
    ## 
    ## $logLik
    ## [1] -434.0218
    ## 
    ## $nparams
    ## [1] 17
    ## 
    ## $AIC
    ## [1] 902.0437
