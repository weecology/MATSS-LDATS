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


lda_models_lists <-  drake::drake_plan(
    lda = target(run_LDA(data, max_topics = 3, nseeds = 2),
                 transform = map(data = !!rlang::syms(datasets$target))
    )
)

lda_models_selected <- drake::drake_plan(
    lda_select = target(LDATS::select_LDA(lda, control = list(measurer = LDATS::AICc)),
                        transform = map(lda = !!rlang::syms(lda_models_lists$target)))
)


ts_models_lists <- drake::drake_plan(
    ts = target(run_TS(data, lda_select, nchangepoints = c(0,1),formulas = c("intercept", "time"), control = list()), 
                transform = map(data = !!rlang::syms(datasets$target), 
                                lda_select = !!rlang::syms(lda_models_selected$target))))


pipeline <- dplyr::bind_rows(datasets, lda_models_lists, lda_models_selected, ts_models_lists)




## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("drake", "drake-cache.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)


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
