LDA report
================
Renata Diaz
10/12/2018

Read in the results
-------------------

``` r
# define where the cache is located
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("drake", "drake-cache.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)

lda_results <- readd(lda_results, cache = cache)
```

Errors
------

Find LDAs that threw errors and remove them:

Plot LDAS
---------

Plot a maximum of 15.

    ## [1] "lda_select_lda_mtquad_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-1.png)

    ## [1] "lda_select_lda_bbs_data_rtrg_1_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-2.png)

    ## [1] "lda_select_lda_bbs_data_rtrg_2_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-3.png)

Summarize LDA results
---------------------

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
