24 hours progress
================
Renata Diaz
9/2/2019

``` r
finished_targets <- cached(cache = cache)

all_targets <- pipeline$target

progress <- intersect(finished_targets, all_targets)
remain <- setdiff(all_targets, finished_targets)

remain_summary <- data.frame(
    full_name = remain,
    start = substr(remain, 0, 3)
)

library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
remain_summary <- remain_summary %>%
    group_by(start) %>%
    summarize(count = n()) %>%
    ungroup()

done_summary <- data.frame(
    full_name = finished_targets,
    start = substr(finished_targets, 0, 3)
)

done_summary <- done_summary %>%
    group_by(start) %>%
    summarize(count = n()) %>%
    ungroup()
```

### Completed targets summary

``` r
print(done_summary)
```

    ## # A tibble: 4 x 2
    ##   start count
    ##   <fct> <int>
    ## 1 dat      28
    ## 2 lda    2240
    ## 3 por       1
    ## 4 ts_    1607

In 24 hours, did all LDA models and 1600 ts models (with 16 workers).

### Remaining targets summary

``` r
print(remain_summary)
```

    ## # A tibble: 3 x 2
    ##   start count
    ##   <fct> <int>
    ## 1 lda       1
    ## 2 mod       1
    ## 3 ts_     634

634 ts models remain, and I increased it to 32 workers.

So I expect this last leg to take a maximum of 6 hours. That's calculated conservatively assuming that the 1600 ts models took all 24 hours.
