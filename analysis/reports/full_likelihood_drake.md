Full likelihood report
================
Renata Diaz
8/6/2019

``` r
full_lik_expanded <- lapply(full_lik_results, FUN = expand_full_lik_results) %>%
    dplyr::bind_rows(.id = "data_name") %>%
    dplyr::mutate(data_name = vapply(data_name, FUN = function(X) return(unlist(strsplit(X, split = "lda_"))[[2]]), FUN.VALUE = "mtquad"),
                  ts_model_desc = paste0(changepoints, "; ", formula),
                  k = as.character(k),
                  seed = as.character(seed)) %>%
    dplyr::mutate(data_name = vapply(data_name, FUN = function(X) 
        return(substr(X, start = 0, stop = (max(gregexpr('_', X)[[1]]) - 1))), FUN.VALUE = "mt"))

max_k <- max(as.numeric(full_lik_expanded$k))
max_seed <- length(unique(full_lik_expanded$seed))
```

``` r
library(ggplot2)


make_aic_plot <- function(model_data) {
    ggplot(data = model_data, aes(x = seed, y = TS_AICc, colour = seed)) + 
        geom_violin(stat = "ydensity") +
        theme_bw() +
        facet_grid(rows = vars(ts_model_desc), cols = vars(k), scales = "fixed", switch = "y") +
        ggtitle(label = model_data$data_name[1]) +
        theme(legend.position = "none")
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
