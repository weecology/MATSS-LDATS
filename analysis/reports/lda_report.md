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

    ## [1] "lda_maizuru_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-1.png)

    ## [1] "lda_jornada_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-2.png)

    ## [1] "lda_sgs_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-3.png)

    ## [1] "lda_cowley_lizards_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-4.png)

    ## [1] "lda_cowley_snakes_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-5.png)

    ## [1] "lda_karoo_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-6.png)

    ## [1] "lda_kruger_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-7.png)

    ## [1] "lda_portal_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-8.png)

    ## [1] "lda_sdl_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-9.png)

    ## [1] "lda_mtquad_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-10.png)

    ## [1] "lda_bbs_data_rtrg_1_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-11.png)

    ## [1] "lda_bbs_data_rtrg_2_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-12.png)

    ## [1] "lda_bbs_data_rtrg_3_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-13.png)

    ## [1] "lda_bbs_data_rtrg_4_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-14.png)

    ## [1] "lda_bbs_data_rtrg_6_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-15.png)

Summarize LDA results
---------------------

``` r
lda_ts_result_summary <- readd(lda_ts_result_summary, cache = cache)

lda_ts_result_summary
```

    ##                   lda_name ntopics ntimeseries ntimesteps
    ## 1         lda_maizuru_data       6          15        285
    ## 2         lda_jornada_data       6          17         24
    ## 3             lda_sgs_data       6          11         13
    ## 4  lda_cowley_lizards_data       2           6         14
    ## 5   lda_cowley_snakes_data       2          16         14
    ## 6           lda_karoo_data       6          16         13
    ## 7          lda_kruger_data       6          12         31
    ## 8          lda_portal_data       5          21        319
    ## 9             lda_sdl_data       6          98         22
    ## 10         lda_mtquad_data       6          42         14
    ## 11  lda_bbs_data_rtrg_1_11       6          99         51
    ## 12  lda_bbs_data_rtrg_2_11       6         120         51
    ## 13  lda_bbs_data_rtrg_3_11       6         115         51
    ## 14  lda_bbs_data_rtrg_4_11       6         113         51
    ## 15  lda_bbs_data_rtrg_6_11       6          81         40
    ##                   data
    ## 1         maizuru_data
    ## 2         jornada_data
    ## 3             sgs_data
    ## 4  cowley_lizards_data
    ## 5   cowley_snakes_data
    ## 6           karoo_data
    ## 7          kruger_data
    ## 8          portal_data
    ## 9             sdl_data
    ## 10         mtquad_data
    ## 11  bbs_data_rtrg_1_11
    ## 12  bbs_data_rtrg_2_11
    ## 13  bbs_data_rtrg_3_11
    ## 14  bbs_data_rtrg_4_11
    ## 15  bbs_data_rtrg_6_11
    ##                                                     ts_name nchangepoints
    ## 1                ts_select_ts_maizuru_data_lda_maizuru_data             1
    ## 2                                                      <NA>            NA
    ## 3                                                      <NA>            NA
    ## 4  ts_select_ts_cowley_lizards_data_lda_cowley_lizards_data             0
    ## 5    ts_select_ts_cowley_snakes_data_lda_cowley_snakes_data             0
    ## 6                    ts_select_ts_karoo_data_lda_karoo_data             0
    ## 7                  ts_select_ts_kruger_data_lda_kruger_data             0
    ## 8                  ts_select_ts_portal_data_lda_portal_data             2
    ## 9                        ts_select_ts_sdl_data_lda_sdl_data             1
    ## 10                 ts_select_ts_mtquad_data_lda_mtquad_data             0
    ## 11   ts_select_ts_bbs_data_rtrg_1_11_lda_bbs_data_rtrg_1_11             0
    ## 12   ts_select_ts_bbs_data_rtrg_2_11_lda_bbs_data_rtrg_2_11             1
    ## 13   ts_select_ts_bbs_data_rtrg_3_11_lda_bbs_data_rtrg_3_11             0
    ## 14   ts_select_ts_bbs_data_rtrg_4_11_lda_bbs_data_rtrg_4_11             0
    ## 15   ts_select_ts_bbs_data_rtrg_6_11_lda_bbs_data_rtrg_6_11             0
    ##                  formula
    ## 1           gamma ~ Date
    ## 2                   <NA>
    ## 3                   <NA>
    ## 4              gamma ~ 1
    ## 5              gamma ~ 1
    ## 6              gamma ~ 1
    ## 7              gamma ~ 1
    ## 8  gamma ~ newmoonnumber
    ## 9              gamma ~ 1
    ## 10          gamma ~ year
    ## 11          gamma ~ year
    ## 12             gamma ~ 1
    ## 13          gamma ~ year
    ## 14          gamma ~ year
    ## 15             gamma ~ 1

![](lda_report_files/figure-markdown_github/plot%20lda%20summary-1.png)![](lda_report_files/figure-markdown_github/plot%20lda%20summary-2.png)
