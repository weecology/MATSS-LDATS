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

    ## [1] NA
