#!/bin/bash
#SBATCH --job-name=ml-loo-eval   # Job name
#SBATCH --mail-type=ALL               # Mail events (NONE, BEGIN, END, FAIL, AL$
#SBATCH --mail-user=diaz.renata@ufl.edu   # Where to send mail
#SBATCH --account=ewhite
#SBATCH --qos=ewhite-b
#SBATCH --ntasks=1                 # Number of MPI ranks
#SBATCH --cpus-per-task=1            # Number of cores per MPI rank
#SBATCH --mem-per-cpu=16GB
#SBATCH --time=24:00:00       #Time limit hrs:min:sec
#SBATCH --output looeval%j.out
#SBATCH --error looeval%j.err

#This is a generic R submission script
module load R
Rscript analysis/loo_evaluation.R