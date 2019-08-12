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

ldas <- LDA_set(dat1$abundance, topics = c(2, 5), nseeds = 1)

ts_fits <- run_TS(dat1, ldas, formulas = c("intercept", "time"), 
                  nchangepoints = c(0, 1), weighting = "proportional")

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

    ##   ts_index k changepoints               formula
    ## 1        1 2            0 gamma ~ newmoonnumber
    ## 2        2 5            0 gamma ~ newmoonnumber
    ## 3        3 2            0             gamma ~ 1
    ## 4        4 5            0             gamma ~ 1
    ## 5        5 2            1 gamma ~ newmoonnumber
    ## 6        6 5            1 gamma ~ newmoonnumber
    ## 7        7 2            1             gamma ~ 1
    ## 8        8 5            1             gamma ~ 1

``` r
close_models <- model_aiccs %>%
    dplyr::mutate(AICc_close = 2 >= (AICc - min(AICc))) %>%
    dplyr::filter(AICc_close) %>%
    dplyr::mutate(AICc_ismin = AICc == min(AICc)) %>%
    dplyr::arrange(dplyr::desc(AICc_ismin))

close_models
```

    ##                                               ts_names     AICc ts_index k
    ## 1 k: 2, seed: 2, gamma ~ newmoonnumber, 1 changepoints 20121.77        5 2
    ## 2 k: 2, seed: 2, gamma ~ newmoonnumber, 1 changepoints 20122.80        5 2
    ## 3 k: 2, seed: 2, gamma ~ newmoonnumber, 1 changepoints 20123.40        5 2
    ## 4 k: 2, seed: 2, gamma ~ newmoonnumber, 1 changepoints 20122.55        5 2
    ##   seed               formula changepoints      lda_name lda_index
    ## 1    2 gamma ~ newmoonnumber            1 k: 2, seed: 2         1
    ## 2    2 gamma ~ newmoonnumber            1 k: 2, seed: 2         1
    ## 3    2 gamma ~ newmoonnumber            1 k: 2, seed: 2         1
    ## 4    2 gamma ~ newmoonnumber            1 k: 2, seed: 2         1
    ##   AICc_close AICc_ismin
    ## 1       TRUE       TRUE
    ## 2       TRUE      FALSE
    ## 3       TRUE      FALSE
    ## 4       TRUE      FALSE
