Summary report
================
Renata Diaz
8/19/2019

AICc: All models, all k, all seeds
----------------------------------

### Mean AICcs

![](summary_report_files/figure-markdown_github/plot%20mean%20AICcs-1.png)

### Median AICcs

![](summary_report_files/figure-markdown_github/plot%20median%20AICcs-1.png)

Best AICcs for each dataset
---------------------------

![](summary_report_files/figure-markdown_github/plot%20best%20AICc-1.png)

Predicted abundances for all species
------------------------------------

### Best TS + LDA model

![](summary_report_files/figure-markdown_github/plot%20best%20observed%20v%20predicted-1.png)![](summary_report_files/figure-markdown_github/plot%20best%20observed%20v%20predicted-2.png)

LDA + TS plots for best predictions
-----------------------------------

``` r
loadd(c(best_ts_models[[1]]$ts_object_name,
        best_ts_models[[1]]$lda_object_name,
        best_ts_models[[2]]$ts_object_name,
        best_ts_models[[2]]$lda_object_name), character_only = T, cache = cache)
```

### Portal - 12 topics, 0; gamma ~ year

![](summary_report_files/figure-markdown_github/plot%20portal%20best-1.png)![](summary_report_files/figure-markdown_github/plot%20portal%20best-2.png)

### BBS - 3 topics, 0; gamma ~ year

![](summary_report_files/figure-markdown_github/plot%20bbs%20best-1.png)![](summary_report_files/figure-markdown_github/plot%20bbs%20best-2.png)

Assorted other plots
--------------------

### Portal with 6 topics

![](summary_report_files/figure-markdown_github/get%20portal%20best%20with%206-1.png)![](summary_report_files/figure-markdown_github/get%20portal%20best%20with%206-2.png)![](summary_report_files/figure-markdown_github/get%20portal%20best%20with%206-3.png)
