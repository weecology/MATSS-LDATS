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

``` r
get_liks <- function(counts_matrix, ts_model, lda_model, sim = NULL, seed = 1977) {
    betas <- exp(lda_model@beta)
    if(is.null(sim)) {
        set.seed(seed)
        sim <- sample(1:nrow(ts_model$etas), size = 1)
    }
    
    thetas <- get_theta(ts_model = ts_model, sim = sim)
    
    docterm_ps <- thetas %*% betas
    
    ll_matrix <- apply(as.matrix(1:nrow(counts_matrix)), MARGIN = 1,
                       FUN = get_doc_lik, counts_matrix = counts_matrix, p_matrix = docterm_ps)
    
    return(ll_matrix)
    
}

get_liks_from_list <- function(modelrow) {
    this_counts <- readd(modelrow$data_object_name, character_only = T, cache = cache)$abundance
    this_lda <- readd(modelrow$lda_object_name, character_only = T, cache = cache)$lda[[modelrow$lda_model_index]]
    this_ts <- readd(modelrow$ts_object_name, character_only = T, cache = cache)$ts[[modelrow$ts_model_index]]
    
    this_lik <- get_liks(counts_matrix = this_counts,ts_model = this_ts,lda_model = this_lda, sim = NULL, seed = 1977)
}

portal_lls <- list()

for(i in 1:nrow(portal_model_summary)) {
    portal_lls[[i]] <- data.frame(ll = get_liks_from_list(modelrow = as.list(portal_model_summary[i,])))
    
    portal_lls[[i]]$timestep <- 1:nrow(portal_lls[[i]])
    portal_lls[[i]]$k <- portal_model_summary$k[i]
    
}

all_lls <- bind_rows(portal_lls)

ll_plot <- ggplot(data = all_lls, aes(x = timestep, y = ll, color = as.factor(k))) +
    geom_line() +
    theme_bw()

ll_plot
```

![](k_comparison_files/figure-markdown_github/plot%20loglikelihood%20of%20observed%20values-1.png)
