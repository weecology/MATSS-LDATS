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

ts_result_summary <- readd(ts_result_summary, cache = cache)

print(ts_result_summary)
```

    ##    ts_name nchangepoints
    ## 1  default             5
    ## 2  newmoon             2
    ## 3    month             4
    ## 4 timestep             2

Default = `formula = ~1`.
