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

Plot a maximum of 10.

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

Summarize LDA results
---------------------

``` r
lda_ts_result_summary <- readd(lda_ts_result_summary, cache = cache)

lda_ts_result_summary
```

    ##                   lda_name ntopics ntimeseries ntimesteps
    ## 1         lda_maizuru_data       3          15        285
    ## 2         lda_jornada_data       3          17         24
    ## 3             lda_sgs_data       3          11         13
    ## 4  lda_cowley_lizards_data       2           6         14
    ## 5   lda_cowley_snakes_data       2          16         14
    ## 6           lda_karoo_data       3          16         13
    ## 7          lda_kruger_data       3          12         31
    ## 8          lda_portal_data       3          21        319
    ## 9             lda_sdl_data       3          98         22
    ## 10         lda_mtquad_data       3          42         14
    ## 11  lda_bbs_data_rtrg_1_11       3          99         51
    ## 12  lda_bbs_data_rtrg_2_11       3         120         51
    ## 13  lda_bbs_data_rtrg_3_11       3         115         51
    ## 14  lda_bbs_data_rtrg_4_11       3         113         51
    ## 15  lda_bbs_data_rtrg_6_11       3          81         40
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
    ## 1                ts_select_ts_maizuru_data_lda_maizuru_data             2
    ## 2                ts_select_ts_jornada_data_lda_jornada_data            NA
    ## 3                        ts_select_ts_sgs_data_lda_sgs_data            NA
    ## 4  ts_select_ts_cowley_lizards_data_lda_cowley_lizards_data             2
    ## 5    ts_select_ts_cowley_snakes_data_lda_cowley_snakes_data             2
    ## 6                    ts_select_ts_karoo_data_lda_karoo_data             2
    ## 7                  ts_select_ts_kruger_data_lda_kruger_data             2
    ## 8                  ts_select_ts_portal_data_lda_portal_data             2
    ## 9                        ts_select_ts_sdl_data_lda_sdl_data             2
    ## 10                 ts_select_ts_mtquad_data_lda_mtquad_data             2
    ## 11   ts_select_ts_bbs_data_rtrg_1_11_lda_bbs_data_rtrg_1_11             2
    ## 12   ts_select_ts_bbs_data_rtrg_2_11_lda_bbs_data_rtrg_2_11             2
    ## 13   ts_select_ts_bbs_data_rtrg_3_11_lda_bbs_data_rtrg_3_11             2
    ## 14   ts_select_ts_bbs_data_rtrg_4_11_lda_bbs_data_rtrg_4_11             2
    ## 15   ts_select_ts_bbs_data_rtrg_6_11_lda_bbs_data_rtrg_6_11             2

![](lda_report_files/figure-markdown_github/plot%20lda%20summary-1.png)![](lda_report_files/figure-markdown_github/plot%20lda%20summary-2.png)
