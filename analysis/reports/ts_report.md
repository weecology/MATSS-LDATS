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

Find TS models that threw errors and remove them:

    ## [1] "ts_bbs_data_rtrg_3_11_lda_bbs_data_rtrg_3_11"

Find TS models that threw errors in selection and remove them:

    ## [1] "ts_select_ts_bbs_data_rtrg_3_11_lda_bbs_data_rtrg_3_11"
