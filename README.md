# Variant_Framework

 This repositorty takes a holistic approach to develop a novel mathematical framework for variant selection in genome graphs subject to preserving sequences of length $\alpha$ with at most $\delta$ differences. This framework leads to a rich set of problems based on the types of variants (e.g., SNPs, indels, or structural variants) and whether the goal is to minimize the number of positions at which variants are incorporated or to minimize the total number of variants incorporated.
 The figure below illustrates the outline of our proposed framework, showcasing the contributions of our variant selection method. The framework allows for the preservation of sequences of length $\alpha$ while allowing up to $\alpha$ differences. It considers two options, preserving sequences seen in the complete variation graph or haplotypes only, and offers a variety of distance metrics, including hamming and edit distance. The objectives can be to minimize the number of variant coordinates or the number of variants. The problem 3 and 4, and all the haplotype-aware problems are proven to be $\mathcal{NP}$-hard.

## Dependencies
- gcc (with C++20 support)
- Boost Graph Library
- [samtools](https://vcftools.github.io/)
- [bcftools](https://samtools.github.io/bcftools/)
- [Gurobi](https://www.gurobi.com)
- [igraph](https://github.com/igraph/igraph)
- [OpenMP](https://curc.readthedocs.io/en/latest/programming/OpenMP-C.html)

![List_of_Problems](figs/problems_category.png)

```
The project has the following folder structure:
```
```bash
.
├── VF
│   ├── examples
│   │   └── README.md
│   ├── src
│   │   ├── ext
│   │   ├── common.hpp
│   │   ├── greedy_snp.cpp
│   │   ├── greedy_snp_indels.cpp
│   │   ├── greedy_sv.cpp
│   │   ├── ilp_snp_indels.cpp
│   │   ├── ilp_sv.cpp
│   │   └── lp_snp.cpp
│   ├── LICENSE
│   ├── Makefile
│   ├── README.md
│   └── dependencies.sh
├── VF_Experiments
│   ├── download_dataset.sh
│   ├── download_sw.sh
│   ├── interavtice_VF_with_a_and_d.sh
│   ├── run_phoenix_a_d.pbs
│   ├── run_phoenix_a_d_greedy_lp.pbs
│   ├── run_phoenix_chr22_greedy_snp_1000_0.pbs
│   ├── run_phoenix_chr22_greedy_snp_1000_10.pbs
│   ├── run_phoenix_chr22_greedy_snp_1000_100.pbs
│   ├── run_phoenix_chr22_greedy_snp_1000_50.pbs
│   ├── run_phoenix_chr22_greedy_snp_150_0.pbs
│   ├── run_phoenix_chr22_greedy_snp_150_15.pbs
│   ├── run_phoenix_chr22_greedy_snp_150_2.pbs
│   ├── run_phoenix_chr22_greedy_snp_150_8.pbs
│   ├── run_phoenix_chr22_greedy_snp_5000_0.pbs
│   ├── run_phoenix_chr22_greedy_snp_5000_250.pbs
│   ├── run_phoenix_chr22_greedy_snp_5000_50.pbs
│   ├── run_phoenix_chr22_greedy_snp_5000_500.pbs
│   ├── run_phoenix_greedy_lp.sh
│   ├── run_phoenix_vf_algs.sh
│   └── run_tools.sh
├── figs
│   ├── problems_category.pdf
│   └── problems_category.png
├── havg
│   ├── README.md
│   ├── chr_id_haplotypes.sh
│   └── vcf_download_data.sh
├── hg
│   ├── Results
│   │   └── Haplotype_Resolved_ILP.xlsx
│   ├── havg
│   ├── pbs_scripts
│   │   └── pbs
│   ├── plots
│   │   ├── hg_Plot_chr1.ipynb
│   │   └── hg_Plot_chr22.ipynb
│   ├── src
│   │   ├── ext
│   │   ├── common.hpp
│   │   ├── greedy_snp.cpp
│   │   ├── havg.sh
│   │   ├── ilp_ha_snp.py
│   │   └── lp_snp.cpp
│   ├── README.md
│   ├── chr_id_haplotypes.sh
│   ├── count_number_of_biallelic_snps.txt
│   └── vcf_download_data.sh
├── hged
│   ├── figs
│   │   ├── bipartite.png
│   │   └── workflow.png
│   ├── read_mapping_accuracy_evaluation
│   │   ├── read_mapping.sh
│   │   └── reads_with_inecting_errors.sh
│   ├── src
│   │   ├── ext
│   │   ├── common.hpp
│   │   ├── data_wrangler.cpp
│   │   └── main.cpp
│   ├── Makefile
│   ├── README.md
│   └── dependencies.sh
├── .DS_Store
└── README.md

```

## Framework Overview

## Variant Filtering (VF)
VF is a prototype software implementation of our algorithms for variant filtering in variation graphs for the problems 1 to 4.

## VF_Experiments
VF_Experiments is a framework to establish a benchmark for datasets and tools needed to evaluate the VF experiments and the impact of read-to-graph mappers.

## Havg (Haplotype-annotated Variation Graph)
Havg is used to create a variation graph that corresponds to each chromosome, annotated with a list of haplotypes per edge when the graph only contains SNP variants. This annotated graph is then used in solving problems 5 and 6.

## hg (Haplotype-aware Graphs)
This repository constructs an ILP solution for haplotype-aware variant selection for genome graphs under Hamming distance for solving problems 5 and 6.

## hged (Haplotype-aware Edit Distance)
This repository constructs an ILP solution for haplotype-aware variant selection for genome graphs under Hamming distance for solving problems 7 and 8.
