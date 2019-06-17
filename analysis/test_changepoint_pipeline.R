library(MATSS)
library(dplyr)
library(drake)
library(matssldats)

## make sure the package functions in MATSS and matssldats are loaded in as
##   dependencies
expose_imports(MATSS)
expose_imports(matssldats)

source(here::here("analysis", "add_toy_covariates.R"))

## Clean and transform the data into the appropriate format

datasets <- build_datasets_plan(include_retriever_data = T, include_bbs_data = T,
                                bbs_subset = c(1:5))

datasets <- datasets[1:20, ]
datasets_cov <- drake_plan(
    cov = target(add_toy_covariates(data),
                 transform = map(data = !!rlang::syms(datasets$target))
    )
)

## Analysis methods

lda_plan <- drake_plan(
    lda = target(run_LDA(data, max_topics = 6, nseeds = 100),
                 transform = map(data = !!rlang::syms(datasets_cov$target))
    )
)


## Cpt
cpt_plan <-  drake_plan (
    ts_timename = target(run_TS(data, lda, nchangepoints = c(0:6)), 
                         transform = map(data = !!rlang::syms(datasets$target), 
                                         lda)),
    ts_timestep = target(run_TS(data, lda, nchangepoints = c(0:6),
                                formulas = ~timestep),
                         transform = map(data = !!rlang::syms(datasets$target), 
                                         lda)),
    ts_normalnoise = target(run_TS(data, lda, nchangepoints = c(0:6),
                                   formulas = ~normalnoise),
                            transform = map(data = !!rlang::syms(datasets$target), 
                                            lda)),
    
    ts_select_timename = target(try(LDATS::select_TS(ts_timename)), 
                       transform = map(ts_timename)),
    ts_select_timestep =  target(try(LDATS::select_TS(ts_timestep)), 
                                 transform = map(ts_timestep)),
    
    ts_select_normalnoise =  target(try(LDATS::select_TS(ts_normalnoise)), 
                                 transform = map(ts_normalnoise)),
    ts_select_timename_results = target(collect_analyses(list(ts_select_timename)),
                               transform = combine(ts_select_timename)),
    ts_select_timestep_results = target(collect_analyses(list(ts_select_timestep)),
                                        transform = combine(ts_select_timestep)),
    ts_select_normalnoise_results = target(collect_analyses(list(ts_select_normalnoise)),
                                        transform = combine(ts_select_normalnoise))
)


## The entire pipeline
pipeline <- bind_rows(datasets, datasets_cov, lda_plan, cpt_plan)

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
