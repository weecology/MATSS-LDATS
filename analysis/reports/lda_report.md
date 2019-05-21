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

    ## [1] "lda_maizuru_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-1.png)

    ## [1] "lda_jornada_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-2.png)

    ## [1] "lda_sgs_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-3.png)

    ## [1] "lda_karoo_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-4.png)

    ## [1] "lda_kruger_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-5.png)

    ## [1] "lda_portal_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-6.png)

    ## [1] "lda_sdl_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-7.png)

    ## [1] "lda_mtquad_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-8.png)

    ## [1] "lda_bbs_data_rtrg_1_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-9.png)

    ## [1] "lda_bbs_data_rtrg_2_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-10.png)

    ## [1] "lda_bbs_data_rtrg_3_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-11.png)

    ## [1] "lda_bbs_data_rtrg_4_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-12.png)

    ## [1] "lda_bbs_data_rtrg_6_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-13.png)

Summarize LDA results
---------------------

``` r
lda_summary <- as.data.frame(names(lda_results))
lda_summary$ntopics <- NA
lda_summary$ntimeseries <- NA
lda_summary$ntimesteps <- NA

for (i in seq(lda_results))
{
    lda_summary$ntopics[i] <- lda_results[[i]][1]$k@k
    lda_summary$ntimeseries[i] <- as.integer(length(lda_results[[i]][1]$k@terms))
    lda_summary$ntimesteps[i] <- lda_results[[i]][1]$k@wordassignments$nrow
}

lda_summary
```

    ##        names(lda_results) ntopics ntimeseries ntimesteps
    ## 1        lda_maizuru_data       3          15        285
    ## 2        lda_jornada_data       3          17         24
    ## 3            lda_sgs_data       3          11         13
    ## 4          lda_karoo_data       3          16         13
    ## 5         lda_kruger_data       3          12         31
    ## 6         lda_portal_data       3          21        295
    ## 7            lda_sdl_data       3          98         22
    ## 8         lda_mtquad_data       3          42         14
    ## 9  lda_bbs_data_rtrg_1_11       3         192         51
    ## 10 lda_bbs_data_rtrg_2_11       3         192         51
    ## 11 lda_bbs_data_rtrg_3_11       3         192         51
    ## 12 lda_bbs_data_rtrg_4_11       3         192         51
    ## 13 lda_bbs_data_rtrg_6_11       3         192         51

![](lda_report_files/figure-markdown_github/plot%20lda%20summary-1.png)![](lda_report_files/figure-markdown_github/plot%20lda%20summary-2.png)
