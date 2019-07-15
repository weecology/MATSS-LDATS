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

    ## [1] "lda_select_lda_maizuru_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-1.png)

    ## [1] "lda_select_lda_jornada_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-2.png)

    ## [1] "lda_select_lda_sgs_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-3.png)

    ## [1] "lda_select_lda_cowley_lizards_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-4.png)

    ## [1] "lda_select_lda_cowley_snakes_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-5.png)

    ## [1] "lda_select_lda_karoo_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-6.png)

    ## [1] "lda_select_lda_kruger_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-7.png)

    ## [1] "lda_select_lda_portal_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-8.png)

    ## [1] "lda_select_lda_sdl_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-9.png)

    ## [1] "lda_select_lda_mtquad_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-10.png)

    ## [1] "lda_select_lda_bbs_data_rtrg_1_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-11.png)

    ## [1] "lda_select_lda_bbs_data_rtrg_2_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-12.png)

    ## [1] "lda_select_lda_bbs_data_rtrg_3_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-13.png)

    ## [1] "lda_select_lda_bbs_data_rtrg_4_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-14.png)

    ## [1] "lda_select_lda_bbs_data_rtrg_6_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-15.png)

Summarize LDA results
---------------------

``` r
lda_ts_result_summary <- readd(lda_ts_result_summary, cache = cache)

lda_ts_result_summary
```

    ##                              lda_name ntopics ntimeseries ntimesteps
    ## 1         lda_select_lda_maizuru_data      14          15        285
    ## 2         lda_select_lda_jornada_data       6          17         24
    ## 3             lda_select_lda_sgs_data      13          11         13
    ## 4  lda_select_lda_cowley_lizards_data      14           6         14
    ## 5   lda_select_lda_cowley_snakes_data      14          16         14
    ## 6           lda_select_lda_karoo_data      13          16         13
    ## 7          lda_select_lda_kruger_data      14          12         31
    ## 8          lda_select_lda_portal_data       5          21        319
    ## 9             lda_select_lda_sdl_data       9          98         22
    ## 10         lda_select_lda_mtquad_data      14          42         14
    ## 11  lda_select_lda_bbs_data_rtrg_1_11      12          99         51
    ## 12  lda_select_lda_bbs_data_rtrg_2_11      14         120         51
    ## 13  lda_select_lda_bbs_data_rtrg_3_11      10         115         51
    ## 14  lda_select_lda_bbs_data_rtrg_4_11      14         113         51
    ## 15  lda_select_lda_bbs_data_rtrg_6_11      11          81         40
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
    ##                                                                ts_name
    ## 1                ts_select_ts_maizuru_data_lda_select_lda_maizuru_data
    ## 2                                                                 <NA>
    ## 3                                                                 <NA>
    ## 4  ts_select_ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data
    ## 5    ts_select_ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data
    ## 6                    ts_select_ts_karoo_data_lda_select_lda_karoo_data
    ## 7                  ts_select_ts_kruger_data_lda_select_lda_kruger_data
    ## 8                  ts_select_ts_portal_data_lda_select_lda_portal_data
    ## 9                        ts_select_ts_sdl_data_lda_select_lda_sdl_data
    ## 10                 ts_select_ts_mtquad_data_lda_select_lda_mtquad_data
    ## 11   ts_select_ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11
    ## 12   ts_select_ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11
    ## 13   ts_select_ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11
    ## 14   ts_select_ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11
    ## 15   ts_select_ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11
    ##    nchangepoints               formula
    ## 1              1             gamma ~ 1
    ## 2             NA                  <NA>
    ## 3             NA                  <NA>
    ## 4              0             gamma ~ 1
    ## 5              0             gamma ~ 1
    ## 6              0             gamma ~ 1
    ## 7              0             gamma ~ 1
    ## 8              1 gamma ~ newmoonnumber
    ## 9              0             gamma ~ 1
    ## 10             0             gamma ~ 1
    ## 11             0             gamma ~ 1
    ## 12             0             gamma ~ 1
    ## 13             1             gamma ~ 1
    ## 14             0             gamma ~ 1
    ## 15             0             gamma ~ 1
