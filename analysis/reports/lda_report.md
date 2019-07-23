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
lda_ts_result_summary <- readd(lda_ts_result_summary, cache = cache)
```

Errors
------

Find LDAs that threw errors and remove them:

Plot LDAS
---------

<img src="lda_report_files/figure-markdown_github/plot LDA-1.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-2.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-3.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-4.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-5.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-6.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-7.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-8.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-9.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-10.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-11.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-12.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-13.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-14.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-15.png" width="25%" /><img src="lda_report_files/figure-markdown_github/plot LDA-16.png" width="25%" />

Summarize LDA results
---------------------

![](lda_report_files/figure-markdown_github/plot%20lda%20summary-1.png)
