Time format
================
Renata Diaz
6/5/2019

This is a quick report on which datasets have non-integer timesteps. It is not meant to be included in the pipeline. This branch should not be merged.

``` r
time_check_results[which(!(unlist(time_check_results)))]
```

    ## $time_check_jornada_data
    ## [1] FALSE
    ## 
    ## $time_check_sgs_data
    ## [1] FALSE

``` r
jornada_data <- readd(jornada_data, cache = cache)
jornada_data$metadata$timename
```

    ## [1] "time"

``` r
jornada_data$covariates$time
```

    ##  [1] 1995.5 1995.0 1996.5 1996.0 1997.5 1997.0 1998.5 1998.0 1999.5 1999.0
    ## [11] 2000.5 2000.0 2001.5 2001.0 2002.5 2002.0 2003.5 2003.0 2004.5 2004.0
    ## [21] 2005.5 2005.0 2006.5 2007.5

``` r
sgs_data <- readd(sgs_data, cache = cache)
sgs_data$metadata$timename
```

    ## [1] "samples"

``` r
sgs_data$covariates$samples
```

    ##  [1] 1994.5 1995.0 1995.5 1996.0 1996.5 1997.0 1997.5 1998.0 1998.5 1999.0
    ## [11] 1999.5 2000.0 2000.5

Both sites have years evaluated at intervals of .5.
