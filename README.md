# Variant_Framework

This repository is used to Preserving Read Mappability with the Minimum Number of Variants in genome variation graphs.
In other words, for a given complete variation graph of each chromosome, it creates a reduced variation graph in which 
some variants are removed subject to some constraints while preserving read mappability. The constraints are for every substring of length 
alpha observed in haplotypes, the reduced varaition graph guarantees to preserve those substrings with
at most delta errors (i.e., edit distance of delta among alpha-long substrings of haplotypes in complete variation graph with those of reduced variation graph).

 This repositorty takes a holistic approach to develop a novel mathematical framework for variant selection in genome graphs subject to preserving sequences of length $\alpha$ with at most $\delta$ differences. This framework leads to a rich set of problems based on the types of variants (e.g., SNPs, indels, or structural variants) and whether the goal is to minimize the number of positions at which variants are incorporated or to minimize the total number of variants incorporated.
 The figure below illustrates the outline of our proposed framework, showcasing the contributions of our variant selection method. The framework allows for the preservation of sequences of length alpha while allowing up to delta differences. It considers two options, preserving sequences seen in the complete variation graph or haplotypes only, and offers a variety of distance metrics, including hamming and edit distance. The objectives can be to minimize the number of variant coordinates or the number of variants. The problem 3 and 4, and all the haplotype-aware problems are proven to be $\mathcal{NP}$-hard.

## Dependencies
- gcc (with C++20 support)
- Boost Graph Library
- [samtools](https://vcftools.github.io/)
- [bcftools](https://samtools.github.io/bcftools/)
- [Gurobi](https://www.gurobi.com)
- [igraph](https://github.com/igraph/igraph)
- [OpenMP](https://curc.readthedocs.io/en/latest/programming/OpenMP-C.html)

![Workflow](figs/problems_category.pdf)

