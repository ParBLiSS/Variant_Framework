cd /storage/coda1/p-saluru8/0/ntavakoli6/benchmark/


mainwd=$(pwd)
cd $mainwd
datasetwd=$mainwd/dataset
results=$mainwd/results

vg=$mainwd/software
FORGe=$mainwd/software/FORGe
hisat2=$mainwd/software/hisat-genotype-top
#Note: bgzip and tabix are installed inside htslib
bgzip=$mainwd/software/htslib-1.12
tabix=$mainwd/software/htslib-1.12
VF=$mainwd/software/VF

#******** Needs to be changed according to experiment******
#cd $datasetwd
LEN=100
COUNT=100
CHRID=chr22
REF=$datasetwd/hs37d5.fa

VARFILE_SNP_zipped=$datasetwd/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
VARFILE_SNP=$datasetwd/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf

chr_vcf=ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf

a=100
d=5
ID=22

#****************************************************
# Note: FORGe is not supporting SV
#****************************************************
# $alg
 # Run our VF framework ( then feed to FORGe, then HISAT) for Chr #ID 
# ONLY for SNPs
alg=greedy_snp

cd $results/results_${CHRID}
mkdir -p ${alg} && cd ${alg}

$VF/build/$alg -a $a -d $d -vcf $VARFILE_SNP -chr $ID -prefix $alg_reduced_vf_${CHRID}_alpha_${a}_delta_${d}
echo "VF is done"

echo "Start running FORGe on VF results"
$FORGe/src/vcf_to_1ksnp.py  --reference $REF --vcf $alg_reduced_vf_${CHRID}_alpha_${a}_delta_${d}.retainedrecords.vcf --out $alg_${CHRID}_snp_VF_alpha_${a}_delta_${d}.1ksnp 
$FORGe/src/rank.py --method popcov-blowup --reference $REF --vars $alg_${CHRID}_snp_VF_alpha_${a}_delta_${d}.1ksnp --window-size 100 --output $alg_ordered_${CHRID}_snp_VF_alpha_${a}_delta_${d}.txt
$FORGe/src/build.py --reference  $REF --vars $alg_${CHRID}_snp_VF_alpha_${a}_delta_${d}.1ksnp --window-size 100 --hisat $alg_hisat_input_${CHRID}_snp_VF_alpha_${a}_delta_${d}.snp --sorted $alg_ordered_${CHRID}_snp_VF_alpha_${a}_delta_${d}.txt --pct 100
$hisat2/hisat2-build --snp $alg_hisat_input_${CHRID}_snp_VF_alpha_${a}_delta_${d}.snp $REF ${CHRID}_hisat_index/$alg_${CHRID}_hisat_index_VF_alpha_${a}_delta_${d}
echo "FORGe with pct=100 for VF variants is done"

#map using HISAT2: simulated reads to graph indexes
$hisat2/hisat2 -f -x ${CHRID}_hisat_index/$alg_${CHRID}_hisat_index_VF_alpha_${a}_delta_${d} -U reads_${CHRID}_${LEN}.fasta -S $alg_hisat_alignment_${CHRID}_snp_VF_alpha_${a}_delta_${d}.sam --summary-file $alg_hisat_alignment_summary_${CHRID}_snp_VF_alpha_${a}_delta_${d}.txt
echo "HISAT2 mapping for VF is done"


#****************************************************
# $alg
 # Run our VF framework ( then feed to FORGe, then HISAT) for Chr #ID 
# ONLY for SNPs
alg=lp_snp

cd $results/results_${CHRID}
mkdir -p $alg && cd $alg

$VF/build/$alg -a $a -d $d -vcf $VARFILE_SNP -chr $ID -prefix $alg_reduced_vf_${CHRID}_alpha_${a}_delta_${d}
echo "VF is done"

echo "Start running FORGe on VF results"
$FORGe/src/vcf_to_1ksnp.py  --reference $REF --vcf $alg_reduced_vf_${CHRID}_alpha_${a}_delta_${d}.retainedrecords.vcf --out $alg_${CHRID}_snp_VF_alpha_${a}_delta_${d}.1ksnp 
$FORGe/src/rank.py --method popcov-blowup --reference $REF --vars $alg_${CHRID}_snp_VF_alpha_${a}_delta_${d}.1ksnp --window-size 100 --output $alg_ordered_${CHRID}_snp_VF_alpha_${a}_delta_${d}.txt
$FORGe/src/build.py --reference  $REF --vars $alg_${CHRID}_snp_VF_alpha_${a}_delta_${d}.1ksnp --window-size 100 --hisat $alg_hisat_input_${CHRID}_snp_VF_alpha_${a}_delta_${d}.snp --sorted $alg_ordered_${CHRID}_snp_VF_alpha_${a}_delta_${d}.txt --pct 100
$hisat2/hisat2-build --snp $alg_hisat_input_${CHRID}_snp_VF_alpha_${a}_delta_${d}.snp $REF ${CHRID}_hisat_index/$alg_${CHRID}_hisat_index_VF_alpha_${a}_delta_${d}
echo "FORGe with pct=100 for VF variants is done"

#map using HISAT2: simulated reads to graph indexes
$hisat2/hisat2 -f -x ${CHRID}_hisat_index/$alg_${CHRID}_hisat_index_VF_alpha_${a}_delta_${d} -U reads_${CHRID}_${LEN}.fasta -S $alg_hisat_alignment_${CHRID}_snp_VF_alpha_${a}_delta_${d}.sam --summary-file $alg_hisat_alignment_summary_${CHRID}_snp_VF_alpha_${a}_delta_${d}.txt
echo "HISAT2 mapping for VF is done"


#********
#Run our VF framework ( then feed to FORGe, then HISAT) for Chr #ID for indels and snps 
# For both SNPs and indels, the first FORGe command "vcf_to_1ksnp.py needs to hava --include-indels to support both snps and indels"
# We have three algorithms here: greedy_snp_indel, ilp_snp_indel, ilp_snp_indel --indule-indels
alg=greedy_snp_indel
cd $results/results_${CHRID}
mkdir -p $alg && cd $alg

$VF/build/$alg -a $a -d $d -vcf $VARFILE_SNP -chr $ID -prefix snp_indel_reduced_vf_${CHRID}_alpha_${a}_delta_${d}
echo "VF is done"
echo "Start running FORGe on VF results"
$FORGe/src/vcf_to_1ksnp.py  --reference $REF --vcf snp_indel_reduced_vf_${CHRID}_alpha_${a}_delta_${d}.retainedrecords.vcf --include-indels --out snp_indel_${CHRID}_snp_VF_alpha_${a}_delta_${d}.1ksnp 
$FORGe/src/rank.py --method popcov-blowup --reference $REF --vars snp_indel_${CHRID}_snp_VF_alpha_${a}_delta_${d}.1ksnp --window-size 100 --output snp_indel_ordered_${CHRID}_snp_VF_alpha_${a}_delta_${d}.txt
$FORGe/src/build.py --reference  $REF --vars snp_indel_${CHRID}_snp_VF_alpha_${a}_delta_${d}.1ksnp --window-size 100 --hisat hisat_input_${CHRID}_VF_snp_indel__alpha_${a}_delta_${d}.snp --sorted snp_indel_ordered_${CHRID}_snp_VF_alpha_${a}_delta_${d}.txt --pct 100
$hisat2/hisat2-build --snp hisat_input_${CHRID}_VF_snp_indel__alpha_${a}_delta_${d}.snp $REF ${CHRID}_hisat_index/snp_indel_${CHRID}_hisat_index_VF_alpha_${a}_delta_${d}
echo "FORGe with pct=100 for VF variants is done"

#map using HISAT2: simulated reads to graph indexes
$hisat2/hisat2 -f -x ${CHRID}_hisat_index/snp_indel_${CHRID}_hisat_index_VF_alpha_${a}_delta_${d} -U reads_${CHRID}_${LEN}.fasta -S snp_indel_hisat_alignment_${CHRID}_snp_VF_alpha_${a}_delta_${d}.sam --summary-file snp_indel_hisat_alignment_summary_${CHRID}_snp_VF_alpha_${a}_delta_${d}.txt
echo "HISAT2 mapping for VF is done"
