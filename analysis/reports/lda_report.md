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
    ## 1         lda_select_lda_maizuru_data       6          15        285
    ## 2         lda_select_lda_jornada_data       6          17         24
    ## 3             lda_select_lda_sgs_data       4          11         13
    ## 4  lda_select_lda_cowley_lizards_data       2           6         14
    ## 5   lda_select_lda_cowley_snakes_data       2          16         14
    ## 6           lda_select_lda_karoo_data       6          16         13
    ## 7          lda_select_lda_kruger_data       6          12         31
    ## 8          lda_select_lda_portal_data       5          21        319
    ## 9             lda_select_lda_sdl_data       6          98         22
    ## 10         lda_select_lda_mtquad_data       6          42         14
    ## 11  lda_select_lda_bbs_data_rtrg_1_11       6          99         51
    ## 12  lda_select_lda_bbs_data_rtrg_2_11       6         120         51
    ## 13  lda_select_lda_bbs_data_rtrg_3_11       6         115         51
    ## 14  lda_select_lda_bbs_data_rtrg_4_11       6         113         51
    ## 15  lda_select_lda_bbs_data_rtrg_6_11       6          81         40
    ##                              data ts_name nchangepoints formula
    ## 1         select_lda_maizuru_data    <NA>            NA    <NA>
    ## 2         select_lda_jornada_data    <NA>            NA    <NA>
    ## 3             select_lda_sgs_data    <NA>            NA    <NA>
    ## 4  select_lda_cowley_lizards_data    <NA>            NA    <NA>
    ## 5   select_lda_cowley_snakes_data    <NA>            NA    <NA>
    ## 6           select_lda_karoo_data    <NA>            NA    <NA>
    ## 7          select_lda_kruger_data    <NA>            NA    <NA>
    ## 8          select_lda_portal_data    <NA>            NA    <NA>
    ## 9             select_lda_sdl_data    <NA>            NA    <NA>
    ## 10         select_lda_mtquad_data    <NA>            NA    <NA>
    ## 11  select_lda_bbs_data_rtrg_1_11    <NA>            NA    <NA>
    ## 12  select_lda_bbs_data_rtrg_2_11    <NA>            NA    <NA>
    ## 13  select_lda_bbs_data_rtrg_3_11    <NA>            NA    <NA>
    ## 14  select_lda_bbs_data_rtrg_4_11    <NA>            NA    <NA>
    ## 15  select_lda_bbs_data_rtrg_6_11    <NA>            NA    <NA>
