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

    ## [1] "ts_mtquad_data_lda_select_lda_mtquad_data"              
    ## [2] "ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11"
    ## [3] "ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11"

Find TS models that threw errors in selection and remove them:

These TS models were selected correctly:

    ## [1] "ts_select_ts_mtquad_data_lda_select_lda_mtquad_data"              
    ## [2] "ts_select_ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11"
    ## [3] "ts_select_ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11"

Community-level results
-----------------------

``` r
lda_ts_result_summary <- readd(lda_ts_result_summary, cache = cache)
lda_ts_result_summary
```

    ##                            lda_name ntopics ntimeseries ntimesteps
    ## 1        lda_select_lda_mtquad_data       3          42         14
    ## 2 lda_select_lda_bbs_data_rtrg_1_11       3          99         51
    ## 3 lda_select_lda_bbs_data_rtrg_2_11       3         120         51
    ##                 data
    ## 1        mtquad_data
    ## 2 bbs_data_rtrg_1_11
    ## 3 bbs_data_rtrg_2_11
    ##                                                             ts_name
    ## 1               ts_select_ts_mtquad_data_lda_select_lda_mtquad_data
    ## 2 ts_select_ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11
    ## 3 ts_select_ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11
    ##   nchangepoints      formula
    ## 1             0    gamma ~ 1
    ## 2             0 gamma ~ year
    ## 3             0 gamma ~ year

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
