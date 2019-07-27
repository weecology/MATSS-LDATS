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

These TS models ran successfully:

Find TS models that threw errors in selection and remove them:

These TS models were selected correctly:

Community-level results
-----------------------

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

![](ts_report_files/figure-markdown_github/detailed%20ts%20model%20results-1.png)![](ts_report_files/figure-markdown_github/detailed%20ts%20model%20results-2.png)

``` r
lda_ts_result_summary$filtered_topics <- paste(lda_ts_result_summary$filtered, 
                                               lda_ts_result_summary$topics,
                                               sep= "_")

ncpts_lot <- ggplot(data = lda_ts_result_summary, aes(x = maxtopics, y = nchangepoints, color = gen_formula)) +
    geom_jitter(height = 0) +
    theme(legend.position = "none")  +
    theme_bw() +
    facet_wrap(facets = filtered ~ .)
ncpts_lot
```

    ## Warning: Removed 8 rows containing missing values (geom_point).

![](ts_report_files/figure-markdown_github/ncpts-1.png)

    ## Warning in dir.create(here::here("analysis", "reports", "lda_ts_plots")):
    ## '/Users/renatadiaz/Documents/GitHub/weecology/MATSS-LDATS/analysis/reports/
    ## lda_ts_plots' already exists

![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-1.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-2.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-3.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-4.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-5.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-6.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-7.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-8.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-9.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-10.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-11.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-12.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-13.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-14.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-15.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-16.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-17.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-18.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-19.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-20.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-21.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-22.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-23.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-24.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-25.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-26.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-27.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-28.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-29.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-30.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-31.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-32.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-33.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-34.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-35.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-36.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-37.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-38.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-39.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-40.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-41.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-42.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-43.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-44.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-45.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-46.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-47.png)![](ts_report_files/figure-markdown_github/plot%20LDAs%20+%20cpt%20estimates-48.png)
