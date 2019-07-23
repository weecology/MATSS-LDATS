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

Summarize LDA results
---------------------

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
    ##    ntimeseries ntimesteps filtered           data_name
    ## 1           15        285 complete        maizuru_data
    ## 2           17         24 complete        jornada_data
    ## 3           11         13 complete            sgs_data
    ## 4            6         14 complete cowley_lizards_data
    ## 5           16         14 complete  cowley_snakes_data
    ## 6           16         13 complete          karoo_data
    ## 7           12         31 complete         kruger_data
    ## 8           21        319 complete         portal_data
    ## 9           98         22 complete            sdl_data
    ## 10          42         14 complete         mtquad_data
    ## 11          99         51 complete  bbs_data_rtrg_1_11
    ## 12         120         51 complete  bbs_data_rtrg_2_11
    ## 13         115         51 complete  bbs_data_rtrg_3_11
    ## 14         113         51 complete  bbs_data_rtrg_4_11
    ## 15          81         40 complete  bbs_data_rtrg_6_11
    ## 16          10        285 filtered        maizuru_data
    ## 17          13         24 filtered        jornada_data
    ## 18           7         13 filtered            sgs_data
    ## 19           4         14 filtered cowley_lizards_data
    ## 20          11         14 filtered  cowley_snakes_data
    ## 21          13         13 filtered          karoo_data
    ## 22          12         31 filtered         kruger_data
    ## 23          11        319 filtered         portal_data
    ## 24          39         22 filtered            sdl_data
    ## 25          24         14 filtered         mtquad_data
    ## 26          59         51 filtered  bbs_data_rtrg_1_11
    ## 27          72         51 filtered  bbs_data_rtrg_2_11
    ## 28          68         51 filtered  bbs_data_rtrg_3_11
    ## 29          58         51 filtered  bbs_data_rtrg_4_11
    ## 30          53         40 filtered  bbs_data_rtrg_6_11
    ## 31          15        285 complete        maizuru_data
    ## 32          17         24 complete        jornada_data
    ## 33          11         13 complete            sgs_data
    ## 34           6         14 complete cowley_lizards_data
    ## 35          16         14 complete  cowley_snakes_data
    ## 36          16         13 complete          karoo_data
    ## 37          12         31 complete         kruger_data
    ## 38          21        319 complete         portal_data
    ## 39          98         22 complete            sdl_data
    ## 40          42         14 complete         mtquad_data
    ## 41          99         51 complete  bbs_data_rtrg_1_11
    ## 42         120         51 complete  bbs_data_rtrg_2_11
    ## 43         115         51 complete  bbs_data_rtrg_3_11
    ## 44         113         51 complete  bbs_data_rtrg_4_11
    ## 45          81         40 complete  bbs_data_rtrg_6_11
    ## 46          10        285 filtered        maizuru_data
    ## 47          13         24 filtered        jornada_data
    ## 48           7         13 filtered            sgs_data
    ## 49           4         14 filtered cowley_lizards_data
    ## 50          11         14 filtered  cowley_snakes_data
    ## 51          13         13 filtered          karoo_data
    ## 52          12         31 filtered         kruger_data
    ## 53          11        319 filtered         portal_data
    ## 54          39         22 filtered            sdl_data
    ## 55          24         14 filtered         mtquad_data
    ## 56          59         51 filtered  bbs_data_rtrg_1_11
    ## 57          72         51 filtered  bbs_data_rtrg_2_11
    ## 58          68         51 filtered  bbs_data_rtrg_3_11
    ## 59          58         51 filtered  bbs_data_rtrg_4_11
    ## 60          53         40 filtered  bbs_data_rtrg_6_11
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
    ##    nchangepoints               formula  gen_formula
    ## 1              1          gamma ~ Date gamma ~ time
    ## 2             NA                  <NA>         <NA>
    ## 3             NA                  <NA>         <NA>
    ## 4              0             gamma ~ 1    gamma ~ 1
    ## 5              0             gamma ~ 1    gamma ~ 1
    ## 6              0             gamma ~ 1    gamma ~ 1
    ## 7              0             gamma ~ 1    gamma ~ 1
    ## 8              1 gamma ~ newmoonnumber gamma ~ time
    ## 9              1             gamma ~ 1    gamma ~ 1
    ## 10             0          gamma ~ year gamma ~ time
    ## 11             0          gamma ~ year gamma ~ time
    ## 12             1             gamma ~ 1    gamma ~ 1
    ## 13             0          gamma ~ year gamma ~ time
    ## 14             0          gamma ~ year gamma ~ time
    ## 15             0             gamma ~ 1    gamma ~ 1
    ## 16             1          gamma ~ Date gamma ~ time
    ## 17            NA                  <NA>         <NA>
    ## 18            NA                  <NA>         <NA>
    ## 19             0             gamma ~ 1    gamma ~ 1
    ## 20             0             gamma ~ 1    gamma ~ 1
    ## 21             0             gamma ~ 1    gamma ~ 1
    ## 22             0             gamma ~ 1    gamma ~ 1
    ## 23             1 gamma ~ newmoonnumber gamma ~ time
    ## 24             0             gamma ~ 1    gamma ~ 1
    ## 25             0          gamma ~ year gamma ~ time
    ## 26             1             gamma ~ 1    gamma ~ 1
    ## 27             0          gamma ~ year gamma ~ time
    ## 28             0          gamma ~ year gamma ~ time
    ## 29             0          gamma ~ year gamma ~ time
    ## 30             0             gamma ~ 1    gamma ~ 1
    ## 31             1             gamma ~ 1    gamma ~ 1
    ## 32            NA                  <NA>         <NA>
    ## 33            NA                  <NA>         <NA>
    ## 34             0             gamma ~ 1    gamma ~ 1
    ## 35             0             gamma ~ 1    gamma ~ 1
    ## 36             0             gamma ~ 1    gamma ~ 1
    ## 37             0             gamma ~ 1    gamma ~ 1
    ## 38             1 gamma ~ newmoonnumber gamma ~ time
    ## 39             0             gamma ~ 1    gamma ~ 1
    ## 40             0             gamma ~ 1    gamma ~ 1
    ## 41             0             gamma ~ 1    gamma ~ 1
    ## 42             0             gamma ~ 1    gamma ~ 1
    ## 43             1             gamma ~ 1    gamma ~ 1
    ## 44             0             gamma ~ 1    gamma ~ 1
    ## 45             0             gamma ~ 1    gamma ~ 1
    ## 46             1             gamma ~ 1    gamma ~ 1
    ## 47            NA                  <NA>         <NA>
    ## 48            NA                  <NA>         <NA>
    ## 49             0             gamma ~ 1    gamma ~ 1
    ## 50             0             gamma ~ 1    gamma ~ 1
    ## 51             0             gamma ~ 1    gamma ~ 1
    ## 52             0             gamma ~ 1    gamma ~ 1
    ## 53             1 gamma ~ newmoonnumber gamma ~ time
    ## 54             0             gamma ~ 1    gamma ~ 1
    ## 55             0             gamma ~ 1    gamma ~ 1
    ## 56             0             gamma ~ 1    gamma ~ 1
    ## 57             0             gamma ~ 1    gamma ~ 1
    ## 58             0          gamma ~ year gamma ~ time
    ## 59             0             gamma ~ 1    gamma ~ 1
    ## 60             0             gamma ~ 1    gamma ~ 1
