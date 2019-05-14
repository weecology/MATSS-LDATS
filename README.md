# MATSS-LDATS

<!-- badges: start -->

[![Build Status](https://travis-ci.org/weecology/MATSS-LDATS.svg?branch=master)](https://travis-ci.org/weecology/MATSS-LDATS)

[![Codecov test
coverage](https://codecov.io/gh/weecology/MATSS-LDATS/branch/master/graph/badge.svg)](https://codecov.io/gh/weecology/MATSS-LDATS?branch=master)

<!-- badges: end -->

## Contributors

## Overview

This repository builds on analytical methods and infrastructure in development elsewhere in our lab group to perform a meta-analysis on the dynamics of community structure in ecological timeseries. We use the data and pipeline management tools in `MATSS` to collect ecological time series data, and perform the LDA and timeseries analyses in `LDATS`. We are especially curious about the usual number of topics and changepoints detected in community timeseries, and whether these characteristics are related to features of the data (timeseries length, sampling frequency) or the system in question (study taxa, species richness, abundance). 

## To use

### Setup

#### install MATSS
Because `MATSS` is in active and rapid development, we suggest re-installing `MATSS` whenever you pick up this analysis.

The same goes for `drake`. 

#### System/environmental variables
For storing datasets downloaded with the retriever. This only needs to be done once per machine.

### `MATSS` and  `drake`

### Related repos & reading

https://github.com/weecology/MATSS

https://github.com/weecology/LDATS

https://github.com/emchristensen/Extreme-events-LDA

## To use on HiperGator

Follow the instructions in the `MATSS` repo: https://weecology.github.io/MATSS/articles/hipergator-install.html

In R on HiperGator, install `MATSS-LDATS`:

```r
devtools::install_github('weecology/MATSS-LDATS')
```


Then in shell, navigate to our group's shared folder:
``` bash
cd orange/ewhite/MATSS-LDATS
```

Run `pipeline.R`:

```bash
Rscript analysis/pipeline.R
```

