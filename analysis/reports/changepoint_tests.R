library(MATSS)
library(matssldats)

portal_data <- get_portal_rodents()
portal_lda <- run_LDA(portal_data, max_topics = 6, nseeds = 100)

data <- portal_data
data$covariates$month <- as.numeric(format(data$covariates$censusdate, "%m"))
## Get time for formulas
form <- as.formula(paste0("~ ", data$metadata$timename))
weights <- LDATS::document_weights(data$abundance)
ldamodels = portal_lda


ts_1 <- LDATS::TS_on_LDA(LDA_models = ldamodels,
                         document_covariate_table = as.data.frame(data$covariates),
                         formulas = ~1,
                         nchangepoints = c(0:5),
                         weights = weights,
                         control = LDATS::TS_controls_list(nit = 1000, timename = data$metadata$timename))
ts_1_selected <- try(LDATS::select_TS(ts_1))


ts_newmoonnumber <- LDATS::TS_on_LDA(LDA_models = ldamodels,
                                     document_covariate_table = as.data.frame(data$covariates),
                                     formulas = form,
                                     nchangepoints = c(0:5),
                                     weights = weights,
                                     control = LDATS::TS_controls_list(nit = 1000, timename = data$metadata$timename)) 

ts_newmoonnumber_selected <- try(LDATS::select_TS(ts_newmoonnumber))


ts_month <- LDATS::TS_on_LDA(LDA_models = ldamodels,
                                     document_covariate_table = as.data.frame(data$covariates),
                                     formulas = ~month,
                                     nchangepoints = c(0:5),
                                     weights = weights,
                                     control = LDATS::TS_controls_list(nit = 1000, timename = data$metadata$timename)) 
ts_month_selected <- try(LDATS::select_TS(ts_month))

ts_matssldats <- run_TS(portal_data, portal_lda, nchangepoints = 0:5)
ts_matssldats_selected <- try(LDATS::select_TS(portal_ts))

save.image(file = "changepoint_tests.RData")