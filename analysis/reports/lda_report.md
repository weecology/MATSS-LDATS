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

    ## [1] "lda_select_lda_mtquad_data_5"

![](lda_report_files/figure-markdown_github/plot%20LDA-1.png)

    ## [1] "lda_select_lda_bbs_data_rtrg_1_11_5"

![](lda_report_files/figure-markdown_github/plot%20LDA-2.png)

    ## [1] "lda_select_lda_bbs_data_rtrg_2_11_5"

![](lda_report_files/figure-markdown_github/plot%20LDA-3.png)

    ## [1] "lda_select_lda_mtquad_data_16"

![](lda_report_files/figure-markdown_github/plot%20LDA-4.png)

    ## [1] "lda_select_lda_bbs_data_rtrg_1_11_16"

![](lda_report_files/figure-markdown_github/plot%20LDA-5.png)

    ## [1] "lda_select_lda_bbs_data_rtrg_2_11_16"

![](lda_report_files/figure-markdown_github/plot%20LDA-6.png)

Summarize LDA results
---------------------

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
