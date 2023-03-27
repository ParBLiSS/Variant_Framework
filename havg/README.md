# havg
## Haplotype Annotated Variation Graph

This repository constructs haplotype-annotaed genome graphs.


It contains two Linux shell scripts. The first one, download all the VCF files (for human chromosomes 1 to 22 and chromosome X and Y) as well as the linear reference genome.

The second script is used to create a variation graph corresponds to each chromosome that is annotated with list of haplotypes per edge.

This repository needs the following dependencies:
(1) vcftools
(2) bcftool

The overall workflow is:

```sh
git clone https://github.com/NedaTavakoli/havg
cd havg 
project_dir=$(pwd)  #project top-level directory
mkdir -p data && cd data
# download data
../vcf_download_data.sh
mkdir -p software && cd software
# get dependencies
# get vcftools 
echo "downloading vcftools"
wget https://github.com/vcftools/vcftools/releases/download/v0.1.16/vcftools-0.1.16.tar.gz
tar xzf vcftools-0.1.16.tar.gz && cd vcftools-0.1.16
./autogen.sh
./configure --prefix=$(pwd)
make -j -s && make install
vcftools=$(pwd)
rm -f "vcftools-0.1.16.tar.gz"
echo "vcftools download and compilation finished"
# get bcftools
#Note that bcftools will be installed in the bin directory of bcftools folder
cd $softwarewd
git clone https://github.com/samtools/bcftools.git
cd bcftools
autoreconf -i  # Build the configure script and install files it uses
./configure  --prefix=$softwarewd/bcftools  # Optional but recommended, for choosing extra functionality
make
make install 
bcftools=$(pwd)
echo "bcftools download and compilation finished"
#get htslib
#Note: tabix, htslib and bgzip2 will be installed in the bin directory and rhe main directory
echo "downloading htslib"
cd $softwarewd
wget https://github.com/samtools/htslib/releases/download/1.12/htslib-1.12.tar.bz2
tar xvjf htslib-1.12.tar.bz2
cd htslib-1.12
autoreconf -i  # Build the configure script and install files it uses
./configure  --prefix=$softwarewd/htslib-1.12  # Optional but recommended, for choosing extra functionality
make
make install
htslib=$(pwd)
bgzip2=$(pwd)
tabix=$(pwd)
rm -f "htslib-1.12.tar.bz2"
echo "htslib download and compilation finished"
# construct haplotype-annotated variation graph
# Extract list of haplotypes per variant position for each allele
#  To run for all the chromosomes
for i in $(seq 1 22; echo X; echo Y)
do
    ../chr_id_haplotypes.sh ${i}
done    
```


