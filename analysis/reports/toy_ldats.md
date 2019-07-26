Playing with LDA\_TS fits
================
Renata Diaz
7/26/2019

``` r
dat <- get_portal_rodents()
```

``` r
dat_lda <- matssldats::run_LDA(data = dat, max_topics = 3, nseeds = 1)
```

``` r
dat_ts <- matssldats::run_TS(data = dat,ldamodels = dat_lda, nchangepoints = c(0, 1), 
                             weighting = "proportional", control = list(nit = 100))
```

``` r
load(here::here("analysis", "reports", "toy_ldats_stash", "toy_ldats_stash.RData"))
```

``` r
for(i in 1:length(dat_lda)) {
    plot(dat_lda[[i]])

    ntopics <- dat_lda[[i]]@k
    
    for(j in 1:length(dat_ts)) {
        ts_topics <- ncol(dat_ts[[j]]$data$gamma)
        if(ts_topics == ntopics) {
            plot(dat_ts[[j]])
        }
    }
}
```

![](toy_ldats_files/figure-markdown_github/plot%20LDAs%20and%20TS%20fits%20for%20each%20combination-1.png)![](toy_ldats_files/figure-markdown_github/plot%20LDAs%20and%20TS%20fits%20for%20each%20combination-2.png)![](toy_ldats_files/figure-markdown_github/plot%20LDAs%20and%20TS%20fits%20for%20each%20combination-3.png)![](toy_ldats_files/figure-markdown_github/plot%20LDAs%20and%20TS%20fits%20for%20each%20combination-4.png)![](toy_ldats_files/figure-markdown_github/plot%20LDAs%20and%20TS%20fits%20for%20each%20combination-5.png)![](toy_ldats_files/figure-markdown_github/plot%20LDAs%20and%20TS%20fits%20for%20each%20combination-6.png)![](toy_ldats_files/figure-markdown_github/plot%20LDAs%20and%20TS%20fits%20for%20each%20combination-7.png)![](toy_ldats_files/figure-markdown_github/plot%20LDAs%20and%20TS%20fits%20for%20each%20combination-8.png)![](toy_ldats_files/figure-markdown_github/plot%20LDAs%20and%20TS%20fits%20for%20each%20combination-9.png)![](toy_ldats_files/figure-markdown_github/plot%20LDAs%20and%20TS%20fits%20for%20each%20combination-10.png)
