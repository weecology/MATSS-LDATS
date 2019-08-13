library(drake)
library(MATSS)
library(matssldats)

## make sure the package functions in MATSS and matssldats are loaded in as
##   dependencies
expose_imports(MATSS)
expose_imports(matssldats)

## Make sure we have downloaded the raw datasets from retriever first
if (FALSE)
{
    install_retriever_data("breed-bird-survey")
    prepare_bbs_ts_data()
    install_retriever_data("veg-plots-sdl")
    install_retriever_data("mapped-plant-quads-mt")
}


## Clean and transform the data into the appropriate format
datasets <- build_datasets_plan(include_retriever_data = T, include_bbs_data = T,bbs_subset = c(1:5))

datasets <- datasets[10, ]

analyses <- build_ldats_analyses_plan(datasets, max_topics = 3, nchangepoints = c(1), formulas = c("time", "intercept"), nseeds = 2)

summary_tables <- drake_plan(
    lda_result_summary = collect_lda_result_summary(lda_results = lda_results),
    ts_result_summary = collect_ts_result_summary(selected_ts_results = ts_select_results),
    lda_ts_result_summary = collect_lda_ts_results(lda_result_summary, ts_result_summary),
    ts_models_summary = collect_ts_result_models_summary(ts_results = ts_results)
)

## Summary reports
# I don't quite understand the pathing here... - Hao
reports <- drake_plan(
    lda_report = rmarkdown::render(
        knitr_in("analysis/reports/lda_report.Rmd")
    ) ,
    ts_report = rmarkdown::render(
        knitr_in("analysis/reports/ts_report.Rmd")
    )
)

pipeline <- dplyr::bind_rows(datasets, analyses, summary_tables, reports)



## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("drake", "drake-cache.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)


## View the graph of the plan
if (interactive())
{
    config <- drake_config(pipeline, cache = cache)
    sankey_drake_graph(config, build_times = "none")  # requires "networkD3" package
    vis_drake_graph(config, build_times = "none")     # requires "visNetwork" package
}


## Run the pipeline
nodename <- Sys.info()["nodename"]
if(grepl("ufhpc", nodename)) {
    library(future.batchtools)
    print("I know I am on SLURM!")
    ## Run the pipeline parallelized for HiPerGator
    future::plan(batchtools_slurm, template = "slurm_batchtools.tmpl")
    make(pipeline,
         force = TRUE,
         cache = cache,
         cache_log_file = here::here("drake", "cache_log.txt"),
         verbose = 2,
         parallelism = "future",
         jobs = 16,
         caching = "master") # Important for DBI caches!
} else {
    # Run the pipeline on a single local core
    make(pipeline, cache = cache, cache_log_file = here::here("drake", "cache_log.txt"))
}
