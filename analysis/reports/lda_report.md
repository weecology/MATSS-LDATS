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

    ## [1] "lda_portal_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-1.png)

    ## [1] "lda_sdl_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-2.png)

    ## [1] "lda_mtquad_data"

![](lda_report_files/figure-markdown_github/plot%20LDA-3.png)

    ## [1] "lda_bbs_data_rtrg_1_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-4.png)

    ## [1] "lda_bbs_data_rtrg_2_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-5.png)

    ## [1] "lda_bbs_data_rtrg_3_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-6.png)

    ## [1] "lda_bbs_data_rtrg_4_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-7.png)

    ## [1] "lda_bbs_data_rtrg_6_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-8.png)

    ## [1] "lda_bbs_data_rtrg_7_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-9.png)

    ## [1] "lda_bbs_data_rtrg_8_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-10.png)

    ## [1] "lda_bbs_data_rtrg_9_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-11.png)

    ## [1] "lda_bbs_data_rtrg_10_10"

![](lda_report_files/figure-markdown_github/plot%20LDA-12.png)

    ## [1] "lda_bbs_data_rtrg_11_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-13.png)

    ## [1] "lda_bbs_data_rtrg_12_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-14.png)

    ## [1] "lda_bbs_data_rtrg_13_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-15.png)

    ## [1] "lda_bbs_data_rtrg_14_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-16.png)

    ## [1] "lda_bbs_data_rtrg_15_6"

![](lda_report_files/figure-markdown_github/plot%20LDA-17.png)

    ## [1] "lda_bbs_data_rtrg_16_10"

![](lda_report_files/figure-markdown_github/plot%20LDA-18.png)

    ## [1] "lda_bbs_data_rtrg_17_10"

![](lda_report_files/figure-markdown_github/plot%20LDA-19.png)

    ## [1] "lda_bbs_data_rtrg_18_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-20.png)

    ## [1] "lda_bbs_data_rtrg_19_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-21.png)

    ## [1] "lda_bbs_data_rtrg_20_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-22.png)

    ## [1] "lda_bbs_data_rtrg_21_11"

![](lda_report_files/figure-markdown_github/plot%20LDA-23.png)

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

    ##         names(lda_results) ntopics ntimeseries ntimesteps
    ## 1          lda_portal_data       3          21        295
    ## 2             lda_sdl_data       3          98         22
    ## 3          lda_mtquad_data       3          42         14
    ## 4   lda_bbs_data_rtrg_1_11       3          99         51
    ## 5   lda_bbs_data_rtrg_2_11       3         120         51
    ## 6   lda_bbs_data_rtrg_3_11       3         115         51
    ## 7   lda_bbs_data_rtrg_4_11       3         113         51
    ## 8   lda_bbs_data_rtrg_6_11       3          81         40
    ## 9   lda_bbs_data_rtrg_7_11       3         123         50
    ## 10  lda_bbs_data_rtrg_8_11       3         107         45
    ## 11  lda_bbs_data_rtrg_9_11       3         117         51
    ## 12 lda_bbs_data_rtrg_10_10       3         132         42
    ## 13 lda_bbs_data_rtrg_11_11       3         116         50
    ## 14 lda_bbs_data_rtrg_12_11       3         111         51
    ## 15 lda_bbs_data_rtrg_13_11       3         123         51
    ## 16 lda_bbs_data_rtrg_14_11       3         122         51
    ## 17  lda_bbs_data_rtrg_15_6       3         102         35
    ## 18 lda_bbs_data_rtrg_16_10       3         134         36
    ## 19 lda_bbs_data_rtrg_17_10       3         129         46
    ## 20 lda_bbs_data_rtrg_18_11       3         111         51
    ## 21 lda_bbs_data_rtrg_19_11       3         119         51
    ## 22 lda_bbs_data_rtrg_20_11       3         126         50
    ## 23 lda_bbs_data_rtrg_21_11       3         106         45

![](lda_report_files/figure-markdown_github/plot%20lda%20summary-1.png)![](lda_report_files/figure-markdown_github/plot%20lda%20summary-2.png)
