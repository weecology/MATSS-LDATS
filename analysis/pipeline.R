library(MATSS)
library(dplyr)
library(drake)
library(matssldats)

## Make sure we have downloaded the raw datasets from retriever first
if (FALSE)
{
  install_retriever_data("breed-bird-survey", data_path = folder_path)
  install_retriever_data("veg-plots-sdl", data_path = folder_path)
  install_retriever_data("mapped-plant-quads-mt", data_path = folder_path)
}


## Clean and transform the data into the appropriate format
datasets <- build_datasets_plan(include_downloaded_data = T)


## Analysis methods
lda_methods <- drake_plan(
  lda = function(dataset) {matssldats::run_LDA(dataset, max_topics = 3, nseeds = 4)}
)

ts_methods <- drake_plan(
  ts = function(lda, dataset){matssldats::run_TS(dataset, lda, nchangepoints = c(2:3))}
)

lda_analyses <- build_analyses_plan(lda_methods, datasets)

ts_analyses <- build_ts_analysis_plan(ts_methods, datasets, lda_analyses)

## Summary reports
# I don't quite understand the pathing here... - Hao
reports <- drake_plan(
  lda_report = rmarkdown::render(
    knitr_in("analysis/reports/lda_report.Rmd")
  )
)

## The entire pipeline
pipeline <- bind_rows(datasets, lda_methods, lda_analyses,
                      ts_methods, ts_analyses, reports)

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
make(pipeline, cache = cache)

## Run the pipeline (parallelized)
# future::plan(future::multiprocess)
# make(pipeline,
#      force = TRUE,
#      cache = cache,
#      verbose = 2,
#      parallelism = "future",
#      jobs = 2,
#      caching = "master") # Important for DBI caches!
