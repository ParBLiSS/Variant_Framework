#!/bin/bash
#******************************* Run FORGe, HISAt2, and VF ****************************
mainwd=$(pwd)
cd $mainwd
datasetwd=$mainwd/dataset

vg=$mainwd/software
FORGe=$mainwd/software/FORGe
hisat2=$mainwd/software/hisat-genotype-top
#Note: bgzip and tabix are installed inside htslib
bgzip=$mainwd/software/htslib-1.12
tabix=$mainwd/software/htslib-1.12

#******** Needs to be changed according to experiment******
#cd $datasetwd
LEN=100
COUNT=100
CHRID=chr22
REF=$datasetwd/hs37d5.fa

VARFILE_SNP_zipped=$datasetwd/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
VARFILE_SNP=$datasetwd/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf

chr_vcf=ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf

ID=22
#***************************************

mkdir -p results && cd results
results=$(pwd)
mkdir -p results_${CHRID} 
cd ../

#Index VCF file
$bgzip/bgzip -c $VARFILE_SNP > $VARFILE_SNP.gz
$tabix/tabix -fp vcf $VARFILE_SNP.gz

# set up TEMP directory : Only for phoenix cluster
#export TMPDIR=$Home/scratch

cd $results/results_${CHRID}

#simulate reads from Graph by vg toolkit for chr# ID   
#Construct graph
#$vg/vg construct -r $REF -v $VARFILE_SNP_zipped -a -f -m 32 -R $ID > graph_${CHRID}.vg
echo "constrcut graph using vg is done"

#index the graph
#$vg/vg index -x graph_${CHRID}.xg -g  graph_${CHRID}.gcsa graph_${CHRID}.vg
echo "index graph using vg is done "

#Simulating reads from graph
$vg/vg sim -x graph_${CHRID}.xg -n $COUNT -l $LEN -a > reads_${CHRID}_${LEN}.gam
echo "simulate reads"
$vg/vg view -X reads_${CHRID}_${LEN}.gam > reads_${CHRID}_${LEN}.fastq
$vg/vg surject -s reads_${CHRID}_${LEN}.gam -x graph_${CHRID}.xg > reads_${CHRID}_${LEN}.sam #truth on linear genome

# convert simulated reads to fasta, that can be used for HISAT2 aligner
sed -n '1~4s/^@/>/p;2~4p' reads_${CHRID}_${LEN}.fastq > reads_${CHRID}_${LEN}.fasta

#Run FORGe for Chr #ID
cd $results/results_${CHRID}
mkdir -p ${CHRID}_hisat_index
$FORGe/src/vcf_to_1ksnp.py --reference $REF --vcf $VARFILE_SNP --out ${CHRID}.1ksnp 
$FORGe/src/rank.py --method popcov --reference $REF  --vars ${CHRID}.1ksnp  --window-size 100  --output ordered_${CHRID}_variants.txt
$FORGe/src/build.py --reference $REF --vars ${CHRID}.1ksnp  --window-size 100 --hisat variants_${CHRID}.snp --sorted ordered_${CHRID}_variants.txt --pct 10 # variants_${CHRID}.snp is output of this code, which is the input for the next step
echo "FORGe is done"
$hisat2/hisat2-build --snp variants_${CHRID}.snp $REF ${CHRID}_hisat_index/${CHRID}_hisat_index

#map using HISAT2: simulated reads to graph indexes
$hisat2/hisat2 -f -x ${CHRID}_hisat_index/${CHRID}_hisat_index -U reads_${CHRID}_${LEN}.fasta -S hisat_alignment_${CHRID}_snp.sam #reads.${CHRID}.fasta are simulated reads
echo "HISAT2 mapping for FORGe is done"


#******************************************************************************************************
# Run our VF framework for Chr #ID
$VF/build/greedy_snp -a 100 -d 5 -vcf $VARFILE_SNP_VF -chr $ID -prefix reduced_vf_${CHRID}.vcf
echo "VF is done"

$FORGe/src/vcf_to_1ksnp.py  --reference $REF --vcf reduced_vf_${CHRID}_retainedrecords.vcf --out ${CHRID}_snp_VF.1ksnp 
$FORGe/src/rank.py --method popcov-blowup --reference $REF --vars ${CHRID}_snp_VF.1ksnp --window-size 100 --output ordered_${CHRID}_snp_VF.txt
$FORGe/src/build.py --reference  $REF --vars ${CHRID}_snp_VF.1ksnp --window-size 100 --hisat hisat_input_${CHRID}_snp_VF.snp --sorted ordered_${CHRID}_snp_VF.txt --pct 100
$hisat2/hisat2-build --snp hisat_input_${CHRID}_snp_VF.snp $REF ${CHRID}_hisat_index/${CHRID}_hisat_index_VF
echo "FORGe with pct=100 for VF variants is done"

#map using HISAT2: simulated reads to graph indexes
$hisat2/hisat2 -f -x ${CHRID}_hisat_index/${CHRID}_hisat_index_VF -U reads_${CHRID}_${LEN}.fasta -S hisat_alignment_${CHRID}_snp_VF.sam 
echo "HISAT2 mapping for VF is done"



