# Variant_Framework

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

![List_of_Problems](figs/problems_category.png)

```
The project has the following folder structure:
```
hged
|___src  
|    |___data_wrangler.cpp           # to construct <file1> and <file2>
|    |___main.cpp                    # code to construct ILPs and solve the problem
hg  
|__src 
|
VF
|
VF_Experiments
|
havg
|__src
...
```