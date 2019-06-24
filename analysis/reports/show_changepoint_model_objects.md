Changepoint model objects
================
Renata Diaz
10/12/2018

Read in the results
-------------------

``` r
# define where the cache is located
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("drake", "drake-cache.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)
```

Portal:

``` r
ts_select_ts_portal_data_lda_portal_data <- readd(ts_select_ts_portal_data_lda_portal_data,
                                                  cache = cache)

print(ts_select_ts_portal_data_lda_portal_data$formula)
```

    ## gamma ~ newmoonnumber
    ## <environment: 0x7f89991accf0>

``` r
print(ts_select_ts_portal_data_lda_portal_data$control)
```

    ## $memoise
    ## [1] TRUE
    ## 
    ## $response
    ## [1] "gamma"
    ## 
    ## $timename
    ## [1] "newmoonnumber"
    ## 
    ## $lambda
    ## [1] 0
    ## 
    ## $measurer
    ## function (object, ..., k = 2) 
    ## UseMethod("AIC")
    ## <environment: namespace:stats>
    ## 
    ## $selector
    ## function (..., na.rm = FALSE)  .Primitive("min")
    ## 
    ## $ntemps
    ## [1] 6
    ## 
    ## $penultimate_temp
    ## [1] 64
    ## 
    ## $ultimate_temp
    ## [1] 1e+10
    ## 
    ## $q
    ## [1] 0
    ## 
    ## $nit
    ## [1] 1000
    ## 
    ## $magnitude
    ## [1] 9
    ## 
    ## $quiet
    ## [1] FALSE
    ## 
    ## $burnin
    ## [1] 0
    ## 
    ## $thin_frac
    ## [1] 1
    ## 
    ## $summary_prob
    ## [1] 0.95
    ## 
    ## $seed
    ## NULL
    ## 
    ## attr(,"class")
    ## [1] "TS_controls" "list"

``` r
print(ts_select_ts_portal_data_lda_portal_data$ptMCMC_diagnostics)
```

    ## $step_acceptance_rate
    ## [1] 0.204 0.645 0.886 0.951 0.954 0.945
    ## 
    ## $swap_acceptance_rate
    ## [1] 0.126 0.310 0.753 0.886 0.944
    ## 
    ## $trip_counts
    ## [1] 4 4 2 5 2 3
    ## 
    ## $trip_rates
    ## [1] 0.004 0.004 0.002 0.005 0.002 0.003

``` r
print(plot(ts_select_ts_portal_data_lda_portal_data))
```

![](show_changepoint_model_objects_files/figure-markdown_github/portal%20TS%20select-1.png)

    ## NULL

BBS rtrg\_1\_11:

``` r
ts_select_ts_bbs_data_rtrg_1_11_lda_bbs_data_rtrg_1_11 <- readd(ts_select_ts_bbs_data_rtrg_1_11_lda_bbs_data_rtrg_1_11,
                                                  cache = cache)

print(ts_select_ts_bbs_data_rtrg_1_11_lda_bbs_data_rtrg_1_11$formula)
```

    ## gamma ~ year
    ## <environment: 0x7f899f3ad130>

``` r
print(ts_select_ts_bbs_data_rtrg_1_11_lda_bbs_data_rtrg_1_11$control)
```

    ## $memoise
    ## [1] TRUE
    ## 
    ## $response
    ## [1] "gamma"
    ## 
    ## $timename
    ## [1] "year"
    ## 
    ## $lambda
    ## [1] 0
    ## 
    ## $measurer
    ## function (object, ..., k = 2) 
    ## UseMethod("AIC")
    ## <environment: namespace:stats>
    ## 
    ## $selector
    ## function (..., na.rm = FALSE)  .Primitive("min")
    ## 
    ## $ntemps
    ## [1] 6
    ## 
    ## $penultimate_temp
    ## [1] 64
    ## 
    ## $ultimate_temp
    ## [1] 1e+10
    ## 
    ## $q
    ## [1] 0
    ## 
    ## $nit
    ## [1] 1000
    ## 
    ## $magnitude
    ## [1] 1
    ## 
    ## $quiet
    ## [1] FALSE
    ## 
    ## $burnin
    ## [1] 0
    ## 
    ## $thin_frac
    ## [1] 1
    ## 
    ## $summary_prob
    ## [1] 0.95
    ## 
    ## $seed
    ## NULL
    ## 
    ## attr(,"class")
    ## [1] "TS_controls" "list"

``` r
print(ts_select_ts_bbs_data_rtrg_1_11_lda_bbs_data_rtrg_1_11$ptMCMC_diagnostics)
```

    ## NULL

``` r
print(plot(ts_select_ts_bbs_data_rtrg_1_11_lda_bbs_data_rtrg_1_11))
```

![](show_changepoint_model_objects_files/figure-markdown_github/BBS%20rtrg1_11-1.png)

    ## NULL

``` r
ts_select_ts_bbs_data_rtrg_2_11_lda_bbs_data_rtrg_2_11 <- readd(ts_select_ts_bbs_data_rtrg_2_11_lda_bbs_data_rtrg_2_11,
                                                  cache = cache)

print(ts_select_ts_bbs_data_rtrg_2_11_lda_bbs_data_rtrg_2_11$formula)
```

    ## gamma ~ year
    ## <environment: 0x7f899d4a6b70>

``` r
print(ts_select_ts_bbs_data_rtrg_2_11_lda_bbs_data_rtrg_2_11$control)
```

    ## $memoise
    ## [1] TRUE
    ## 
    ## $response
    ## [1] "gamma"
    ## 
    ## $timename
    ## [1] "year"
    ## 
    ## $lambda
    ## [1] 0
    ## 
    ## $measurer
    ## function (object, ..., k = 2) 
    ## UseMethod("AIC")
    ## <environment: namespace:stats>
    ## 
    ## $selector
    ## function (..., na.rm = FALSE)  .Primitive("min")
    ## 
    ## $ntemps
    ## [1] 6
    ## 
    ## $penultimate_temp
    ## [1] 64
    ## 
    ## $ultimate_temp
    ## [1] 1e+10
    ## 
    ## $q
    ## [1] 0
    ## 
    ## $nit
    ## [1] 1000
    ## 
    ## $magnitude
    ## [1] 1
    ## 
    ## $quiet
    ## [1] FALSE
    ## 
    ## $burnin
    ## [1] 0
    ## 
    ## $thin_frac
    ## [1] 1
    ## 
    ## $summary_prob
    ## [1] 0.95
    ## 
    ## $seed
    ## NULL
    ## 
    ## attr(,"class")
    ## [1] "TS_controls" "list"

``` r
print(ts_select_ts_bbs_data_rtrg_2_11_lda_bbs_data_rtrg_2_11$ptMCMC_diagnostics)
```

    ## $step_acceptance_rate
    ## [1] 0.714 0.880 0.917 0.952 0.964 0.965
    ## 
    ## $swap_acceptance_rate
    ## [1] 0.596 0.760 0.877 0.932 0.969
    ## 
    ## $trip_counts
    ## [1] 82 60 59 30 44 73
    ## 
    ## $trip_rates
    ## [1] 0.082 0.060 0.059 0.030 0.044 0.073

``` r
print(plot(ts_select_ts_bbs_data_rtrg_2_11_lda_bbs_data_rtrg_2_11))
```

![](show_changepoint_model_objects_files/figure-markdown_github/BBS%20rtrg2_11-1.png)

    ## NULL
