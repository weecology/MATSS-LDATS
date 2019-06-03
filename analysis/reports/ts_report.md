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

These TS models ran successfully:

    ## [1] "ts_portal_data_lda_portal_data" "ts_sdl_data_lda_sdl_data"

Find TS models that threw errors in selection and remove them:

    ## [1] "ts_select_ts_portal_data_lda_portal_data"
    ## [1] "Incorrect input structure"
    ## [1] "ts_select_ts_sdl_data_lda_sdl_data"
    ## [1] "Incorrect input structure"

These TS models were selected correctly:

    ## character(0)

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

Cross-community results
-----------------------
