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


# Clean and transform the data into the appropriate format
datasets <- build_datasets_plan(include_retriever_data = T, include_bbs_data = T,bbs_subset = c(1:5))

datasets <- datasets[11, ]

portal_annual_dataset <- drake_plan(
    portal_ann_data = get_portal_annual_data()
)

portal_annual_dataset$trigger <- datasets$trigger[1]

datasets <- rbind(datasets, portal_annual_dataset)

# datasets <- portal_annual_dataset

lda_plan <- build_lda_plan(datasets, n_topics = as.numeric(2:3), nseeds = 2)

#lda_plan <- build_lda_plan(datasets, n_topics = as.numeric(c(2, seq(3, 6, by = 3))), nseeds = 2)

lda_names <- lda_plan$target[ which(!grepl(lda_plan$target, pattern = "_results"))]


ts_plan <- build_ts_plan(ldamodels_names = lda_names, nchangepoints = c(0:1), formulas = c("time", "intercept"), ts_control = list(nit = 100))
# 
# reports <- drake_plan(
#     full_like_report = target(rmarkdown::render(
#         knitr_in("analysis/reports/full_likelihood_drake.Rmd")), 
#         trigger = trigger(condition = exists(full_lik_results))
#     )
# )


pipeline <- dplyr::bind_rows(datasets, lda_plan, ts_plan)#, reports) #, summary_tables, reports)


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
