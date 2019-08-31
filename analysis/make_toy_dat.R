library(MATSS)
library(dplyr)
portal_annual <- get_portal_rodents(treatment = "exclosure")


newabundance <- portal_annual$abundance %>%
    mutate(censusdate = portal_annual$covariates$censusdate) %>%
    mutate(year = format(censusdate, "%Y")) %>%
    select(-censusdate) %>%
    tidyr::gather(-year, key = "species", value = "abundance") %>%
    group_by(year, species) %>%
    summarize(abundance = sum(abundance)) %>%
    ungroup() %>%
    tidyr::spread(key = "species", value = "abundance")

portal_annual$abundance <- select(newabundance, -year)
portal_annual$covariates <- select(newabundance, year)
portal_annual$metadata$timename <- "year"

save(portal_annual, file = here::here("analysis", "exclosures_data.Rds"))

