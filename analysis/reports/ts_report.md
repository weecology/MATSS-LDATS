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

    ## [1] "ts_mtquad_data_lda_select_lda_mtquad_data_5"               
    ## [2] "ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5" 
    ## [3] "ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_5" 
    ## [4] "ts_mtquad_data_lda_select_lda_mtquad_data_16"              
    ## [5] "ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_16"
    ## [6] "ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_16"

Find TS models that threw errors in selection and remove them:

These TS models were selected correctly:

    ## [1] "ts_select_ts_mtquad_data_lda_select_lda_mtquad_data_5"               
    ## [2] "ts_select_ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5" 
    ## [3] "ts_select_ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_5" 
    ## [4] "ts_select_ts_mtquad_data_lda_select_lda_mtquad_data_16"              
    ## [5] "ts_select_ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_16"
    ## [6] "ts_select_ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_16"

Community-level results
-----------------------

``` r
lda_ts_result_summary <- readd(lda_ts_result_summary, cache = cache)
lda_ts_result_summary
```

    ##                               lda_name ntopics maxtopics ntimeseries
    ## 1         lda_select_lda_mtquad_data_5       5         5          42
    ## 2  lda_select_lda_bbs_data_rtrg_1_11_5       5         5          99
    ## 3  lda_select_lda_bbs_data_rtrg_2_11_5       5         5         120
    ## 4        lda_select_lda_mtquad_data_16      14        16          42
    ## 5 lda_select_lda_bbs_data_rtrg_1_11_16      12        16          99
    ## 6 lda_select_lda_bbs_data_rtrg_2_11_16      14        16         120
    ##   ntimesteps                  data
    ## 1         14         mtquad_data_5
    ## 2         51  bbs_data_rtrg_1_11_5
    ## 3         51  bbs_data_rtrg_2_11_5
    ## 4         14        mtquad_data_16
    ## 5         51 bbs_data_rtrg_1_11_16
    ## 6         51 bbs_data_rtrg_2_11_16
    ##                                                                ts_name
    ## 1                ts_select_ts_mtquad_data_lda_select_lda_mtquad_data_5
    ## 2  ts_select_ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5
    ## 3  ts_select_ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_5
    ## 4               ts_select_ts_mtquad_data_lda_select_lda_mtquad_data_16
    ## 5 ts_select_ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_16
    ## 6 ts_select_ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_16
    ##   nchangepoints      formula
    ## 1             0 gamma ~ year
    ## 2             0 gamma ~ year
    ## 3             1    gamma ~ 1
    ## 4             0    gamma ~ 1
    ## 5             0    gamma ~ 1
    ## 6             0    gamma ~ 1

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

Detailed model results
----------------------

``` r
#ts_models_summary <- readd(ts_models_summary, cache = cache)

ts_results <- readd(ts_results, cache =cache)
ts_models_summary <- collect_ts_result_models_summary(ts_results)
print(ts_models_summary)
```

    ##                                                       ts_name
    ## 1                 ts_mtquad_data_lda_select_lda_mtquad_data_5
    ## 2                 ts_mtquad_data_lda_select_lda_mtquad_data_5
    ## 3                 ts_mtquad_data_lda_select_lda_mtquad_data_5
    ## 4                 ts_mtquad_data_lda_select_lda_mtquad_data_5
    ## 5   ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5
    ## 6   ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5
    ## 7   ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5
    ## 8   ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5
    ## 9   ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_5
    ## 10  ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_5
    ## 11  ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_5
    ## 12  ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_5
    ## 13               ts_mtquad_data_lda_select_lda_mtquad_data_16
    ## 14               ts_mtquad_data_lda_select_lda_mtquad_data_16
    ## 15               ts_mtquad_data_lda_select_lda_mtquad_data_16
    ## 16               ts_mtquad_data_lda_select_lda_mtquad_data_16
    ## 17 ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_16
    ## 18 ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_16
    ## 19 ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_16
    ## 20 ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_16
    ## 21 ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_16
    ## 22 ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_16
    ## 23 ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_16
    ## 24 ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_16
    ##    nchangepoints      formula              AIC
    ## 1              0 gamma ~ year 45.1885461895395
    ## 2              0    gamma ~ 1 49.1690552038468
    ## 3              1 gamma ~ year 56.9814581796757
    ## 4              1    gamma ~ 1 52.0352728246574
    ## 5              0 gamma ~ year 146.754110474832
    ## 6              0    gamma ~ 1 168.853711874109
    ## 7              1 gamma ~ year 156.206551124165
    ## 8              1    gamma ~ 1 153.432995077975
    ## 9              0 gamma ~ year 169.507781310335
    ## 10             0    gamma ~ 1 171.169001369409
    ## 11             1 gamma ~ year 173.910085307762
    ## 12             1    gamma ~ 1 167.429651324665
    ## 13             0 gamma ~ year 87.1827182320061
    ## 14             0    gamma ~ 1 70.8076353913618
    ## 15             1 gamma ~ year 135.927890705136
    ## 16             1    gamma ~ 1 92.7092348908269
    ## 17             0 gamma ~ year 260.754431324107
    ## 18             0    gamma ~ 1 259.202306757965
    ## 19             1 gamma ~ year 288.948372638779
    ## 20             1    gamma ~ 1 259.263527697591
    ## 21             0 gamma ~ year 316.069215166655
    ## 22             0    gamma ~ 1 290.094886665959
    ## 23             1 gamma ~ year 325.268913569554
    ## 24             1    gamma ~ 1 293.703102356621
