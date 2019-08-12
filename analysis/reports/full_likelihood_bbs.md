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
dat1 <- get_bbs_route_region_data(route = 1, region = 11, path = get_default_data_path())


ldas <- LDA_set(dat1$abundance, topics = c(2, 5, 16), nseeds = 1)

ts_fits <- run_TS(dat1, ldas, formulas = c("intercept", "time"), 
                  nchangepoints = c(0, 1), weighting = "proportional")

save(dat1, ldas, ts_fits, file = here::here("analysis", "reports", "full_ldats_likelihood_stash", "models_bbs_1_11.RData"))
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

![](full_likelihood_bbs_files/figure-markdown_github/plot%20AICcs-1.png)

``` r
ts_index_summary <- model_aiccs %>%
    dplyr::select(ts_index, k, changepoints, formula) %>%
    dplyr::distinct()

ts_index_summary
```

    ##    ts_index  k changepoints      formula
    ## 1         1  2            0 gamma ~ year
    ## 2         2  5            0 gamma ~ year
    ## 3         3 16            0 gamma ~ year
    ## 4         4  2            0    gamma ~ 1
    ## 5         5  5            0    gamma ~ 1
    ## 6         6 16            0    gamma ~ 1
    ## 7         7  2            1 gamma ~ year
    ## 8         8  5            1 gamma ~ year
    ## 9         9 16            1 gamma ~ year
    ## 10       10  2            1    gamma ~ 1
    ## 11       11  5            1    gamma ~ 1
    ## 12       12 16            1    gamma ~ 1

``` r
close_models <- model_aiccs %>%
    dplyr::mutate(AICc_close = 2 >= (AICc - min(AICc))) %>%
    dplyr::filter(AICc_close) %>%
    dplyr::mutate(AICc_ismin = AICc == min(AICc)) %>%
    dplyr::arrange(dplyr::desc(AICc_ismin))

close_models
```

    ##                                       ts_names    AICc ts_index  k seed
    ## 1 k: 16, seed: 2, gamma ~ year, 0 changepoints 36753.1        3 16    2
    ##        formula changepoints       lda_name lda_index AICc_close AICc_ismin
    ## 1 gamma ~ year            0 k: 16, seed: 2         3       TRUE       TRUE

``` r
plot(ldas[[close_models$lda_index[1]]])
```

![](full_likelihood_bbs_files/figure-markdown_github/plot%20selected%20model-1.png)

``` r
plot(ts_fits[[close_models$ts_index[1]]])
```

![](full_likelihood_bbs_files/figure-markdown_github/plot%20selected%20model-2.png)

The select functions would have found the same.

``` r
lda_select <- select_LDA(ldas)

ts_options <- ts_fits[ ts_index_summary$ts_index[which(as.integer(ts_index_summary$k) == lda_select[[1]]@k)]]

ts_aiccs <- vapply(ts_options, FUN = AICc, FUN.VALUE = 101)

ts_aiccs

ts_selected <- ts_options[[which(ts_aiccs == min(ts_aiccs))]]

plot(lda_select)
plot(ts_selected)
```
