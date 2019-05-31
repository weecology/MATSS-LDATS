#!/bin/bash

# Job name and who to send updates to
#SBATCH --job-name=<MATSSLDATS>
#SBATCH --mail-user=<diaz.renata@ufl.edu>
#SBATCH --mail-type=ALL

# Where to put the outputs: %j expands into the job number (a unique identifier for this job)
#SBATCH --output pipeline%j.out
#SBATCH --error pipeline%j.err

#SBATCH --ntasks=1
#SBATCH --mem=4gb   # Per processor memory
#SBATCH --cpus-per-task=16
#SBATCH --time=1:00:00   # Walltime

#Record the time and compute node the job ran on
date;hostname; pwd

#Use modules to load the environment for R
module load R

Rscript analysis/pipeline.R
