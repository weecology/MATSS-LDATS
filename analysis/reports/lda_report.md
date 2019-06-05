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

Plot a maximum of 5.

    ## [1] "lda_jornada_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-1.png)

    ## [1] "lda_sdl_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-2.png)

Summarize LDA results
---------------------

``` r
lda_ts_result_summary <- readd(lda_ts_result_summary, cache = cache)

lda_ts_result_summary
```

    ##           lda_name ntopics ntimeseries ntimesteps         data
    ## 1 lda_jornada_data       3          17         24 jornada_data
    ## 2     lda_sdl_data       3          98         22     sdl_data
    ##                                      ts_name nchangepoints
    ## 1 ts_select_ts_jornada_data_lda_jornada_data            NA
    ## 2         ts_select_ts_sdl_data_lda_sdl_data             2

![](lda_report_files/figure-markdown_github/plot%20lda%20summary-1.png)![](lda_report_files/figure-markdown_github/plot%20lda%20summary-2.png)
