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

datasets <- drake_plan(
    portal_rodents = get_portal_rodents(),
    portal_rodents_cov = add_toy_covariates(portal_rodents))

## LDA
lda_plan <- drake_plan(
    portal_rodents_lda = run_LDA(data = portal_rodents_cov)
)





## Cpt
cpt_plan <- drake_plan(
    default_ts = LDATS::TS_on_LDA(LDA_models = portal_rodents_lda,
                                  document_covariate_table = 
                                      as.data.frame(portal_rodents_cov$covariates),
                                  formulas = ~1,
                                  nchangepoints = c(0:6),
                                  weights = LDATS::document_weights(portal_rodents_cov$abundance),
                                  control = LDATS::TS_controls_list(nit = 1000, timename = portal_rodents_cov$metadata$timename)), 
    
    newmoon_ts = LDATS::TS_on_LDA(LDA_models = portal_rodents_lda,
                                  document_covariate_table = 
                                      as.data.frame(portal_rodents_cov$covariates),
                                  formulas = ~newmoonnumber,
                                  nchangepoints = c(0:6),
                                  weights = LDATS::document_weights(portal_rodents_cov$abundance),
                                  control = LDATS::TS_controls_list(nit = 1000, timename = portal_rodents_cov$metadata$timename)), 
    
    month_ts = LDATS::TS_on_LDA(LDA_models = portal_rodents_lda,
                                  document_covariate_table = 
                                      as.data.frame(portal_rodents_cov$covariates),
                                  formulas = ~month,
                                  nchangepoints = c(0:6),
                                  weights = LDATS::document_weights(portal_rodents_cov$abundance),
                                  control = LDATS::TS_controls_list(nit = 1000, timename = portal_rodents_cov$metadata$timename)),
    
    timestep_ts = LDATS::TS_on_LDA(LDA_models = portal_rodents_lda,
                                  document_covariate_table = 
                                      as.data.frame(portal_rodents_cov$covariates),
                                  formulas = ~timestep,
                                  nchangepoints = c(0:6),
                                  weights = LDATS::document_weights(portal_rodents_cov$abundance),
                                  control = LDATS::TS_controls_list(nit = 1000, timename = portal_rodents_cov$metadata$timename)),
    
    default_ts_select = try(LDATS::select_TS(default_ts)),
    newmoon_ts_select = try(LDATS::select_TS(newmoon_ts)),
    month_ts_select = try(LDATS::select_TS(month_ts)),
    timestep_ts_select = try(LDATS::select_TS(timestep_ts))
)


summary_tables <- drake_plan(
    ts_result_summary = collect_ts_result_summary(selected_ts_results = list(default = default_ts_select, newmoon = newmoon_ts_select,month = month_ts_select, timestep = timestep_ts_select))
)

## The entire pipeline
pipeline <- bind_rows(datasets, lda_plan, cpt_plan, summary_tables)

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
