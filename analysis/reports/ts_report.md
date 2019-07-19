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

    ## [1] "ts_jornada_data_lda_select_lda_jornada_data_5"
    ## [1] "Incorrect data structure"
    ## [1] "ts_sgs_data_lda_select_lda_sgs_data_5"
    ## [1] "Incorrect data structure"
    ## [1] "ts_filtered_jornada_data_lda_select_lda_filtered_jornada_data_5"
    ## [1] "Incorrect data structure"
    ## [1] "ts_filtered_sgs_data_lda_select_lda_filtered_sgs_data_5"
    ## [1] "Incorrect data structure"
    ## [1] "ts_jornada_data_lda_select_lda_jornada_data_16"
    ## [1] "Incorrect data structure"
    ## [1] "ts_sgs_data_lda_select_lda_sgs_data_16"
    ## [1] "Incorrect data structure"
    ## [1] "ts_filtered_jornada_data_lda_select_lda_filtered_jornada_data_16"
    ## [1] "Incorrect data structure"
    ## [1] "ts_filtered_sgs_data_lda_select_lda_filtered_sgs_data_16"
    ## [1] "Incorrect data structure"

These TS models ran successfully:

    ##  [1] "ts_maizuru_data_lda_select_lda_maizuru_data_5"                                 
    ##  [2] "ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data_5"                   
    ##  [3] "ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data_5"                     
    ##  [4] "ts_karoo_data_lda_select_lda_karoo_data_5"                                     
    ##  [5] "ts_kruger_data_lda_select_lda_kruger_data_5"                                   
    ##  [6] "ts_portal_data_lda_select_lda_portal_data_5"                                   
    ##  [7] "ts_sdl_data_lda_select_lda_sdl_data_5"                                         
    ##  [8] "ts_mtquad_data_lda_select_lda_mtquad_data_5"                                   
    ##  [9] "ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5"                     
    ## [10] "ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_5"                     
    ## [11] "ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11_5"                     
    ## [12] "ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11_5"                     
    ## [13] "ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11_5"                     
    ## [14] "ts_filtered_maizuru_data_lda_select_lda_filtered_maizuru_data_5"               
    ## [15] "ts_filtered_cowley_lizards_data_lda_select_lda_filtered_cowley_lizards_data_5" 
    ## [16] "ts_filtered_cowley_snakes_data_lda_select_lda_filtered_cowley_snakes_data_5"   
    ## [17] "ts_filtered_karoo_data_lda_select_lda_filtered_karoo_data_5"                   
    ## [18] "ts_filtered_kruger_data_lda_select_lda_filtered_kruger_data_5"                 
    ## [19] "ts_filtered_portal_data_lda_select_lda_filtered_portal_data_5"                 
    ## [20] "ts_filtered_sdl_data_lda_select_lda_filtered_sdl_data_5"                       
    ## [21] "ts_filtered_mtquad_data_lda_select_lda_filtered_mtquad_data_5"                 
    ## [22] "ts_filtered_bbs_data_rtrg_1_11_lda_select_lda_filtered_bbs_data_rtrg_1_11_5"   
    ## [23] "ts_filtered_bbs_data_rtrg_2_11_lda_select_lda_filtered_bbs_data_rtrg_2_11_5"   
    ## [24] "ts_filtered_bbs_data_rtrg_3_11_lda_select_lda_filtered_bbs_data_rtrg_3_11_5"   
    ## [25] "ts_filtered_bbs_data_rtrg_4_11_lda_select_lda_filtered_bbs_data_rtrg_4_11_5"   
    ## [26] "ts_filtered_bbs_data_rtrg_6_11_lda_select_lda_filtered_bbs_data_rtrg_6_11_5"   
    ## [27] "ts_maizuru_data_lda_select_lda_maizuru_data_16"                                
    ## [28] "ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data_16"                  
    ## [29] "ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data_16"                    
    ## [30] "ts_karoo_data_lda_select_lda_karoo_data_16"                                    
    ## [31] "ts_kruger_data_lda_select_lda_kruger_data_16"                                  
    ## [32] "ts_portal_data_lda_select_lda_portal_data_16"                                  
    ## [33] "ts_sdl_data_lda_select_lda_sdl_data_16"                                        
    ## [34] "ts_mtquad_data_lda_select_lda_mtquad_data_16"                                  
    ## [35] "ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_16"                    
    ## [36] "ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_16"                    
    ## [37] "ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11_16"                    
    ## [38] "ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11_16"                    
    ## [39] "ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11_16"                    
    ## [40] "ts_filtered_maizuru_data_lda_select_lda_filtered_maizuru_data_16"              
    ## [41] "ts_filtered_cowley_lizards_data_lda_select_lda_filtered_cowley_lizards_data_16"
    ## [42] "ts_filtered_cowley_snakes_data_lda_select_lda_filtered_cowley_snakes_data_16"  
    ## [43] "ts_filtered_karoo_data_lda_select_lda_filtered_karoo_data_16"                  
    ## [44] "ts_filtered_kruger_data_lda_select_lda_filtered_kruger_data_16"                
    ## [45] "ts_filtered_portal_data_lda_select_lda_filtered_portal_data_16"                
    ## [46] "ts_filtered_sdl_data_lda_select_lda_filtered_sdl_data_16"                      
    ## [47] "ts_filtered_mtquad_data_lda_select_lda_filtered_mtquad_data_16"                
    ## [48] "ts_filtered_bbs_data_rtrg_1_11_lda_select_lda_filtered_bbs_data_rtrg_1_11_16"  
    ## [49] "ts_filtered_bbs_data_rtrg_2_11_lda_select_lda_filtered_bbs_data_rtrg_2_11_16"  
    ## [50] "ts_filtered_bbs_data_rtrg_3_11_lda_select_lda_filtered_bbs_data_rtrg_3_11_16"  
    ## [51] "ts_filtered_bbs_data_rtrg_4_11_lda_select_lda_filtered_bbs_data_rtrg_4_11_16"  
    ## [52] "ts_filtered_bbs_data_rtrg_6_11_lda_select_lda_filtered_bbs_data_rtrg_6_11_16"

Find TS models that threw errors in selection and remove them:

    ## [1] "ts_select_ts_jornada_data_lda_select_lda_jornada_data_5"
    ## [1] "Error in LDATS::select_TS(ts_jornada_data_lda_select_lda_jornada_data_5) : \n  TS_models must be of class TS_on_LDA\n"
    ## attr(,"class")
    ## [1] "try-error"
    ## attr(,"condition")
    ## <simpleError in LDATS::select_TS(ts_jornada_data_lda_select_lda_jornada_data_5): TS_models must be of class TS_on_LDA>
    ## [1] "ts_select_ts_sgs_data_lda_select_lda_sgs_data_5"
    ## [1] "Error in LDATS::select_TS(ts_sgs_data_lda_select_lda_sgs_data_5) : \n  TS_models must be of class TS_on_LDA\n"
    ## attr(,"class")
    ## [1] "try-error"
    ## attr(,"condition")
    ## <simpleError in LDATS::select_TS(ts_sgs_data_lda_select_lda_sgs_data_5): TS_models must be of class TS_on_LDA>
    ## [1] "ts_select_ts_filtered_jornada_data_lda_select_lda_filtered_jornada_data_5"
    ## [1] "Error in LDATS::select_TS(ts_filtered_jornada_data_lda_select_lda_filtered_jornada_data_5) : \n  TS_models must be of class TS_on_LDA\n"
    ## attr(,"class")
    ## [1] "try-error"
    ## attr(,"condition")
    ## <simpleError in LDATS::select_TS(ts_filtered_jornada_data_lda_select_lda_filtered_jornada_data_5): TS_models must be of class TS_on_LDA>
    ## [1] "ts_select_ts_filtered_sgs_data_lda_select_lda_filtered_sgs_data_5"
    ## [1] "Error in LDATS::select_TS(ts_filtered_sgs_data_lda_select_lda_filtered_sgs_data_5) : \n  TS_models must be of class TS_on_LDA\n"
    ## attr(,"class")
    ## [1] "try-error"
    ## attr(,"condition")
    ## <simpleError in LDATS::select_TS(ts_filtered_sgs_data_lda_select_lda_filtered_sgs_data_5): TS_models must be of class TS_on_LDA>
    ## [1] "ts_select_ts_jornada_data_lda_select_lda_jornada_data_16"
    ## [1] "Error in LDATS::select_TS(ts_jornada_data_lda_select_lda_jornada_data_16) : \n  TS_models must be of class TS_on_LDA\n"
    ## attr(,"class")
    ## [1] "try-error"
    ## attr(,"condition")
    ## <simpleError in LDATS::select_TS(ts_jornada_data_lda_select_lda_jornada_data_16): TS_models must be of class TS_on_LDA>
    ## [1] "ts_select_ts_sgs_data_lda_select_lda_sgs_data_16"
    ## [1] "Error in LDATS::select_TS(ts_sgs_data_lda_select_lda_sgs_data_16) : \n  TS_models must be of class TS_on_LDA\n"
    ## attr(,"class")
    ## [1] "try-error"
    ## attr(,"condition")
    ## <simpleError in LDATS::select_TS(ts_sgs_data_lda_select_lda_sgs_data_16): TS_models must be of class TS_on_LDA>
    ## [1] "ts_select_ts_filtered_jornada_data_lda_select_lda_filtered_jornada_data_16"
    ## [1] "Error in LDATS::select_TS(ts_filtered_jornada_data_lda_select_lda_filtered_jornada_data_16) : \n  TS_models must be of class TS_on_LDA\n"
    ## attr(,"class")
    ## [1] "try-error"
    ## attr(,"condition")
    ## <simpleError in LDATS::select_TS(ts_filtered_jornada_data_lda_select_lda_filtered_jornada_data_16): TS_models must be of class TS_on_LDA>
    ## [1] "ts_select_ts_filtered_sgs_data_lda_select_lda_filtered_sgs_data_16"
    ## [1] "Error in LDATS::select_TS(ts_filtered_sgs_data_lda_select_lda_filtered_sgs_data_16) : \n  TS_models must be of class TS_on_LDA\n"
    ## attr(,"class")
    ## [1] "try-error"
    ## attr(,"condition")
    ## <simpleError in LDATS::select_TS(ts_filtered_sgs_data_lda_select_lda_filtered_sgs_data_16): TS_models must be of class TS_on_LDA>

These TS models were selected correctly:

    ##  [1] "ts_select_ts_maizuru_data_lda_select_lda_maizuru_data_5"                                 
    ##  [2] "ts_select_ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data_5"                   
    ##  [3] "ts_select_ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data_5"                     
    ##  [4] "ts_select_ts_karoo_data_lda_select_lda_karoo_data_5"                                     
    ##  [5] "ts_select_ts_kruger_data_lda_select_lda_kruger_data_5"                                   
    ##  [6] "ts_select_ts_portal_data_lda_select_lda_portal_data_5"                                   
    ##  [7] "ts_select_ts_sdl_data_lda_select_lda_sdl_data_5"                                         
    ##  [8] "ts_select_ts_mtquad_data_lda_select_lda_mtquad_data_5"                                   
    ##  [9] "ts_select_ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5"                     
    ## [10] "ts_select_ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_5"                     
    ## [11] "ts_select_ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11_5"                     
    ## [12] "ts_select_ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11_5"                     
    ## [13] "ts_select_ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11_5"                     
    ## [14] "ts_select_ts_filtered_maizuru_data_lda_select_lda_filtered_maizuru_data_5"               
    ## [15] "ts_select_ts_filtered_cowley_lizards_data_lda_select_lda_filtered_cowley_lizards_data_5" 
    ## [16] "ts_select_ts_filtered_cowley_snakes_data_lda_select_lda_filtered_cowley_snakes_data_5"   
    ## [17] "ts_select_ts_filtered_karoo_data_lda_select_lda_filtered_karoo_data_5"                   
    ## [18] "ts_select_ts_filtered_kruger_data_lda_select_lda_filtered_kruger_data_5"                 
    ## [19] "ts_select_ts_filtered_portal_data_lda_select_lda_filtered_portal_data_5"                 
    ## [20] "ts_select_ts_filtered_sdl_data_lda_select_lda_filtered_sdl_data_5"                       
    ## [21] "ts_select_ts_filtered_mtquad_data_lda_select_lda_filtered_mtquad_data_5"                 
    ## [22] "ts_select_ts_filtered_bbs_data_rtrg_1_11_lda_select_lda_filtered_bbs_data_rtrg_1_11_5"   
    ## [23] "ts_select_ts_filtered_bbs_data_rtrg_2_11_lda_select_lda_filtered_bbs_data_rtrg_2_11_5"   
    ## [24] "ts_select_ts_filtered_bbs_data_rtrg_3_11_lda_select_lda_filtered_bbs_data_rtrg_3_11_5"   
    ## [25] "ts_select_ts_filtered_bbs_data_rtrg_4_11_lda_select_lda_filtered_bbs_data_rtrg_4_11_5"   
    ## [26] "ts_select_ts_filtered_bbs_data_rtrg_6_11_lda_select_lda_filtered_bbs_data_rtrg_6_11_5"   
    ## [27] "ts_select_ts_maizuru_data_lda_select_lda_maizuru_data_16"                                
    ## [28] "ts_select_ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data_16"                  
    ## [29] "ts_select_ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data_16"                    
    ## [30] "ts_select_ts_karoo_data_lda_select_lda_karoo_data_16"                                    
    ## [31] "ts_select_ts_kruger_data_lda_select_lda_kruger_data_16"                                  
    ## [32] "ts_select_ts_portal_data_lda_select_lda_portal_data_16"                                  
    ## [33] "ts_select_ts_sdl_data_lda_select_lda_sdl_data_16"                                        
    ## [34] "ts_select_ts_mtquad_data_lda_select_lda_mtquad_data_16"                                  
    ## [35] "ts_select_ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_16"                    
    ## [36] "ts_select_ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_16"                    
    ## [37] "ts_select_ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11_16"                    
    ## [38] "ts_select_ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11_16"                    
    ## [39] "ts_select_ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11_16"                    
    ## [40] "ts_select_ts_filtered_maizuru_data_lda_select_lda_filtered_maizuru_data_16"              
    ## [41] "ts_select_ts_filtered_cowley_lizards_data_lda_select_lda_filtered_cowley_lizards_data_16"
    ## [42] "ts_select_ts_filtered_cowley_snakes_data_lda_select_lda_filtered_cowley_snakes_data_16"  
    ## [43] "ts_select_ts_filtered_karoo_data_lda_select_lda_filtered_karoo_data_16"                  
    ## [44] "ts_select_ts_filtered_kruger_data_lda_select_lda_filtered_kruger_data_16"                
    ## [45] "ts_select_ts_filtered_portal_data_lda_select_lda_filtered_portal_data_16"                
    ## [46] "ts_select_ts_filtered_sdl_data_lda_select_lda_filtered_sdl_data_16"                      
    ## [47] "ts_select_ts_filtered_mtquad_data_lda_select_lda_filtered_mtquad_data_16"                
    ## [48] "ts_select_ts_filtered_bbs_data_rtrg_1_11_lda_select_lda_filtered_bbs_data_rtrg_1_11_16"  
    ## [49] "ts_select_ts_filtered_bbs_data_rtrg_2_11_lda_select_lda_filtered_bbs_data_rtrg_2_11_16"  
    ## [50] "ts_select_ts_filtered_bbs_data_rtrg_3_11_lda_select_lda_filtered_bbs_data_rtrg_3_11_16"  
    ## [51] "ts_select_ts_filtered_bbs_data_rtrg_4_11_lda_select_lda_filtered_bbs_data_rtrg_4_11_16"  
    ## [52] "ts_select_ts_filtered_bbs_data_rtrg_6_11_lda_select_lda_filtered_bbs_data_rtrg_6_11_16"

Community-level results
-----------------------

``` r
lda_ts_result_summary <- readd(lda_ts_result_summary, cache = cache)
lda_ts_result_summary
```

    ##                                          lda_name ntopics maxtopics
    ## 1                   lda_select_lda_maizuru_data_5       5         5
    ## 2                   lda_select_lda_jornada_data_5       5         5
    ## 3                       lda_select_lda_sgs_data_5       4         5
    ## 4            lda_select_lda_cowley_lizards_data_5       2         5
    ## 5             lda_select_lda_cowley_snakes_data_5       2         5
    ## 6                     lda_select_lda_karoo_data_5       5         5
    ## 7                    lda_select_lda_kruger_data_5       5         5
    ## 8                    lda_select_lda_portal_data_5       5         5
    ## 9                       lda_select_lda_sdl_data_5       5         5
    ## 10                   lda_select_lda_mtquad_data_5       5         5
    ## 11            lda_select_lda_bbs_data_rtrg_1_11_5       5         5
    ## 12            lda_select_lda_bbs_data_rtrg_2_11_5       5         5
    ## 13            lda_select_lda_bbs_data_rtrg_3_11_5       5         5
    ## 14            lda_select_lda_bbs_data_rtrg_4_11_5       5         5
    ## 15            lda_select_lda_bbs_data_rtrg_6_11_5       5         5
    ## 16         lda_select_lda_filtered_maizuru_data_5       5         5
    ## 17         lda_select_lda_filtered_jornada_data_5       5         5
    ## 18             lda_select_lda_filtered_sgs_data_5       5         5
    ## 19  lda_select_lda_filtered_cowley_lizards_data_5       2         5
    ## 20   lda_select_lda_filtered_cowley_snakes_data_5       2         5
    ## 21           lda_select_lda_filtered_karoo_data_5       5         5
    ## 22          lda_select_lda_filtered_kruger_data_5       5         5
    ## 23          lda_select_lda_filtered_portal_data_5       4         5
    ## 24             lda_select_lda_filtered_sdl_data_5       5         5
    ## 25          lda_select_lda_filtered_mtquad_data_5       5         5
    ## 26   lda_select_lda_filtered_bbs_data_rtrg_1_11_5       5         5
    ## 27   lda_select_lda_filtered_bbs_data_rtrg_2_11_5       5         5
    ## 28   lda_select_lda_filtered_bbs_data_rtrg_3_11_5       5         5
    ## 29   lda_select_lda_filtered_bbs_data_rtrg_4_11_5       5         5
    ## 30   lda_select_lda_filtered_bbs_data_rtrg_6_11_5       5         5
    ## 31                 lda_select_lda_maizuru_data_16      14        16
    ## 32                 lda_select_lda_jornada_data_16       6        16
    ## 33                     lda_select_lda_sgs_data_16      13        16
    ## 34          lda_select_lda_cowley_lizards_data_16      14        16
    ## 35           lda_select_lda_cowley_snakes_data_16      14        16
    ## 36                   lda_select_lda_karoo_data_16      13        16
    ## 37                  lda_select_lda_kruger_data_16      14        16
    ## 38                  lda_select_lda_portal_data_16       5        16
    ## 39                     lda_select_lda_sdl_data_16       9        16
    ## 40                  lda_select_lda_mtquad_data_16      14        16
    ## 41           lda_select_lda_bbs_data_rtrg_1_11_16      12        16
    ## 42           lda_select_lda_bbs_data_rtrg_2_11_16      14        16
    ## 43           lda_select_lda_bbs_data_rtrg_3_11_16      10        16
    ## 44           lda_select_lda_bbs_data_rtrg_4_11_16      14        16
    ## 45           lda_select_lda_bbs_data_rtrg_6_11_16      11        16
    ## 46        lda_select_lda_filtered_maizuru_data_16      10        16
    ## 47        lda_select_lda_filtered_jornada_data_16       7        16
    ## 48            lda_select_lda_filtered_sgs_data_16      13        16
    ## 49 lda_select_lda_filtered_cowley_lizards_data_16      14        16
    ## 50  lda_select_lda_filtered_cowley_snakes_data_16      14        16
    ## 51          lda_select_lda_filtered_karoo_data_16      13        16
    ## 52         lda_select_lda_filtered_kruger_data_16      14        16
    ## 53         lda_select_lda_filtered_portal_data_16       4        16
    ## 54            lda_select_lda_filtered_sdl_data_16      11        16
    ## 55         lda_select_lda_filtered_mtquad_data_16      14        16
    ## 56  lda_select_lda_filtered_bbs_data_rtrg_1_11_16      14        16
    ## 57  lda_select_lda_filtered_bbs_data_rtrg_2_11_16      14        16
    ## 58  lda_select_lda_filtered_bbs_data_rtrg_3_11_16      10        16
    ## 59  lda_select_lda_filtered_bbs_data_rtrg_4_11_16      16        16
    ## 60  lda_select_lda_filtered_bbs_data_rtrg_6_11_16      13        16
    ##    ntimeseries ntimesteps                            data
    ## 1           15        285                  maizuru_data_5
    ## 2           17         24                  jornada_data_5
    ## 3           11         13                      sgs_data_5
    ## 4            6         14           cowley_lizards_data_5
    ## 5           16         14            cowley_snakes_data_5
    ## 6           16         13                    karoo_data_5
    ## 7           12         31                   kruger_data_5
    ## 8           21        319                   portal_data_5
    ## 9           98         22                      sdl_data_5
    ## 10          42         14                   mtquad_data_5
    ## 11          99         51            bbs_data_rtrg_1_11_5
    ## 12         120         51            bbs_data_rtrg_2_11_5
    ## 13         115         51            bbs_data_rtrg_3_11_5
    ## 14         113         51            bbs_data_rtrg_4_11_5
    ## 15          81         40            bbs_data_rtrg_6_11_5
    ## 16          10        285         filtered_maizuru_data_5
    ## 17          13         24         filtered_jornada_data_5
    ## 18           7         13             filtered_sgs_data_5
    ## 19           4         14  filtered_cowley_lizards_data_5
    ## 20          11         14   filtered_cowley_snakes_data_5
    ## 21          13         13           filtered_karoo_data_5
    ## 22          12         31          filtered_kruger_data_5
    ## 23          11        319          filtered_portal_data_5
    ## 24          39         22             filtered_sdl_data_5
    ## 25          24         14          filtered_mtquad_data_5
    ## 26          59         51   filtered_bbs_data_rtrg_1_11_5
    ## 27          72         51   filtered_bbs_data_rtrg_2_11_5
    ## 28          68         51   filtered_bbs_data_rtrg_3_11_5
    ## 29          58         51   filtered_bbs_data_rtrg_4_11_5
    ## 30          53         40   filtered_bbs_data_rtrg_6_11_5
    ## 31          15        285                 maizuru_data_16
    ## 32          17         24                 jornada_data_16
    ## 33          11         13                     sgs_data_16
    ## 34           6         14          cowley_lizards_data_16
    ## 35          16         14           cowley_snakes_data_16
    ## 36          16         13                   karoo_data_16
    ## 37          12         31                  kruger_data_16
    ## 38          21        319                  portal_data_16
    ## 39          98         22                     sdl_data_16
    ## 40          42         14                  mtquad_data_16
    ## 41          99         51           bbs_data_rtrg_1_11_16
    ## 42         120         51           bbs_data_rtrg_2_11_16
    ## 43         115         51           bbs_data_rtrg_3_11_16
    ## 44         113         51           bbs_data_rtrg_4_11_16
    ## 45          81         40           bbs_data_rtrg_6_11_16
    ## 46          10        285        filtered_maizuru_data_16
    ## 47          13         24        filtered_jornada_data_16
    ## 48           7         13            filtered_sgs_data_16
    ## 49           4         14 filtered_cowley_lizards_data_16
    ## 50          11         14  filtered_cowley_snakes_data_16
    ## 51          13         13          filtered_karoo_data_16
    ## 52          12         31         filtered_kruger_data_16
    ## 53          11        319         filtered_portal_data_16
    ## 54          39         22            filtered_sdl_data_16
    ## 55          24         14         filtered_mtquad_data_16
    ## 56          59         51  filtered_bbs_data_rtrg_1_11_16
    ## 57          72         51  filtered_bbs_data_rtrg_2_11_16
    ## 58          68         51  filtered_bbs_data_rtrg_3_11_16
    ## 59          58         51  filtered_bbs_data_rtrg_4_11_16
    ## 60          53         40  filtered_bbs_data_rtrg_6_11_16
    ##                                                                                     ts_name
    ## 1                                   ts_select_ts_maizuru_data_lda_select_lda_maizuru_data_5
    ## 2                                                                                      <NA>
    ## 3                                                                                      <NA>
    ## 4                     ts_select_ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data_5
    ## 5                       ts_select_ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data_5
    ## 6                                       ts_select_ts_karoo_data_lda_select_lda_karoo_data_5
    ## 7                                     ts_select_ts_kruger_data_lda_select_lda_kruger_data_5
    ## 8                                     ts_select_ts_portal_data_lda_select_lda_portal_data_5
    ## 9                                           ts_select_ts_sdl_data_lda_select_lda_sdl_data_5
    ## 10                                    ts_select_ts_mtquad_data_lda_select_lda_mtquad_data_5
    ## 11                      ts_select_ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5
    ## 12                      ts_select_ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_5
    ## 13                      ts_select_ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11_5
    ## 14                      ts_select_ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11_5
    ## 15                      ts_select_ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11_5
    ## 16                ts_select_ts_filtered_maizuru_data_lda_select_lda_filtered_maizuru_data_5
    ## 17                                                                                     <NA>
    ## 18                                                                                     <NA>
    ## 19  ts_select_ts_filtered_cowley_lizards_data_lda_select_lda_filtered_cowley_lizards_data_5
    ## 20    ts_select_ts_filtered_cowley_snakes_data_lda_select_lda_filtered_cowley_snakes_data_5
    ## 21                    ts_select_ts_filtered_karoo_data_lda_select_lda_filtered_karoo_data_5
    ## 22                  ts_select_ts_filtered_kruger_data_lda_select_lda_filtered_kruger_data_5
    ## 23                  ts_select_ts_filtered_portal_data_lda_select_lda_filtered_portal_data_5
    ## 24                        ts_select_ts_filtered_sdl_data_lda_select_lda_filtered_sdl_data_5
    ## 25                  ts_select_ts_filtered_mtquad_data_lda_select_lda_filtered_mtquad_data_5
    ## 26    ts_select_ts_filtered_bbs_data_rtrg_1_11_lda_select_lda_filtered_bbs_data_rtrg_1_11_5
    ## 27    ts_select_ts_filtered_bbs_data_rtrg_2_11_lda_select_lda_filtered_bbs_data_rtrg_2_11_5
    ## 28    ts_select_ts_filtered_bbs_data_rtrg_3_11_lda_select_lda_filtered_bbs_data_rtrg_3_11_5
    ## 29    ts_select_ts_filtered_bbs_data_rtrg_4_11_lda_select_lda_filtered_bbs_data_rtrg_4_11_5
    ## 30    ts_select_ts_filtered_bbs_data_rtrg_6_11_lda_select_lda_filtered_bbs_data_rtrg_6_11_5
    ## 31                                 ts_select_ts_maizuru_data_lda_select_lda_maizuru_data_16
    ## 32                                                                                     <NA>
    ## 33                                                                                     <NA>
    ## 34                   ts_select_ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data_16
    ## 35                     ts_select_ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data_16
    ## 36                                     ts_select_ts_karoo_data_lda_select_lda_karoo_data_16
    ## 37                                   ts_select_ts_kruger_data_lda_select_lda_kruger_data_16
    ## 38                                   ts_select_ts_portal_data_lda_select_lda_portal_data_16
    ## 39                                         ts_select_ts_sdl_data_lda_select_lda_sdl_data_16
    ## 40                                   ts_select_ts_mtquad_data_lda_select_lda_mtquad_data_16
    ## 41                     ts_select_ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_16
    ## 42                     ts_select_ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_16
    ## 43                     ts_select_ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11_16
    ## 44                     ts_select_ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11_16
    ## 45                     ts_select_ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11_16
    ## 46               ts_select_ts_filtered_maizuru_data_lda_select_lda_filtered_maizuru_data_16
    ## 47                                                                                     <NA>
    ## 48                                                                                     <NA>
    ## 49 ts_select_ts_filtered_cowley_lizards_data_lda_select_lda_filtered_cowley_lizards_data_16
    ## 50   ts_select_ts_filtered_cowley_snakes_data_lda_select_lda_filtered_cowley_snakes_data_16
    ## 51                   ts_select_ts_filtered_karoo_data_lda_select_lda_filtered_karoo_data_16
    ## 52                 ts_select_ts_filtered_kruger_data_lda_select_lda_filtered_kruger_data_16
    ## 53                 ts_select_ts_filtered_portal_data_lda_select_lda_filtered_portal_data_16
    ## 54                       ts_select_ts_filtered_sdl_data_lda_select_lda_filtered_sdl_data_16
    ## 55                 ts_select_ts_filtered_mtquad_data_lda_select_lda_filtered_mtquad_data_16
    ## 56   ts_select_ts_filtered_bbs_data_rtrg_1_11_lda_select_lda_filtered_bbs_data_rtrg_1_11_16
    ## 57   ts_select_ts_filtered_bbs_data_rtrg_2_11_lda_select_lda_filtered_bbs_data_rtrg_2_11_16
    ## 58   ts_select_ts_filtered_bbs_data_rtrg_3_11_lda_select_lda_filtered_bbs_data_rtrg_3_11_16
    ## 59   ts_select_ts_filtered_bbs_data_rtrg_4_11_lda_select_lda_filtered_bbs_data_rtrg_4_11_16
    ## 60   ts_select_ts_filtered_bbs_data_rtrg_6_11_lda_select_lda_filtered_bbs_data_rtrg_6_11_16
    ##    nchangepoints               formula
    ## 1              1          gamma ~ Date
    ## 2             NA                  <NA>
    ## 3             NA                  <NA>
    ## 4              0             gamma ~ 1
    ## 5              0             gamma ~ 1
    ## 6              0             gamma ~ 1
    ## 7              0             gamma ~ 1
    ## 8              1 gamma ~ newmoonnumber
    ## 9              1             gamma ~ 1
    ## 10             0          gamma ~ year
    ## 11             0          gamma ~ year
    ## 12             1             gamma ~ 1
    ## 13             0          gamma ~ year
    ## 14             0          gamma ~ year
    ## 15             0             gamma ~ 1
    ## 16             1          gamma ~ Date
    ## 17            NA                  <NA>
    ## 18            NA                  <NA>
    ## 19             0             gamma ~ 1
    ## 20             0             gamma ~ 1
    ## 21             0             gamma ~ 1
    ## 22             0             gamma ~ 1
    ## 23             1 gamma ~ newmoonnumber
    ## 24             0             gamma ~ 1
    ## 25             0          gamma ~ year
    ## 26             1             gamma ~ 1
    ## 27             0          gamma ~ year
    ## 28             0          gamma ~ year
    ## 29             0          gamma ~ year
    ## 30             0             gamma ~ 1
    ## 31             1             gamma ~ 1
    ## 32            NA                  <NA>
    ## 33            NA                  <NA>
    ## 34             0             gamma ~ 1
    ## 35             0             gamma ~ 1
    ## 36             0             gamma ~ 1
    ## 37             0             gamma ~ 1
    ## 38             1 gamma ~ newmoonnumber
    ## 39             0             gamma ~ 1
    ## 40             0             gamma ~ 1
    ## 41             0             gamma ~ 1
    ## 42             0             gamma ~ 1
    ## 43             1             gamma ~ 1
    ## 44             0             gamma ~ 1
    ## 45             0             gamma ~ 1
    ## 46             1             gamma ~ 1
    ## 47            NA                  <NA>
    ## 48            NA                  <NA>
    ## 49             0             gamma ~ 1
    ## 50             0             gamma ~ 1
    ## 51             0             gamma ~ 1
    ## 52             0             gamma ~ 1
    ## 53             1 gamma ~ newmoonnumber
    ## 54             0             gamma ~ 1
    ## 55             0             gamma ~ 1
    ## 56             0             gamma ~ 1
    ## 57             0             gamma ~ 1
    ## 58             0          gamma ~ year
    ## 59             0             gamma ~ 1
    ## 60             0             gamma ~ 1

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

    ##                                                                            ts_name
    ## 1                                    ts_maizuru_data_lda_select_lda_maizuru_data_5
    ## 2                                    ts_maizuru_data_lda_select_lda_maizuru_data_5
    ## 3                                    ts_maizuru_data_lda_select_lda_maizuru_data_5
    ## 4                                    ts_maizuru_data_lda_select_lda_maizuru_data_5
    ## 5                      ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data_5
    ## 6                      ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data_5
    ## 7                      ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data_5
    ## 8                      ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data_5
    ## 9                        ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data_5
    ## 10                       ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data_5
    ## 11                       ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data_5
    ## 12                       ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data_5
    ## 13                                       ts_karoo_data_lda_select_lda_karoo_data_5
    ## 14                                       ts_karoo_data_lda_select_lda_karoo_data_5
    ## 15                                       ts_karoo_data_lda_select_lda_karoo_data_5
    ## 16                                       ts_karoo_data_lda_select_lda_karoo_data_5
    ## 17                                     ts_kruger_data_lda_select_lda_kruger_data_5
    ## 18                                     ts_kruger_data_lda_select_lda_kruger_data_5
    ## 19                                     ts_kruger_data_lda_select_lda_kruger_data_5
    ## 20                                     ts_kruger_data_lda_select_lda_kruger_data_5
    ## 21                                     ts_portal_data_lda_select_lda_portal_data_5
    ## 22                                     ts_portal_data_lda_select_lda_portal_data_5
    ## 23                                     ts_portal_data_lda_select_lda_portal_data_5
    ## 24                                     ts_portal_data_lda_select_lda_portal_data_5
    ## 25                                           ts_sdl_data_lda_select_lda_sdl_data_5
    ## 26                                           ts_sdl_data_lda_select_lda_sdl_data_5
    ## 27                                           ts_sdl_data_lda_select_lda_sdl_data_5
    ## 28                                           ts_sdl_data_lda_select_lda_sdl_data_5
    ## 29                                     ts_mtquad_data_lda_select_lda_mtquad_data_5
    ## 30                                     ts_mtquad_data_lda_select_lda_mtquad_data_5
    ## 31                                     ts_mtquad_data_lda_select_lda_mtquad_data_5
    ## 32                                     ts_mtquad_data_lda_select_lda_mtquad_data_5
    ## 33                       ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5
    ## 34                       ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5
    ## 35                       ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5
    ## 36                       ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_5
    ## 37                       ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_5
    ## 38                       ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_5
    ## 39                       ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_5
    ## 40                       ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_5
    ## 41                       ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11_5
    ## 42                       ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11_5
    ## 43                       ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11_5
    ## 44                       ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11_5
    ## 45                       ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11_5
    ## 46                       ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11_5
    ## 47                       ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11_5
    ## 48                       ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11_5
    ## 49                       ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11_5
    ## 50                       ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11_5
    ## 51                       ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11_5
    ## 52                       ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11_5
    ## 53                 ts_filtered_maizuru_data_lda_select_lda_filtered_maizuru_data_5
    ## 54                 ts_filtered_maizuru_data_lda_select_lda_filtered_maizuru_data_5
    ## 55                 ts_filtered_maizuru_data_lda_select_lda_filtered_maizuru_data_5
    ## 56                 ts_filtered_maizuru_data_lda_select_lda_filtered_maizuru_data_5
    ## 57   ts_filtered_cowley_lizards_data_lda_select_lda_filtered_cowley_lizards_data_5
    ## 58   ts_filtered_cowley_lizards_data_lda_select_lda_filtered_cowley_lizards_data_5
    ## 59   ts_filtered_cowley_lizards_data_lda_select_lda_filtered_cowley_lizards_data_5
    ## 60   ts_filtered_cowley_lizards_data_lda_select_lda_filtered_cowley_lizards_data_5
    ## 61     ts_filtered_cowley_snakes_data_lda_select_lda_filtered_cowley_snakes_data_5
    ## 62     ts_filtered_cowley_snakes_data_lda_select_lda_filtered_cowley_snakes_data_5
    ## 63     ts_filtered_cowley_snakes_data_lda_select_lda_filtered_cowley_snakes_data_5
    ## 64     ts_filtered_cowley_snakes_data_lda_select_lda_filtered_cowley_snakes_data_5
    ## 65                     ts_filtered_karoo_data_lda_select_lda_filtered_karoo_data_5
    ## 66                     ts_filtered_karoo_data_lda_select_lda_filtered_karoo_data_5
    ## 67                     ts_filtered_karoo_data_lda_select_lda_filtered_karoo_data_5
    ## 68                     ts_filtered_karoo_data_lda_select_lda_filtered_karoo_data_5
    ## 69                   ts_filtered_kruger_data_lda_select_lda_filtered_kruger_data_5
    ## 70                   ts_filtered_kruger_data_lda_select_lda_filtered_kruger_data_5
    ## 71                   ts_filtered_kruger_data_lda_select_lda_filtered_kruger_data_5
    ## 72                   ts_filtered_kruger_data_lda_select_lda_filtered_kruger_data_5
    ## 73                   ts_filtered_portal_data_lda_select_lda_filtered_portal_data_5
    ## 74                   ts_filtered_portal_data_lda_select_lda_filtered_portal_data_5
    ## 75                   ts_filtered_portal_data_lda_select_lda_filtered_portal_data_5
    ## 76                   ts_filtered_portal_data_lda_select_lda_filtered_portal_data_5
    ## 77                         ts_filtered_sdl_data_lda_select_lda_filtered_sdl_data_5
    ## 78                         ts_filtered_sdl_data_lda_select_lda_filtered_sdl_data_5
    ## 79                         ts_filtered_sdl_data_lda_select_lda_filtered_sdl_data_5
    ## 80                         ts_filtered_sdl_data_lda_select_lda_filtered_sdl_data_5
    ## 81                   ts_filtered_mtquad_data_lda_select_lda_filtered_mtquad_data_5
    ## 82                   ts_filtered_mtquad_data_lda_select_lda_filtered_mtquad_data_5
    ## 83                   ts_filtered_mtquad_data_lda_select_lda_filtered_mtquad_data_5
    ## 84                   ts_filtered_mtquad_data_lda_select_lda_filtered_mtquad_data_5
    ## 85     ts_filtered_bbs_data_rtrg_1_11_lda_select_lda_filtered_bbs_data_rtrg_1_11_5
    ## 86     ts_filtered_bbs_data_rtrg_1_11_lda_select_lda_filtered_bbs_data_rtrg_1_11_5
    ## 87     ts_filtered_bbs_data_rtrg_1_11_lda_select_lda_filtered_bbs_data_rtrg_1_11_5
    ## 88     ts_filtered_bbs_data_rtrg_1_11_lda_select_lda_filtered_bbs_data_rtrg_1_11_5
    ## 89     ts_filtered_bbs_data_rtrg_2_11_lda_select_lda_filtered_bbs_data_rtrg_2_11_5
    ## 90     ts_filtered_bbs_data_rtrg_2_11_lda_select_lda_filtered_bbs_data_rtrg_2_11_5
    ## 91     ts_filtered_bbs_data_rtrg_2_11_lda_select_lda_filtered_bbs_data_rtrg_2_11_5
    ## 92     ts_filtered_bbs_data_rtrg_2_11_lda_select_lda_filtered_bbs_data_rtrg_2_11_5
    ## 93     ts_filtered_bbs_data_rtrg_3_11_lda_select_lda_filtered_bbs_data_rtrg_3_11_5
    ## 94     ts_filtered_bbs_data_rtrg_3_11_lda_select_lda_filtered_bbs_data_rtrg_3_11_5
    ## 95     ts_filtered_bbs_data_rtrg_3_11_lda_select_lda_filtered_bbs_data_rtrg_3_11_5
    ## 96     ts_filtered_bbs_data_rtrg_3_11_lda_select_lda_filtered_bbs_data_rtrg_3_11_5
    ## 97     ts_filtered_bbs_data_rtrg_4_11_lda_select_lda_filtered_bbs_data_rtrg_4_11_5
    ## 98     ts_filtered_bbs_data_rtrg_4_11_lda_select_lda_filtered_bbs_data_rtrg_4_11_5
    ## 99     ts_filtered_bbs_data_rtrg_4_11_lda_select_lda_filtered_bbs_data_rtrg_4_11_5
    ## 100    ts_filtered_bbs_data_rtrg_4_11_lda_select_lda_filtered_bbs_data_rtrg_4_11_5
    ## 101    ts_filtered_bbs_data_rtrg_6_11_lda_select_lda_filtered_bbs_data_rtrg_6_11_5
    ## 102    ts_filtered_bbs_data_rtrg_6_11_lda_select_lda_filtered_bbs_data_rtrg_6_11_5
    ## 103    ts_filtered_bbs_data_rtrg_6_11_lda_select_lda_filtered_bbs_data_rtrg_6_11_5
    ## 104    ts_filtered_bbs_data_rtrg_6_11_lda_select_lda_filtered_bbs_data_rtrg_6_11_5
    ## 105                                 ts_maizuru_data_lda_select_lda_maizuru_data_16
    ## 106                                 ts_maizuru_data_lda_select_lda_maizuru_data_16
    ## 107                                 ts_maizuru_data_lda_select_lda_maizuru_data_16
    ## 108                                 ts_maizuru_data_lda_select_lda_maizuru_data_16
    ## 109                   ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data_16
    ## 110                   ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data_16
    ## 111                   ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data_16
    ## 112                   ts_cowley_lizards_data_lda_select_lda_cowley_lizards_data_16
    ## 113                     ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data_16
    ## 114                     ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data_16
    ## 115                     ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data_16
    ## 116                     ts_cowley_snakes_data_lda_select_lda_cowley_snakes_data_16
    ## 117                                     ts_karoo_data_lda_select_lda_karoo_data_16
    ## 118                                     ts_karoo_data_lda_select_lda_karoo_data_16
    ## 119                                     ts_karoo_data_lda_select_lda_karoo_data_16
    ## 120                                     ts_karoo_data_lda_select_lda_karoo_data_16
    ## 121                                   ts_kruger_data_lda_select_lda_kruger_data_16
    ## 122                                   ts_kruger_data_lda_select_lda_kruger_data_16
    ## 123                                   ts_kruger_data_lda_select_lda_kruger_data_16
    ## 124                                   ts_kruger_data_lda_select_lda_kruger_data_16
    ## 125                                   ts_portal_data_lda_select_lda_portal_data_16
    ## 126                                   ts_portal_data_lda_select_lda_portal_data_16
    ## 127                                   ts_portal_data_lda_select_lda_portal_data_16
    ## 128                                   ts_portal_data_lda_select_lda_portal_data_16
    ## 129                                         ts_sdl_data_lda_select_lda_sdl_data_16
    ## 130                                         ts_sdl_data_lda_select_lda_sdl_data_16
    ## 131                                         ts_sdl_data_lda_select_lda_sdl_data_16
    ## 132                                         ts_sdl_data_lda_select_lda_sdl_data_16
    ## 133                                   ts_mtquad_data_lda_select_lda_mtquad_data_16
    ## 134                                   ts_mtquad_data_lda_select_lda_mtquad_data_16
    ## 135                                   ts_mtquad_data_lda_select_lda_mtquad_data_16
    ## 136                                   ts_mtquad_data_lda_select_lda_mtquad_data_16
    ## 137                     ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_16
    ## 138                     ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_16
    ## 139                     ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_16
    ## 140                     ts_bbs_data_rtrg_1_11_lda_select_lda_bbs_data_rtrg_1_11_16
    ## 141                     ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_16
    ## 142                     ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_16
    ## 143                     ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_16
    ## 144                     ts_bbs_data_rtrg_2_11_lda_select_lda_bbs_data_rtrg_2_11_16
    ## 145                     ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11_16
    ## 146                     ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11_16
    ## 147                     ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11_16
    ## 148                     ts_bbs_data_rtrg_3_11_lda_select_lda_bbs_data_rtrg_3_11_16
    ## 149                     ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11_16
    ## 150                     ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11_16
    ## 151                     ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11_16
    ## 152                     ts_bbs_data_rtrg_4_11_lda_select_lda_bbs_data_rtrg_4_11_16
    ## 153                     ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11_16
    ## 154                     ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11_16
    ## 155                     ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11_16
    ## 156                     ts_bbs_data_rtrg_6_11_lda_select_lda_bbs_data_rtrg_6_11_16
    ## 157               ts_filtered_maizuru_data_lda_select_lda_filtered_maizuru_data_16
    ## 158               ts_filtered_maizuru_data_lda_select_lda_filtered_maizuru_data_16
    ## 159               ts_filtered_maizuru_data_lda_select_lda_filtered_maizuru_data_16
    ## 160               ts_filtered_maizuru_data_lda_select_lda_filtered_maizuru_data_16
    ## 161 ts_filtered_cowley_lizards_data_lda_select_lda_filtered_cowley_lizards_data_16
    ## 162 ts_filtered_cowley_lizards_data_lda_select_lda_filtered_cowley_lizards_data_16
    ## 163 ts_filtered_cowley_lizards_data_lda_select_lda_filtered_cowley_lizards_data_16
    ## 164 ts_filtered_cowley_lizards_data_lda_select_lda_filtered_cowley_lizards_data_16
    ## 165   ts_filtered_cowley_snakes_data_lda_select_lda_filtered_cowley_snakes_data_16
    ## 166   ts_filtered_cowley_snakes_data_lda_select_lda_filtered_cowley_snakes_data_16
    ## 167   ts_filtered_cowley_snakes_data_lda_select_lda_filtered_cowley_snakes_data_16
    ## 168   ts_filtered_cowley_snakes_data_lda_select_lda_filtered_cowley_snakes_data_16
    ## 169                   ts_filtered_karoo_data_lda_select_lda_filtered_karoo_data_16
    ## 170                   ts_filtered_karoo_data_lda_select_lda_filtered_karoo_data_16
    ## 171                   ts_filtered_karoo_data_lda_select_lda_filtered_karoo_data_16
    ## 172                   ts_filtered_karoo_data_lda_select_lda_filtered_karoo_data_16
    ## 173                 ts_filtered_kruger_data_lda_select_lda_filtered_kruger_data_16
    ## 174                 ts_filtered_kruger_data_lda_select_lda_filtered_kruger_data_16
    ## 175                 ts_filtered_kruger_data_lda_select_lda_filtered_kruger_data_16
    ## 176                 ts_filtered_kruger_data_lda_select_lda_filtered_kruger_data_16
    ## 177                 ts_filtered_portal_data_lda_select_lda_filtered_portal_data_16
    ## 178                 ts_filtered_portal_data_lda_select_lda_filtered_portal_data_16
    ## 179                 ts_filtered_portal_data_lda_select_lda_filtered_portal_data_16
    ## 180                 ts_filtered_portal_data_lda_select_lda_filtered_portal_data_16
    ## 181                       ts_filtered_sdl_data_lda_select_lda_filtered_sdl_data_16
    ## 182                       ts_filtered_sdl_data_lda_select_lda_filtered_sdl_data_16
    ## 183                       ts_filtered_sdl_data_lda_select_lda_filtered_sdl_data_16
    ## 184                       ts_filtered_sdl_data_lda_select_lda_filtered_sdl_data_16
    ## 185                 ts_filtered_mtquad_data_lda_select_lda_filtered_mtquad_data_16
    ## 186                 ts_filtered_mtquad_data_lda_select_lda_filtered_mtquad_data_16
    ## 187                 ts_filtered_mtquad_data_lda_select_lda_filtered_mtquad_data_16
    ## 188                 ts_filtered_mtquad_data_lda_select_lda_filtered_mtquad_data_16
    ## 189   ts_filtered_bbs_data_rtrg_1_11_lda_select_lda_filtered_bbs_data_rtrg_1_11_16
    ## 190   ts_filtered_bbs_data_rtrg_1_11_lda_select_lda_filtered_bbs_data_rtrg_1_11_16
    ## 191   ts_filtered_bbs_data_rtrg_1_11_lda_select_lda_filtered_bbs_data_rtrg_1_11_16
    ## 192   ts_filtered_bbs_data_rtrg_1_11_lda_select_lda_filtered_bbs_data_rtrg_1_11_16
    ## 193   ts_filtered_bbs_data_rtrg_2_11_lda_select_lda_filtered_bbs_data_rtrg_2_11_16
    ## 194   ts_filtered_bbs_data_rtrg_2_11_lda_select_lda_filtered_bbs_data_rtrg_2_11_16
    ## 195   ts_filtered_bbs_data_rtrg_2_11_lda_select_lda_filtered_bbs_data_rtrg_2_11_16
    ## 196   ts_filtered_bbs_data_rtrg_2_11_lda_select_lda_filtered_bbs_data_rtrg_2_11_16
    ## 197   ts_filtered_bbs_data_rtrg_3_11_lda_select_lda_filtered_bbs_data_rtrg_3_11_16
    ## 198   ts_filtered_bbs_data_rtrg_3_11_lda_select_lda_filtered_bbs_data_rtrg_3_11_16
    ## 199   ts_filtered_bbs_data_rtrg_3_11_lda_select_lda_filtered_bbs_data_rtrg_3_11_16
    ## 200   ts_filtered_bbs_data_rtrg_3_11_lda_select_lda_filtered_bbs_data_rtrg_3_11_16
    ## 201   ts_filtered_bbs_data_rtrg_4_11_lda_select_lda_filtered_bbs_data_rtrg_4_11_16
    ## 202   ts_filtered_bbs_data_rtrg_4_11_lda_select_lda_filtered_bbs_data_rtrg_4_11_16
    ## 203   ts_filtered_bbs_data_rtrg_4_11_lda_select_lda_filtered_bbs_data_rtrg_4_11_16
    ## 204   ts_filtered_bbs_data_rtrg_4_11_lda_select_lda_filtered_bbs_data_rtrg_4_11_16
    ## 205   ts_filtered_bbs_data_rtrg_6_11_lda_select_lda_filtered_bbs_data_rtrg_6_11_16
    ## 206   ts_filtered_bbs_data_rtrg_6_11_lda_select_lda_filtered_bbs_data_rtrg_6_11_16
    ## 207   ts_filtered_bbs_data_rtrg_6_11_lda_select_lda_filtered_bbs_data_rtrg_6_11_16
    ## 208   ts_filtered_bbs_data_rtrg_6_11_lda_select_lda_filtered_bbs_data_rtrg_6_11_16
    ##     nchangepoints               formula              AIC
    ## 1               0          gamma ~ Date  815.00834501733
    ## 2               0             gamma ~ 1 813.682939185259
    ## 3               1          gamma ~ Date 778.064226029182
    ## 4               1             gamma ~ 1 798.725900501402
    ## 5               0          gamma ~ Year 22.7856678360796
    ## 6               0             gamma ~ 1 20.8074006292247
    ## 7               1          gamma ~ Year 28.2645496804529
    ## 8               1             gamma ~ 1 24.3339857274651
    ## 9               0          gamma ~ Year 23.2606873836712
    ## 10              0             gamma ~ 1 21.2829126731327
    ## 11              1          gamma ~ Year 28.8263524448649
    ## 12              1             gamma ~ 1 24.8430374354481
    ## 13              0          gamma ~ year 46.7603849438612
    ## 14              0             gamma ~ 1 46.4294968557136
    ## 15              1          gamma ~ year 63.8974592088651
    ## 16              1             gamma ~ 1  51.012822995273
    ## 17              0          gamma ~ year 87.5251629854072
    ## 18              0             gamma ~ 1 83.9456385636223
    ## 19              1          gamma ~ year 104.090558662957
    ## 20              1             gamma ~ 1 91.1115551780236
    ## 21              0 gamma ~ newmoonnumber  907.42060599499
    ## 22              0             gamma ~ 1 964.518503589393
    ## 23              1 gamma ~ newmoonnumber 833.157943627904
    ## 24              1             gamma ~ 1 879.970374241956
    ## 25              0          gamma ~ year 75.4622276638085
    ## 26              0             gamma ~ 1 74.2479349754825
    ## 27              1          gamma ~ year 77.5588313944964
    ## 28              1             gamma ~ 1 70.7902507934726
    ## 29              0          gamma ~ year 45.1885461895395
    ## 30              0             gamma ~ 1 49.1690552038468
    ## 31              1          gamma ~ year 56.9672750571751
    ## 32              1             gamma ~ 1 52.1973113596636
    ## 33              0          gamma ~ year 146.754110474832
    ## 34              0             gamma ~ 1 168.853711874109
    ## 35              1          gamma ~ year 156.370908637551
    ## 36              1             gamma ~ 1 154.282873058565
    ## 37              0          gamma ~ year 169.507781310335
    ## 38              0             gamma ~ 1 171.169001369409
    ## 39              1          gamma ~ year 173.979568705203
    ## 40              1             gamma ~ 1 167.420667514501
    ## 41              0          gamma ~ year 151.327105023752
    ## 42              0             gamma ~ 1 165.925929252727
    ## 43              1          gamma ~ year 155.867976408158
    ## 44              1             gamma ~ 1 155.289894133638
    ## 45              0          gamma ~ year 150.622868811168
    ## 46              0             gamma ~ 1  169.01377893953
    ## 47              1          gamma ~ year 164.444366599116
    ## 48              1             gamma ~ 1  161.26789289604
    ## 49              0          gamma ~ year 133.254780576887
    ## 50              0             gamma ~ 1 131.214721288841
    ## 51              1          gamma ~ year 147.412073299668
    ## 52              1             gamma ~ 1 134.268761044883
    ## 53              0          gamma ~ Date 734.813855503195
    ## 54              0             gamma ~ 1 736.680706015929
    ## 55              1          gamma ~ Date 711.855849739728
    ## 56              1             gamma ~ 1 727.068006407062
    ## 57              0          gamma ~ Year 22.8239459585092
    ## 58              0             gamma ~ 1  20.843676737825
    ## 59              1          gamma ~ Year 28.3424677457338
    ## 60              1             gamma ~ 1 24.3979745736963
    ## 61              0          gamma ~ Year 23.2919305671471
    ## 62              0             gamma ~ 1 21.3138297968589
    ## 63              1          gamma ~ Year   28.89693935752
    ## 64              1             gamma ~ 1 24.9204207379343
    ## 65              0          gamma ~ year 44.9332129736748
    ## 66              0             gamma ~ 1 44.9022849163907
    ## 67              1          gamma ~ year 62.0845494614746
    ## 68              1             gamma ~ 1 50.2777804095527
    ## 69              0          gamma ~ year 87.5251629854072
    ## 70              0             gamma ~ 1 83.9456385636223
    ## 71              1          gamma ~ year 104.162558876812
    ## 72              1             gamma ~ 1 91.1730043501707
    ## 73              0 gamma ~ newmoonnumber 789.648581448797
    ## 74              0             gamma ~ 1 851.153765691357
    ## 75              1 gamma ~ newmoonnumber 721.165245115871
    ## 76              1             gamma ~ 1 765.859284222433
    ## 77              0          gamma ~ year 80.6963443984574
    ## 78              0             gamma ~ 1 75.4646364633585
    ## 79              1          gamma ~ year 94.5733392404435
    ## 80              1             gamma ~ 1 81.7194264316179
    ## 81              0          gamma ~ year 45.4866892366628
    ## 82              0             gamma ~ 1 47.4602154398704
    ## 83              1          gamma ~ year 57.7318389939762
    ## 84              1             gamma ~ 1 51.4323082741649
    ## 85              0          gamma ~ year 159.449593316464
    ## 86              0             gamma ~ 1 166.643364991291
    ## 87              1          gamma ~ year 154.801091225924
    ## 88              1             gamma ~ 1 152.773837177194
    ## 89              0          gamma ~ year 158.304110864321
    ## 90              0             gamma ~ 1 166.207110802679
    ## 91              1          gamma ~ year 166.399949234136
    ## 92              1             gamma ~ 1 160.127308365754
    ## 93              0          gamma ~ year 138.413116867296
    ## 94              0             gamma ~ 1 152.020301821771
    ## 95              1          gamma ~ year 149.323509534365
    ## 96              1             gamma ~ 1 145.385391977271
    ## 97              0          gamma ~ year  151.85512691743
    ## 98              0             gamma ~ 1 166.351146757248
    ## 99              1          gamma ~ year 162.467326615942
    ## 100             1             gamma ~ 1 159.209688952984
    ## 101             0          gamma ~ year 135.630588297252
    ## 102             0             gamma ~ 1 131.364164377792
    ## 103             1          gamma ~ year 149.553021576872
    ## 104             1             gamma ~ 1 135.954629716685
    ## 105             0          gamma ~ Date   1239.216283538
    ## 106             0             gamma ~ 1 1232.58903602349
    ## 107             1          gamma ~ Date 1246.09344787238
    ## 108             1             gamma ~ 1 1223.53725425431
    ## 109             0          gamma ~ Year  125.89881325928
    ## 110             0             gamma ~ 1 99.8988134974066
    ## 111             1          gamma ~ Year  179.89869192065
    ## 112             1             gamma ~ 1 127.898694115952
    ## 113             0          gamma ~ Year 125.893589099337
    ## 114             0             gamma ~ 1 99.8935887320816
    ## 115             1          gamma ~ Year 179.893288430917
    ## 116             1             gamma ~ 1 127.893272186277
    ## 117             0          gamma ~ year 98.3967318590179
    ## 118             0             gamma ~ 1 84.1730721271733
    ## 119             1          gamma ~ year 141.863955661727
    ## 120             1             gamma ~ 1 98.7436673338885
    ## 121             0          gamma ~ year 167.084747872161
    ## 122             0             gamma ~ 1 144.675170307421
    ## 123             1          gamma ~ year 218.239679944076
    ## 124             1             gamma ~ 1 169.429814315293
    ## 125             0 gamma ~ newmoonnumber  907.42060599499
    ## 126             0             gamma ~ 1 964.518503589393
    ## 127             1 gamma ~ newmoonnumber 833.581889857021
    ## 128             1             gamma ~ 1 880.024412978099
    ## 129             0          gamma ~ year 110.991333996799
    ## 130             0             gamma ~ 1 108.488587192427
    ## 131             1          gamma ~ year 122.708448902976
    ## 132             1             gamma ~ 1 112.505291697069
    ## 133             0          gamma ~ year 87.1827182320061
    ## 134             0             gamma ~ 1 70.8076353913618
    ## 135             1          gamma ~ year 136.154505873551
    ## 136             1             gamma ~ 1 92.7518362625268
    ## 137             0          gamma ~ year 260.754431324107
    ## 138             0             gamma ~ 1 259.202306757965
    ## 139             1          gamma ~ year 289.348200653281
    ## 140             1             gamma ~ 1   259.4510892594
    ## 141             0          gamma ~ year 316.069215166655
    ## 142             0             gamma ~ 1 290.094886665959
    ## 143             1          gamma ~ year 325.196908976053
    ## 144             1             gamma ~ 1 293.251647188004
    ## 145             0          gamma ~ year 262.971124018683
    ## 146             0             gamma ~ 1 245.052916300025
    ## 147             1          gamma ~ year 257.775885838842
    ## 148             1             gamma ~ 1 240.536315755145
    ## 149             0          gamma ~ year 315.801074488283
    ## 150             0             gamma ~ 1 289.847218958367
    ## 151             1          gamma ~ year  321.97240289206
    ## 152             1             gamma ~ 1 292.297048567697
    ## 153             0          gamma ~ year 225.663870407715
    ## 154             0             gamma ~ 1 205.663264146165
    ## 155             1          gamma ~ year 238.586858372848
    ## 156             1             gamma ~ 1 208.511182312966
    ## 157             0          gamma ~ Date 989.851073509306
    ## 158             0             gamma ~ 1 986.307762578459
    ## 159             1          gamma ~ Date 995.544275436371
    ## 160             1             gamma ~ 1 982.765646835214
    ## 161             0          gamma ~ Year 125.893554966168
    ## 162             0             gamma ~ 1 99.8935550803033
    ## 163             1          gamma ~ Year 179.893467537004
    ## 164             1             gamma ~ 1 127.893467941343
    ## 165             0          gamma ~ Year 125.893600527124
    ## 166             0             gamma ~ 1 99.8936004217578
    ## 167             1          gamma ~ Year 179.893446249715
    ## 168             1             gamma ~ 1 127.893445354198
    ## 169             0          gamma ~ year 98.3977764668427
    ## 170             0             gamma ~ 1 83.5611236171607
    ## 171             1          gamma ~ year 143.695470717659
    ## 172             1             gamma ~ 1 100.606982417171
    ## 173             0          gamma ~ year 167.084747872161
    ## 174             0             gamma ~ 1 144.675170307421
    ## 175             1          gamma ~ year 218.001163151946
    ## 176             1             gamma ~ 1 169.333556256046
    ## 177             0 gamma ~ newmoonnumber 789.648581448797
    ## 178             0             gamma ~ 1 851.153765691357
    ## 179             1 gamma ~ newmoonnumber 721.080854336598
    ## 180             1             gamma ~ 1 766.116736320108
    ## 181             0          gamma ~ year 138.490997496322
    ## 182             0             gamma ~ 1 118.549771685796
    ## 183             1          gamma ~ year   150.3782714043
    ## 184             1             gamma ~ 1 122.990290941895
    ## 185             0          gamma ~ year 91.0366137075872
    ## 186             0             gamma ~ 1 70.0473036216218
    ## 187             1          gamma ~ year 135.577523881735
    ## 188             1             gamma ~ 1 93.1489889407429
    ## 189             0          gamma ~ year  305.81889253567
    ## 190             0             gamma ~ 1 279.868505580234
    ## 191             1          gamma ~ year 320.217753002398
    ## 192             1             gamma ~ 1 282.304070709757
    ## 193             0          gamma ~ year 317.212243054012
    ## 194             0             gamma ~ 1 291.235939792204
    ## 195             1          gamma ~ year 326.226053798359
    ## 196             1             gamma ~ 1 294.414869726277
    ## 197             0          gamma ~ year 237.416368041065
    ## 198             0             gamma ~ 1 242.152317142904
    ## 199             1          gamma ~ year 265.336210549143
    ## 200             1             gamma ~ 1 241.625702243085
    ## 201             0          gamma ~ year 333.482006750493
    ## 202             0             gamma ~ 1 303.541808471769
    ## 203             1          gamma ~ year 354.152645738136
    ## 204             1             gamma ~ 1 314.193015868083
    ## 205             0          gamma ~ year 244.089991851359
    ## 206             0             gamma ~ 1 220.080252919988
    ## 207             1          gamma ~ year 268.631256006353
    ## 208             1             gamma ~ 1 230.313802194873
