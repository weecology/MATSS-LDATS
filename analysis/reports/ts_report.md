TS on LDA report
================
Renata Diaz
10/12/2018

Read in the results
-------------------

``` r
# define where the cache is located
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("drake", "drake-cache.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)

ts_results <- readd(ts_results, cache = cache)

selected_ts_results <- readd(ts_select_results, cache = cache)
```

Errors
------

Find TS models that threw errors while running and remove them:

    ## [1] "ts_jornada_data_lda_jornada_data"
    ## [1] "Incorrect data structure"

These TS models ran successfully:

    ## [1] "ts_maizuru_data_lda_maizuru_data"            
    ## [2] "ts_bbs_data_rtrg_4_11_lda_bbs_data_rtrg_4_11"

Find TS models that threw errors in selection and remove them:

    ## [1] "ts_select_ts_jornada_data_lda_jornada_data"
    ## [1] "Incorrect input structure"

These TS models were selected correctly:

    ## [1] "ts_select_ts_maizuru_data_lda_maizuru_data"            
    ## [2] "ts_select_ts_bbs_data_rtrg_4_11_lda_bbs_data_rtrg_4_11"

Community-level results
-----------------------

``` r
# Number of changepoints

for(i in seq(selected_ts_results)) {
    this_ts = selected_ts_results[[i]]
    # Number of changepoints
    print(names(selected_ts_results)[i])
    print('# Changepoints:')
    print(this_ts$nchangepoints)
    
    # Summary of timesteps (newmoon values) for each changepoint
    print('Timesteps for changepoints:')
    print(this_ts$rho_summary)
}
```

    ## [1] "ts_select_ts_maizuru_data_lda_maizuru_data"
    ## [1] "# Changepoints:"
    ## [1] 3
    ## [1] "Timesteps for changepoints:"
    ##                   Mean Median  Mode Lower_95% Upper_95%     SD MCMCerr
    ## Changepoint_1 13271.42  13274 13271     13237     13295  15.02   1.502
    ## Changepoint_2 13335.85  13321 13389     13283     13407  42.68   4.268
    ## Changepoint_3 14595.64  14465 14465     14428     15365 323.96  32.396
    ##                  AC10       ESS
    ## Changepoint_1 -0.0093 31.195564
    ## Changepoint_2  0.5676  2.398717
    ## Changepoint_3  0.0017 40.783431
    ## [1] "ts_select_ts_bbs_data_rtrg_4_11_lda_bbs_data_rtrg_4_11"
    ## [1] "# Changepoints:"
    ## [1] 2
    ## [1] "Timesteps for changepoints:"
    ##                  Mean Median Mode Lower_95% Upper_95%   SD MCMCerr   AC10
    ## Changepoint_1 1987.71 1989.5 1990      1970      1999 8.22   0.822 0.0331
    ## Changepoint_2 2005.25 2006.5 2012      1991      2016 7.48   0.748 0.0818
    ##                    ESS
    ## Changepoint_1 55.60037
    ## Changepoint_2 39.80004

Cross-community results
-----------------------
