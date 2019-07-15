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

    ## [1] "ts_jornada_data_lda_select_lda_jornada_data"
    ## [1] "Incorrect data structure"
    ## [1] "ts_sgs_data_lda_select_lda_sgs_data"
    ## [1] "Incorrect data structure"

These TS models ran successfully:

    ##  [1] "ts_maizuru_data_lda_select_lda_maizuru_data"              
    ##  [2] "ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data"
    ##  [3] "ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data"  
    ##  [4] "ts_karoo_data_lda_select_lda_karoo_data"                  
    ##  [5] "ts_kruger_data_lda_select_lda_kruger_data"                
    ##  [6] "ts_portal_data_lda_select_lda_portal_data"                
    ##  [7] "ts_sdl_data_lda_select_lda_sdl_data"                      
    ##  [8] "ts_mtquad_data_lda_select_lda_mtquad_data"                
    ##  [9] "ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11"  
    ## [10] "ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11"  
    ## [11] "ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11"  
    ## [12] "ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11"  
    ## [13] "ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11"

Find TS models that threw errors in selection and remove them:

    ## [1] "ts_select_ts_jornada_data_lda_select_lda_jornada_data"
    ## [1] "Error in LDATS::select_TS(ts_jornada_data_lda_select_lda_jornada_data) : \n  TS_models must be of class TS_on_LDA\n"
    ## attr(,"class")
    ## [1] "try-error"
    ## attr(,"condition")
    ## <simpleError in LDATS::select_TS(ts_jornada_data_lda_select_lda_jornada_data): TS_models must be of class TS_on_LDA>
    ## [1] "ts_select_ts_sgs_data_lda_select_lda_sgs_data"
    ## [1] "Error in LDATS::select_TS(ts_sgs_data_lda_select_lda_sgs_data) : \n  TS_models must be of class TS_on_LDA\n"
    ## attr(,"class")
    ## [1] "try-error"
    ## attr(,"condition")
    ## <simpleError in LDATS::select_TS(ts_sgs_data_lda_select_lda_sgs_data): TS_models must be of class TS_on_LDA>

These TS models were selected correctly:

    ##  [1] "ts_select_ts_maizuru_data_lda_select_lda_maizuru_data"              
    ##  [2] "ts_select_ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data"
    ##  [3] "ts_select_ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data"  
    ##  [4] "ts_select_ts_karoo_data_lda_select_lda_karoo_data"                  
    ##  [5] "ts_select_ts_kruger_data_lda_select_lda_kruger_data"                
    ##  [6] "ts_select_ts_portal_data_lda_select_lda_portal_data"                
    ##  [7] "ts_select_ts_sdl_data_lda_select_lda_sdl_data"                      
    ##  [8] "ts_select_ts_mtquad_data_lda_select_lda_mtquad_data"                
    ##  [9] "ts_select_ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11"  
    ## [10] "ts_select_ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11"  
    ## [11] "ts_select_ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11"  
    ## [12] "ts_select_ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11"  
    ## [13] "ts_select_ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11"

Community-level results
-----------------------

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

Detailed model results
----------------------

``` r
#ts_models_summary <- readd(ts_models_summary, cache = cache)

ts_results <- readd(ts_results, cache =cache)
ts_models_summary <- collect_ts_result_models_summary(ts_results)
print(ts_models_summary)
```

    ##                                                      ts_name nchangepoints
    ## 1                ts_maizuru_data_lda_select_lda_maizuru_data             0
    ## 2                ts_maizuru_data_lda_select_lda_maizuru_data             0
    ## 3                ts_maizuru_data_lda_select_lda_maizuru_data             1
    ## 4                ts_maizuru_data_lda_select_lda_maizuru_data             1
    ## 5  ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data             0
    ## 6  ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data             0
    ## 7  ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data             1
    ## 8  ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data             1
    ## 9    ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data             0
    ## 10   ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data             0
    ## 11   ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data             1
    ## 12   ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data             1
    ## 13                   ts_karoo_data_lda_select_lda_karoo_data             0
    ## 14                   ts_karoo_data_lda_select_lda_karoo_data             0
    ## 15                   ts_karoo_data_lda_select_lda_karoo_data             1
    ## 16                   ts_karoo_data_lda_select_lda_karoo_data             1
    ## 17                 ts_kruger_data_lda_select_lda_kruger_data             0
    ## 18                 ts_kruger_data_lda_select_lda_kruger_data             0
    ## 19                 ts_kruger_data_lda_select_lda_kruger_data             1
    ## 20                 ts_kruger_data_lda_select_lda_kruger_data             1
    ## 21                 ts_portal_data_lda_select_lda_portal_data             0
    ## 22                 ts_portal_data_lda_select_lda_portal_data             0
    ## 23                 ts_portal_data_lda_select_lda_portal_data             1
    ## 24                 ts_portal_data_lda_select_lda_portal_data             1
    ## 25                       ts_sdl_data_lda_select_lda_sdl_data             0
    ## 26                       ts_sdl_data_lda_select_lda_sdl_data             0
    ## 27                       ts_sdl_data_lda_select_lda_sdl_data             1
    ## 28                       ts_sdl_data_lda_select_lda_sdl_data             1
    ## 29                 ts_mtquad_data_lda_select_lda_mtquad_data             0
    ## 30                 ts_mtquad_data_lda_select_lda_mtquad_data             0
    ## 31                 ts_mtquad_data_lda_select_lda_mtquad_data             1
    ## 32                 ts_mtquad_data_lda_select_lda_mtquad_data             1
    ## 33   ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11             0
    ## 34   ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11             0
    ## 35   ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11             1
    ## 36   ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11             1
    ## 37   ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11             0
    ## 38   ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11             0
    ## 39   ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11             1
    ## 40   ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11             1
    ## 41   ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11             0
    ## 42   ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11             0
    ## 43   ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11             1
    ## 44   ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11             1
    ## 45   ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11             0
    ## 46   ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11             0
    ## 47   ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11             1
    ## 48   ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11             1
    ## 49   ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11             0
    ## 50   ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11             0
    ## 51   ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11             1
    ## 52   ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11             1
    ##                  formula              AIC
    ## 1           gamma ~ Date   1239.216283538
    ## 2              gamma ~ 1 1232.58903602349
    ## 3           gamma ~ Date 1256.29518563602
    ## 4              gamma ~ 1 1221.92840394499
    ## 5           gamma ~ Year  125.89881325928
    ## 6              gamma ~ 1 99.8988134974066
    ## 7           gamma ~ Year 179.898695298947
    ## 8              gamma ~ 1  127.89868898743
    ## 9           gamma ~ Year 125.893589099337
    ## 10             gamma ~ 1 99.8935887320816
    ## 11          gamma ~ Year 179.893286868156
    ## 12             gamma ~ 1 127.893282359831
    ## 13          gamma ~ year 98.3967318590179
    ## 14             gamma ~ 1 84.1730721271733
    ## 15          gamma ~ year 141.776342222664
    ## 16             gamma ~ 1 99.0884516706373
    ## 17          gamma ~ year 167.084747872161
    ## 18             gamma ~ 1 144.675170307421
    ## 19          gamma ~ year 218.219162762875
    ## 20             gamma ~ 1 169.560295720885
    ## 21 gamma ~ newmoonnumber  907.42060599499
    ## 22             gamma ~ 1 964.518503589393
    ## 23 gamma ~ newmoonnumber 833.755879181036
    ## 24             gamma ~ 1  879.89914319893
    ## 25          gamma ~ year 110.991333996799
    ## 26             gamma ~ 1 108.488587192427
    ## 27          gamma ~ year 122.801823076567
    ## 28             gamma ~ 1 111.995549949425
    ## 29          gamma ~ year 87.1827182320061
    ## 30             gamma ~ 1 70.8076353913618
    ## 31          gamma ~ year 135.988608868389
    ## 32             gamma ~ 1 92.6714869133408
    ## 33          gamma ~ year 260.754431324107
    ## 34             gamma ~ 1 259.202306757965
    ## 35          gamma ~ year 289.094998994228
    ## 36             gamma ~ 1 259.442808713852
    ## 37          gamma ~ year 316.069215166655
    ## 38             gamma ~ 1 290.094886665959
    ## 39          gamma ~ year 325.245886122481
    ## 40             gamma ~ 1 293.221638454894
    ## 41          gamma ~ year 262.971124018683
    ## 42             gamma ~ 1 245.052916300025
    ## 43          gamma ~ year  257.76994137243
    ## 44             gamma ~ 1 240.676217105201
    ## 45          gamma ~ year 315.801074488283
    ## 46             gamma ~ 1 289.847218958367
    ## 47          gamma ~ year 321.784384721694
    ## 48             gamma ~ 1 292.219758280276
    ## 49          gamma ~ year 225.663870407715
    ## 50             gamma ~ 1 205.663264146165
    ## 51          gamma ~ year 238.632879433397
    ## 52             gamma ~ 1  208.00667211371
