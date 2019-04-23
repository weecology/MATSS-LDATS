library(MATSS)
library(dplyr)
library(drake)
library(matssldats)
library(future.batchtools)

## make sure the package functions in MATSS and matssldats are loaded in as
##   dependencies
expose_imports(MATSS)
expose_imports(matssldats)

## Make sure we have downloaded the raw datasets from retriever first
if (FALSE)
{
  install_retriever_data("breed-bird-survey")
  install_retriever_data("veg-plots-sdl")
  install_retriever_data("mapped-plant-quads-mt")
}


## Clean and transform the data into the appropriate format
datasets <- build_datasets_plan(include_downloaded_data = T)


## Analysis methods
analyses <- build_ldats_analyses_plan(datasets)

## Summary reports
# I don't quite understand the pathing here... - Hao
reports <- drake_plan(
  lda_report = rmarkdown::render(
    knitr_in("analysis/reports/lda_report.Rmd")
  ),
  ts_report = rmarkdown::render(
    knitr_in("analysis/reports/ts_report.Rmd")
  )
)

## The entire pipeline
pipeline <- bind_rows(datasets, analyses, reports)

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
hostname <- Sys.getenv("HOSTNAME")

if (grepl("ufhpc", hostname)){
  ## Run the pipeline parallelized for HiPerGator
  future::plan(batchtools_slurm, template = "slurm_batchtools.tmpl")
  drake_hpc_template_file("slurm_batchtools.tmpl")
  make(pipeline,
      force = TRUE,
      cache = cache,
      cache_log_file = here::here("drake", "cache_log.txt"),
      verbose = 2,
      parallelism = "future",
      jobs = 16,
      caching = "master") # Important for DBI caches!
} else {
  ## Run the pipeline on a single local core
  make(pipeline, cache = cache, cache_log_file = here::here("drake", "cache_log.txt"))
}
