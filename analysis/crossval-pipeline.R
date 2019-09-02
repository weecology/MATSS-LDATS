## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(MATSS)
library(matssldats)
library(drake)


## make sure the package functions in MATSS and matssldats are loaded in as
##   dependencies
expose_imports(MATSS)
expose_imports(matssldats)

## ----get data------------------------------------------------------------


## ----drake plan for get data---------------------------------------------
datasets <- drake_plan(
    portal_ann_data = get_portal_annual_data()
)

## ----data subset plan----------------------------------------------------

subset_plan <- drake_plan(
     datsub = target(subset_data(data, n_segs = 28, sequential = T, buffer = 2, which_seg = this_seg),
                 transform = cross(data = !!rlang::syms(datasets$target), this_seg = !!(1:28)))
)


## ----set up LDAs---------------------------------------------------------
all_topics <- c(3, 6, 9, 12)
max_n_seeds <- 20
seeds <- seq(2, length.out = max_n_seeds, by = 2)
lda_control <- list()

lda_plan <-  drake::drake_plan(
    lda = target(run_LDA(data, n_topics = ntopics, seed = seed, control = !!lda_control),
                 transform = cross(data = !!rlang::syms(subset_plan$target), ntopics = !!all_topics, seed = !!seeds)),
    lda_results = target(collect_analyses(list(lda)),
                         transform = combine(lda))
)


## ----set up ts-----------------------------------------------------------

lda_names <- lda_plan$target[ which(!grepl(lda_plan$target, pattern = "_results"))]

ts_plan <- build_ts_plan(ldamodels_names = lda_names, nchangepoints = c(0:1), formulas = c("time", "intercept"), ts_control = list(nit = 1000))


pipeline <- dplyr::bind_rows(datasets, subset_plan, lda_plan, ts_plan)


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
         jobs = 32,
         caching = "master") # Important for DBI caches!
} else {
    # Run the pipeline on a single local core
    make(pipeline, cache = cache, cache_log_file = here::here("drake", "cache_log.txt"))
}

