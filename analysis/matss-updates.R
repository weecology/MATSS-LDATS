library(drake)
library(MATSS)
library(matssldats)

## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("drake", "drake-cache.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)

cached(cache=cache)

ts_result_summary = readd(ts_result_summary, cache = cache)
lda_result_summary = readd(lda_result_summary, cache = cache)


lda_ts_results <- collect_lda_ts_results(lda_result_summary, ts_result_summary)

lda_results <- readd(lda_results, cache = cache)
ts_select_results <- readd(ts_select_results, cache = cache)


lda_summary <- collect_lda_result_summary(lda_results)
ts_summary <- collect_ts_result_summary(ts_select_results)

lda_ts_results <- collect_lda_ts_results(lda_summary, ts_summary)
