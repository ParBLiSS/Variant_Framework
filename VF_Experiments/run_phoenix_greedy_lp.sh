#!/bin/bash
echo "script started"
for CHRID in chr22  # Chr ID
do
    for A in  150 1000 5000 # alpha
    do
        for p in  0 1 5 10 # percentage
        do
            D=$((((A*p) / 100) + ((A*p)%100 > 0)))    # delta, Rounded to up
            echo " a=$A, d=$D"    
            qsub -v "chr=${CHRID}, a=$A, d=$D," run_phoenix_a_d_greedy_lp.pbs &    
        done
    done
done
wait
echo "All Scripts for VF evaluated"


