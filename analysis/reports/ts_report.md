TS on LDA report
================
Renata Diaz
10/12/2018

Read in the results
-------------------

``` r
# define where the cache is located
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("drake", "drake-cache.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)

ts_results <- readd(results_ts, cache = cache)
```

Errors
------

Find TS models that threw errors and remove them:

    ## [1] "analysis_ts_jornada_data_analysis_lda_jornada_data"
    ## [1] "Incorrect data structure"
    ## [1] "analysis_ts_sgs_data_analysis_lda_sgs_data"
    ## [1] "Incorrect data structure"
    ## [1] "analysis_ts_bbs_data_analysis_lda_bbs_data"
    ## [1] "Incorrect data structure"

    ## [1] "analysis_ts_maizuru_data_analysis_lda_maizuru_data"
    ## [2] "analysis_ts_portal_data_analysis_lda_portal_data"  
    ## [3] "analysis_ts_sdl_data_analysis_lda_sdl_data"        
    ## [4] "analysis_ts_mtquad_data_analysis_lda_mtquad_data"
