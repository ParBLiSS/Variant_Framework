#!/bin/bash
echo "script started"
#ALG="greedy_snp_indels ilp_snp_indels greedy_snp lp_snp"
ALG="greedy_snp_indels"
for Alg in $ALG  # VF algorithm: alg=greedy_snp_indels ilp_snp_indels, greedy_snp, lp_snp
do
    qsub -v "alg=$Alg" run_phoenix_vf_algs.pbs &    
done
wait
echo "All Scripts for VF evaluated"


