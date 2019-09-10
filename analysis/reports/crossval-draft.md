Leave-one-out all years
================
Renata Diaz
9/10/2019

Crossval method
---------------

-   Create 1 dataset for every time step. Each dataset has 1 timestep removed plus the adjacent 2 timesteps in either direction.
    -   RMD went with a 2 timestep buffer based on autocorrelation plots of *total abundance*.
-   Fit LDA models with 20 seeds, 3, 6, 9, and 12 topics.
-   For every LDA model, run 4 TS models with the usual array of 0 or 1 changepoints and ~ year or ~ 1, for 1000 iterations.
    -   The above steps took about 36 hours on the hipergator. It broke `collect_results` in a mysterious way, but that seems fine(?).
-   For every TS model, for every draw from the posterior, calculate the loglikelihood of the observed abundances at the *central withheld timestep* coming from that TS model. Report the mean of these loglikelihoods across all the draws from the posterior.
-   For every combination of *LDA number of topics and seed* and *TS model*, calculate the average loglikelihood across all datasets (the datasets differ in which timesteps are withheld). This gives a performance score for every model configuration like `3 topics, seed 20, 0 changepoints, ~ time`.

#### Average performance across model seeds:

![](crossval-draft_files/figure-markdown_github/eval%20performance%20over%20all%20subgroups-1.png)

#### Zooming in to the highest 10 scores:

![](crossval-draft_files/figure-markdown_github/best%20performers-1.png)

Best-performing model
---------------------

    ## Joining, by = c("lda_model_name", "ts_model_desc")

![](crossval-draft_files/figure-markdown_github/best%20model-1.png)![](crossval-draft_files/figure-markdown_github/best%20model-2.png)![](crossval-draft_files/figure-markdown_github/best%20model-3.png)![](crossval-draft_files/figure-markdown_github/best%20model-4.png)![](crossval-draft_files/figure-markdown_github/best%20model-5.png)![](crossval-draft_files/figure-markdown_github/best%20model-6.png)![](crossval-draft_files/figure-markdown_github/best%20model-7.png)![](crossval-draft_files/figure-markdown_github/best%20model-8.png)

Predictions from best models
----------------------------

Method to generate predictions:

-   For each number of topics, identify the best-performing LDA seed + TS model configuration with that number of topics over all timesteps of witheld data. There will be one of these models for every timestep, each one fit to all of the data *except* that timestep + a buffer.
-   For each timestep, use the LDA + TS model with that timestep withheld for predictions.
    -   Generate a term-document probability matrix *for all years* using Beta and Eta matrices from a random draw from that model's posterior
    -   Sample abundances for *only the central missing year* to get abundances for that timestep.
-   Stitch all these predictions together to make predictions across the full timeseries.

### Species absolute abundances

![](crossval-draft_files/figure-markdown_github/abs%20abund%20plots-1.png)

### Species relative abundances

![](crossval-draft_files/figure-markdown_github/rel%20abund%20plots-1.png)

### Relative abundance observed-predicted plots

![](crossval-draft_files/figure-markdown_github/obs-pred%201:1%20plots-1.png)
