Crossvalidating w tests
================
Renata Diaz
8/31/2019

``` r
ts_done <- cached(cache = cache) [ which(grepl("ts_", cached(cache = cache)))]

ts_results <- list()

for(i in 1:length(ts_done)) {
    ts_results[[i]] <- readd(ts_done[i], character_only = T, cache = cache)
}

names(ts_results) <- ts_done

model_info <- all_model_info(ts_results)

rm(ts_results)
rm(ts_done)
```

``` r
avg_performance <- model_info %>%
    distinct() %>%
    group_by(k, seed, lda_model_name, lda_model_index, formula, changepoints, ts_model_name, ts_model_index, ts_model_desc, ts_model_desc_k) %>%
    summarize(nmodels = n(),
              mean_testll = mean(testll)) %>%
    ungroup() %>%
    mutate(k = as.factor(k))

avg_performance_plot <- ggplot(data = avg_performance, aes(x = ts_model_desc, y = mean_testll, color = k)) +
    geom_boxplot() +
    theme_bw()

avg_performance_plot
```

![](crossval-draft_files/figure-markdown_github/eval%20performance%20over%20all%20subgroups-1.png)

``` r
best_performers <- avg_performance %>%
    arrange(desc(mean_testll)) %>%
    mutate(rank = row_number()) %>%
    filter(rank <= 10)

best_performers_plot <-  ggplot(data = best_performers, aes(x = ts_model_desc, y = mean_testll, color = k)) +
    geom_boxplot() +
    theme_bw()
best_performers_plot
```

![](crossval-draft_files/figure-markdown_github/eval%20performance%20over%20all%20subgroups-2.png)

``` r
best_performers <- best_performers <- avg_performance %>%
    group_by(k) %>%
    arrange(desc(mean_testll)) %>%
    mutate(rank = row_number()) %>%
    filter(rank == 1) %>%
    ungroup()

predictions <- list() 
for(j in c(3, 6, 12)) {
    best_performer <- filter(best_performers, k == j)
    
best_model_names <- model_info %>%
    distinct() %>%
    filter(ts_model_name == best_performer$ts_model_name[1])

best_ldas <- list() 
best_ts_models <- list()
for(i in 1:nrow(best_model_names)) {
    best_ldas[[i]] <- readd(best_model_names$lda_object_name[i], character_only = T, cache = cache)
    best_ts_models[[i]] <- readd(best_model_names$ts_object_name[i], character_only = T, cache = cache)[[1]][[best_model_names$ts_model_index[i]]]
}

predicted_corpuses <- list()

for(i in 1:nrow(best_model_names)) {
    predicted_corpuses[[i]] <- ts_predict_corpus(best_ts_models[[i]], best_ldas[[i]]$lda[[1]], 
                                                 data = best_ldas[[i]]$data,
                                                 predict_data = list(abundance = best_ldas[[i]]$data$test_abundance,
                                                                     covariates = best_ldas[[i]]$data$test_covariates))
    
    names(predicted_corpuses)[i] <- best_ldas[[i]]$data$test_covariates$year
}

predictions[[j]] <- bind_rows(predicted_corpuses, .id = "year") %>%
    select(-timestep) %>%
    mutate(year = as.integer(year)) %>%
    arrange(year)

}

predictions <- predictions[c(3,6,12)]

names(predictions) <- c(3,6,12)

predictions <- bind_rows(predictions, .id = "k")

predictions$k <-as.factor(predictions$k)
```

### Species absolute abundances

``` r
abs_plot <- ggplot(data = filter(predictions, source == "pred"), aes(x = year, y = abundance, color = k)) +
    geom_line() +
    geom_line(data = filter(predictions, source == "observed"), aes(x = year, y = abundance), color = "black", alpha = .7) +
    facet_wrap(species ~ .) +
    theme_bw()

abs_plot
```

![](crossval-draft_files/figure-markdown_github/abs%20abund%20plots-1.png)

``` r
rel_predictions <- predictions %>%
    group_by(year, source, k) %>%
    mutate(total_annual_abund = sum(abundance)) %>%
    ungroup() %>%
    mutate(rel_abundance = abundance / total_annual_abund)

rel_plot <- ggplot(data = filter(rel_predictions, source == "pred"), aes(x = year, y = rel_abundance, color = k)) +
    geom_line() +
    geom_line(data =filter(rel_predictions, source == "observed"), color = "black", alpha = .7) +
    facet_wrap(species ~ .) +
    ylim(0, 1) +
    theme_bw()

rel_plot
```

![](crossval-draft_files/figure-markdown_github/rel%20abund%20plots-1.png)

``` r
obspred_dat <- rel_predictions %>%
    select(year, k, source, species, rel_abundance) %>%
    tidyr::spread(key = "source", value = "rel_abundance") %>%
    mutate(k = as.factor(k))

obspred_plot <- ggplot(data = obspred_dat, aes(x = observed, y = pred)) +
    geom_point() +
    facet_grid(rows = vars(species), cols = vars(k)) +
    theme_bw() +
    ylim(0, 1) +
    xlim(0, 1) + 
    geom_line(data = data.frame(x = seq(0, 1, by = 0.1), y = seq(0, 1, by = 0.1)), 
              aes(x = x, y = y))

obspred_plot
```

![](crossval-draft_files/figure-markdown_github/obs-pred%201:1%20plots-1.png)
