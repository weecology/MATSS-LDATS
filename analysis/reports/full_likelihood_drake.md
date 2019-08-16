Full likelihood report
================
Renata Diaz
8/6/2019

``` r
full_lik_expanded <- lapply(full_lik_results, FUN = expand_full_lik_results) %>%
    dplyr::bind_rows(.id = "data_name") %>%
    dplyr::mutate(data_name = vapply(data_name, FUN = function(X) return(unlist(strsplit(X, split = "lda_"))[[2]]), FUN.VALUE = "mtquad"),
                  ts_model_desc = paste0(changepoints, "; ", formula))
```

``` r
library(ggplot2)


make_aic_plot <- function(model_data) {
    ggplot(data = model_data, aes(x = ts_model_desc, y = TS_AICc, colour = as.character(k))) + 
        geom_violin(stat = "ydensity") +
        theme_bw() +
        facet_wrap(facets = data_name ~ .)
}

AIC_plots <- lapply(unique(full_lik_expanded$data_name),
                    FUN = function(dat_name) return(make_aic_plot(dplyr::filter(full_lik_expanded, data_name == dat_name))))

gridExtra::grid.arrange(grobs = AIC_plots, ncol = 1)
```

![](full_likelihood_drake_files/figure-markdown_github/plot%20AICcs-1.png)
