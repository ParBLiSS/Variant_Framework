#!/bin/bash
#********************Download Dataset*****************************
mainwd=$(pwd) #project top-level directory
mkdir -p dataset && cd dataset
datasetwd=$(pwd)

#Download chr9 vcf
echo "downloading VCF files for chr9"
cd $datasetwd
wget http://hgdownload.cse.ucsc.edu/gbdb/hg19/1000Genomes/phase3/ALL.chr9.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
chr9_vcf_zipped=$datasetwd/ALL.chr9.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
cp $chr9_vcf_zipped zipped_ALL.chr9.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
gzip -d ALL.chr9.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
chr9_vcf=$datasetwd/ALL.chr9.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf

#Download chr1 vcf
echo "downloading VCF files for chr1"
cd $datasetwd
wget http://hgdownload.cse.ucsc.edu/gbdb/hg19/1000Genomes/phase3/ALL.chr1.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
chr1_vcf_zipped=$datasetwd/ALL.chr1.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
cp $chr1_vcf_zipped zipped_ALL.chr1.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
gzip -d ALL.chr1.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
chr1_vcf=$datasetwd/ALL.chr1.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf

#Download chr22 vcf
echo "downloading VCF files for chr22"
cd $datasetwd
wget http://hgdownload.cse.ucsc.edu/gbdb/hg19/1000Genomes/phase3/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
chr22_vcf_zipped=$datasetwd/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
cp $chr22_vcf_zipped zipped_ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
gzip -d ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
chr22_vcf=$datasetwd/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf

#Download Human Genome for Svs experiments
echo "downloading Human genome"
cd $datasetwd
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/archive/old_genbank/Eukaryotes/vertebrates_mammals/Homo_sapiens/GRCh38/seqs_for_alignment_pipelines/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz
gzip -d GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz
REF_sv=$datasetwd/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna

#Download hs37d5.fa
wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz
hs37d5_zipped=$datasetwd/hs37d5.fa
gzip -d hs37d5.fa
hs37d5=$datasetwd/hs37d5.fa

#Download vcf files
echo "downloading VCF files for SV"
cd $datasetwd
wget http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/hgsv_sv_discovery/working/20181025_EEE_SV-Pop_1/VariantCalls_EEE_SV-Pop_1/EEE_SV-Pop_1.ALL.sites.20181204.vcf.gz
gzip -d EEE_SV-Pop_1.ALL.sites.20181204.vcf.gz
SV_vcf=$datasetwd/EEE_SV-Pop_1.ALL.sites.20181204.vcf.gz

#Keep only ins/del
cd $datasetwd
cat <(cat EEE_SV-Pop_1.ALL.sites.20181204.vcf | grep "^#") <(cat EEE_SV-Pop_1.ALL.sites.20181204.vcf | grep -vE "^#" | grep 'INS\|DEL') | ../software/htslib-1.12/bgzip -c >sv_indels.vcf.gz

#*
#********************End of Download dataset*****************************
#
