Full likelihood report
================
Renata Diaz
8/6/2019

``` r
full_lik_expanded <- lapply(full_lik_results, FUN = expand_full_lik_results) %>%
    dplyr::bind_rows(.id = "data_name") %>%
    dplyr::mutate(data_name = vapply(data_name, FUN = function(X) return(unlist(strsplit(X, split = "lda_"))[[2]]), FUN.VALUE = "mtquad"),
                  ts_model_desc = paste0(changepoints, "; ", formula),
                  k = as.character(k))
```

``` r
library(ggplot2)


make_aic_plot <- function(model_data) {
    ggplot(data = model_data, aes(x = ts_model_desc, y = TS_AICc, colour = k)) + 
        geom_violin(stat = "ydensity") +
        theme_bw() +
        facet_wrap(facets = data_name ~ .)
}

AIC_plots <- lapply(unique(full_lik_expanded$data_name),
                    FUN = function(dat_name) return(make_aic_plot(dplyr::filter(full_lik_expanded, data_name == dat_name))))

gridExtra::grid.arrange(grobs = AIC_plots, ncol = 1)
```

![](full_likelihood_drake_files/figure-markdown_github/plot%20AICcs-1.png)

``` r
pred_results <- readd(pred_results, cache = cache)

plot_obs_pred <- function(obs_pred_data) {
    
    obs_pred_plot <- ggplot2::ggplot(data = obs_pred_data, aes(x = timestep, y = abundance, color = source)) +
        ggplot2::geom_line() +
        ggplot2::theme_bw() +
        ggplot2::facet_wrap(facets = species ~ .) +
        ggplot2::ggtitle(obs_pred_data$model_name[1])

    return(obs_pred_plot)
}


plot_all_model_preds <- function(list_of_predictions) {
    all_plots <- lapply(list_of_predictions$prediction, FUN = plot_obs_pred)
    return(all_plots)
}

all_plots_all_pred <- lapply(pred_results, plot_all_model_preds)

for(i in 1:length(all_plots_all_pred)) {
gridExtra::grid.arrange(grobs = all_plots_all_pred[[i]], ncol = 1)
}
```

![](full_likelihood_drake_files/figure-markdown_github/plot%20observed%20v%20predicted-1.png)![](full_likelihood_drake_files/figure-markdown_github/plot%20observed%20v%20predicted-2.png)
