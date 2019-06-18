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

timename_result_summary <- readd(timename_result_summary, cache = cache)
timestep_result_summary <- readd(timestep_result_summary, cache = cache)
normalnoise_result_summary <- readd(normalnoise_result_summary, cache = cache)

print(timename_result_summary)
```

    ##                                                                               ts_name
    ## 1                ts_select_timename_ts_timename_cov_maizuru_data_lda_cov_maizuru_data
    ## 2                ts_select_timename_ts_timename_cov_jornada_data_lda_cov_jornada_data
    ## 3                        ts_select_timename_ts_timename_cov_sgs_data_lda_cov_sgs_data
    ## 4  ts_select_timename_ts_timename_cov_cowley_lizards_data_lda_cov_cowley_lizards_data
    ## 5    ts_select_timename_ts_timename_cov_cowley_snakes_data_lda_cov_cowley_snakes_data
    ## 6                    ts_select_timename_ts_timename_cov_karoo_data_lda_cov_karoo_data
    ## 7                  ts_select_timename_ts_timename_cov_kruger_data_lda_cov_kruger_data
    ## 8                  ts_select_timename_ts_timename_cov_portal_data_lda_cov_portal_data
    ## 9                        ts_select_timename_ts_timename_cov_sdl_data_lda_cov_sdl_data
    ## 10                 ts_select_timename_ts_timename_cov_mtquad_data_lda_cov_mtquad_data
    ## 11   ts_select_timename_ts_timename_cov_bbs_data_rtrg_1_11_lda_cov_bbs_data_rtrg_1_11
    ## 12   ts_select_timename_ts_timename_cov_bbs_data_rtrg_2_11_lda_cov_bbs_data_rtrg_2_11
    ## 13   ts_select_timename_ts_timename_cov_bbs_data_rtrg_3_11_lda_cov_bbs_data_rtrg_3_11
    ## 14   ts_select_timename_ts_timename_cov_bbs_data_rtrg_4_11_lda_cov_bbs_data_rtrg_4_11
    ## 15   ts_select_timename_ts_timename_cov_bbs_data_rtrg_6_11_lda_cov_bbs_data_rtrg_6_11
    ##    nchangepoints
    ## 1              3
    ## 2             NA
    ## 3             NA
    ## 4              0
    ## 5              0
    ## 6              0
    ## 7              0
    ## 8              3
    ## 9              0
    ## 10             0
    ## 11             0
    ## 12             1
    ## 13             0
    ## 14             0
    ## 15             0

``` r
print(timestep_result_summary)
```

    ##                                                                               ts_name
    ## 1                ts_select_timestep_ts_timestep_cov_maizuru_data_lda_cov_maizuru_data
    ## 2                ts_select_timestep_ts_timestep_cov_jornada_data_lda_cov_jornada_data
    ## 3                        ts_select_timestep_ts_timestep_cov_sgs_data_lda_cov_sgs_data
    ## 4  ts_select_timestep_ts_timestep_cov_cowley_lizards_data_lda_cov_cowley_lizards_data
    ## 5    ts_select_timestep_ts_timestep_cov_cowley_snakes_data_lda_cov_cowley_snakes_data
    ## 6                    ts_select_timestep_ts_timestep_cov_karoo_data_lda_cov_karoo_data
    ## 7                  ts_select_timestep_ts_timestep_cov_kruger_data_lda_cov_kruger_data
    ## 8                  ts_select_timestep_ts_timestep_cov_portal_data_lda_cov_portal_data
    ## 9                        ts_select_timestep_ts_timestep_cov_sdl_data_lda_cov_sdl_data
    ## 10                 ts_select_timestep_ts_timestep_cov_mtquad_data_lda_cov_mtquad_data
    ## 11   ts_select_timestep_ts_timestep_cov_bbs_data_rtrg_1_11_lda_cov_bbs_data_rtrg_1_11
    ## 12   ts_select_timestep_ts_timestep_cov_bbs_data_rtrg_2_11_lda_cov_bbs_data_rtrg_2_11
    ## 13   ts_select_timestep_ts_timestep_cov_bbs_data_rtrg_3_11_lda_cov_bbs_data_rtrg_3_11
    ## 14   ts_select_timestep_ts_timestep_cov_bbs_data_rtrg_4_11_lda_cov_bbs_data_rtrg_4_11
    ## 15   ts_select_timestep_ts_timestep_cov_bbs_data_rtrg_6_11_lda_cov_bbs_data_rtrg_6_11
    ##    nchangepoints
    ## 1              3
    ## 2             NA
    ## 3             NA
    ## 4              0
    ## 5              0
    ## 6              0
    ## 7              0
    ## 8              2
    ## 9              0
    ## 10             0
    ## 11             0
    ## 12             0
    ## 13             0
    ## 14             0
    ## 15             0

``` r
print(normalnoise_result_summary)
```

    ##                                                                                     ts_name
    ## 1                ts_select_normalnoise_ts_normalnoise_cov_maizuru_data_lda_cov_maizuru_data
    ## 2                ts_select_normalnoise_ts_normalnoise_cov_jornada_data_lda_cov_jornada_data
    ## 3                        ts_select_normalnoise_ts_normalnoise_cov_sgs_data_lda_cov_sgs_data
    ## 4  ts_select_normalnoise_ts_normalnoise_cov_cowley_lizards_data_lda_cov_cowley_lizards_data
    ## 5    ts_select_normalnoise_ts_normalnoise_cov_cowley_snakes_data_lda_cov_cowley_snakes_data
    ## 6                    ts_select_normalnoise_ts_normalnoise_cov_karoo_data_lda_cov_karoo_data
    ## 7                  ts_select_normalnoise_ts_normalnoise_cov_kruger_data_lda_cov_kruger_data
    ## 8                  ts_select_normalnoise_ts_normalnoise_cov_portal_data_lda_cov_portal_data
    ## 9                        ts_select_normalnoise_ts_normalnoise_cov_sdl_data_lda_cov_sdl_data
    ## 10                 ts_select_normalnoise_ts_normalnoise_cov_mtquad_data_lda_cov_mtquad_data
    ## 11   ts_select_normalnoise_ts_normalnoise_cov_bbs_data_rtrg_1_11_lda_cov_bbs_data_rtrg_1_11
    ## 12   ts_select_normalnoise_ts_normalnoise_cov_bbs_data_rtrg_2_11_lda_cov_bbs_data_rtrg_2_11
    ## 13   ts_select_normalnoise_ts_normalnoise_cov_bbs_data_rtrg_3_11_lda_cov_bbs_data_rtrg_3_11
    ## 14   ts_select_normalnoise_ts_normalnoise_cov_bbs_data_rtrg_4_11_lda_cov_bbs_data_rtrg_4_11
    ## 15   ts_select_normalnoise_ts_normalnoise_cov_bbs_data_rtrg_6_11_lda_cov_bbs_data_rtrg_6_11
    ##    nchangepoints
    ## 1              2
    ## 2             NA
    ## 3             NA
    ## 4              0
    ## 5              0
    ## 6              0
    ## 7              0
    ## 8              4
    ## 9              0
    ## 10             0
    ## 11             1
    ## 12             0
    ## 13             0
    ## 14             1
    ## 15             0

Default = `formula = ~1`.
