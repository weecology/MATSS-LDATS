K comparison
================
Renata Diaz
8/23/2019

Predicted absolute abundances: Portal, 3, 6, 9, 12 topics
---------------------------------------------------------

``` r
portal_model_summary <- model_summary %>%
    filter(data_object_name == "portal_ann_data", 
           changepoints == 0,
           formula == "gamma ~ year",
           k %in% c(3, 6, 9, 12)) %>%
    group_by(k) %>%
    filter(meanAICc == min(meanAICc)) %>%
    ungroup() %>%
    distinct()

portal_predictions <- list() 

for(i in 1:nrow(portal_model_summary)) {
    portal_predictions[[i]] <- ts_predict(as.list(portal_model_summary[i, ]), seed = 1977)$prediction %>%
        mutate(k = portal_model_summary$k[i])
}

all_pred <- bind_rows(portal_predictions)

all_pred[ which(all_pred$source == "observed"), "k"] <- NA
```

``` r
abs_abund_plot <- ggplot(data = filter(all_pred, source == "observed"), aes(x = timestep, y = abundance)) +
    geom_line() +
    geom_line(data = filter(all_pred, source == "pred", k %in% c(3, 12)), aes(x = timestep, y = abundance, color = as.factor(k))) +
    theme_bw() +
    facet_wrap(species ~ .)

abs_abund_plot
```

![](k_comparison_files/figure-markdown_github/plot%20absolute%20abund%20predictions-1.png)

``` r
rel_pred <- all_pred %>%
    group_by(timestep, source, k) %>%
    mutate(abundance = abundance / sum(abundance)) %>%
    ungroup()

rel_abund_plot <- ggplot(data = filter(rel_pred, source == "observed"), aes(x = timestep, y = abundance)) +
    geom_line() +
    geom_line(data = filter(rel_pred, source == "pred", k %in% c(3, 12)), aes(x = timestep, y = abundance, color = as.factor(k))) +
    theme_bw() +
    facet_wrap(species ~ .)

rel_abund_plot
```

![](k_comparison_files/figure-markdown_github/plot%20relative%20abundances-1.png)
