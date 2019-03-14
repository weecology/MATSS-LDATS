library(MATSS)
library(dplyr)
library(drake)



## Run the pipeline (parallelized)
# future::plan(future::multiprocess)
# make(pipeline,
#      force = TRUE,
#      cache = cache,
#      verbose = 2,
#      parallelism = "future",
#      jobs = 2,
#      caching = "master") # Important for DBI caches!
