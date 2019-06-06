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

ts_results <- readd(ts_results, cache = cache)

selected_ts_results <- readd(ts_select_results, cache = cache)
```

Errors
------

Find TS models that threw errors while running and remove them:

    ## [1] "ts_jornada_data_lda_jornada_data"
    ## [1] "Incorrect data structure"
    ## [1] "ts_sgs_data_lda_sgs_data"
    ## [1] "Incorrect data structure"

These TS models ran successfully:

    ##  [1] "ts_maizuru_data_lda_maizuru_data"              
    ##  [2] "ts_cowley_lizards_data_lda_cowley_lizards_data"
    ##  [3] "ts_cowley_snakes_data_lda_cowley_snakes_data"  
    ##  [4] "ts_karoo_data_lda_karoo_data"                  
    ##  [5] "ts_kruger_data_lda_kruger_data"                
    ##  [6] "ts_portal_data_lda_portal_data"                
    ##  [7] "ts_sdl_data_lda_sdl_data"                      
    ##  [8] "ts_mtquad_data_lda_mtquad_data"                
    ##  [9] "ts_bbs_data_rtrg_1_11_lda_bbs_data_rtrg_1_11"  
    ## [10] "ts_bbs_data_rtrg_2_11_lda_bbs_data_rtrg_2_11"  
    ## [11] "ts_bbs_data_rtrg_3_11_lda_bbs_data_rtrg_3_11"  
    ## [12] "ts_bbs_data_rtrg_4_11_lda_bbs_data_rtrg_4_11"  
    ## [13] "ts_bbs_data_rtrg_6_11_lda_bbs_data_rtrg_6_11"

Find TS models that threw errors in selection and remove them:

    ## [1] "ts_select_ts_jornada_data_lda_jornada_data"
    ## [1] "Error in LDATS::select_TS(ts_jornada_data_lda_jornada_data) : \n  TS_models must be of class TS_on_LDA\n"
    ## attr(,"class")
    ## [1] "try-error"
    ## attr(,"condition")
    ## <simpleError in LDATS::select_TS(ts_jornada_data_lda_jornada_data): TS_models must be of class TS_on_LDA>
    ## [1] "ts_select_ts_sgs_data_lda_sgs_data"
    ## [1] "Error in LDATS::select_TS(ts_sgs_data_lda_sgs_data) : \n  TS_models must be of class TS_on_LDA\n"
    ## attr(,"class")
    ## [1] "try-error"
    ## attr(,"condition")
    ## <simpleError in LDATS::select_TS(ts_sgs_data_lda_sgs_data): TS_models must be of class TS_on_LDA>

These TS models were selected correctly:

    ##  [1] "ts_select_ts_maizuru_data_lda_maizuru_data"              
    ##  [2] "ts_select_ts_cowley_lizards_data_lda_cowley_lizards_data"
    ##  [3] "ts_select_ts_cowley_snakes_data_lda_cowley_snakes_data"  
    ##  [4] "ts_select_ts_karoo_data_lda_karoo_data"                  
    ##  [5] "ts_select_ts_kruger_data_lda_kruger_data"                
    ##  [6] "ts_select_ts_portal_data_lda_portal_data"                
    ##  [7] "ts_select_ts_sdl_data_lda_sdl_data"                      
    ##  [8] "ts_select_ts_mtquad_data_lda_mtquad_data"                
    ##  [9] "ts_select_ts_bbs_data_rtrg_1_11_lda_bbs_data_rtrg_1_11"  
    ## [10] "ts_select_ts_bbs_data_rtrg_2_11_lda_bbs_data_rtrg_2_11"  
    ## [11] "ts_select_ts_bbs_data_rtrg_3_11_lda_bbs_data_rtrg_3_11"  
    ## [12] "ts_select_ts_bbs_data_rtrg_4_11_lda_bbs_data_rtrg_4_11"  
    ## [13] "ts_select_ts_bbs_data_rtrg_6_11_lda_bbs_data_rtrg_6_11"

Community-level results
-----------------------

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

Cross-community results
-----------------------

``` r
plot(lda_ts_result_summary$ntopics, lda_ts_result_summary$nchangepoints, 
     main = 'Number of changepoints by number of LDA topics', 
     xlab = 'Number of LDA topics', ylab = 'Number of changepoints')
```

![](ts_report_files/figure-markdown_github/plot%20ts%20cross%20comm%20results-1.png)

``` r
plot(lda_ts_result_summary$ntimesteps, lda_ts_result_summary$nchangepoints, 
     main = 'Number of changepoints by length of timeseries', 
     xlab = 'Length of timeseries (number of timesteps)', ylab = 'Number of changepoints')
```

![](ts_report_files/figure-markdown_github/plot%20ts%20cross%20comm%20results-2.png)
