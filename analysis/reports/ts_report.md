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
    ## [3] "ts_mtquad_data_lda_mtquad_data"

Find TS models that threw errors in selection and remove them:

These TS models were selected correctly:

    ## [1] "ts_select_ts_portal_data_lda_portal_data"
    ## [2] "ts_select_ts_sdl_data_lda_sdl_data"      
    ## [3] "ts_select_ts_mtquad_data_lda_mtquad_data"

Community-level results
-----------------------

``` r
lda_ts_result_summary <- readd(lda_ts_result_summary, cache = cache)
lda_ts_result_summary
```

    ##          lda_name ntopics ntimeseries ntimesteps        data
    ## 1 lda_portal_data       3          21        295 portal_data
    ## 2    lda_sdl_data       3          98         22    sdl_data
    ## 3 lda_mtquad_data       3          42         14 mtquad_data
    ##                                    ts_name nchangepoints
    ## 1 ts_select_ts_portal_data_lda_portal_data             2
    ## 2       ts_select_ts_sdl_data_lda_sdl_data             2
    ## 3 ts_select_ts_mtquad_data_lda_mtquad_data             2

Cross-community results
-----------------------

``` r
plot(lda_ts_result_summary$ntopics, lda_ts_result_summary$nchangepoints, 
     main = 'Number of changepoints by number of LDA topics', 
     xlab = 'Number of LDA topics', ylab = 'Number of changepoints')
```

![](ts_report_files/figure-markdown_github/plot%20ts%20cross%20comm%20results-1.png)

``` r
plot(lda_ts_result_summary$ntimesteps, lda_ts_result_summary$nchangepoints, 
     main = 'Number of changepoints by length of timeseries', 
     xlab = 'Length of timeseries (number of timesteps)', ylab = 'Number of changepoints')
```

![](ts_report_files/figure-markdown_github/plot%20ts%20cross%20comm%20results-2.png)
