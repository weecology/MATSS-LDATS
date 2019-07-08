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

make(pipeline,  cache = cache, cache_log_file = here::here("drake", "cache_log.txt"))

#datasets <- datasets[12, ]

## Analysis methods
analyses <- build_ldats_analyses_plan(datasets, max_topics = 2, nchangepoints = c(0:2), formulas = c("time", "intercept"), nseeds = 1)

#analyses <- analyses[ which(!grepl("ts_", analyses$target)), ]

summary_tables <- drake_plan(
    lda_result_summary = collect_lda_result_summary(lda_results = lda_results),
    ts_result_summary = collect_ts_result_summary(selected_ts_results = ts_select_results),
    lda_ts_result_summary = collect_lda_ts_results(lda_result_summary, ts_result_summary)
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

## The entire pipeline
pipeline <- dplyr::bind_rows(datasets, analyses)#, summary_tables, reports)

## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("drake", "drake-cache.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)

make(datasets, cache = cache, cache_log_file = here::here("drake", "cache_log.txt"))

make(pipeline,  cache = cache, cache_log_file = here::here("drake", "cache_log.txt"))

cached(cache = cache)

