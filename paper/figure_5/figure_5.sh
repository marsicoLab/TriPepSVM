#!/usr/bin/env bash

scriptDir=$(dirname "$0")

TEMP=$scriptDir/TEMP

mkdir -p $TEMP

#####  get ordered vs disordered regions: human
if [ ! -f $TEMP/9606/NRBP_kmerCount_ordered.fasta ] || [ ! -f $TEMP/9606/NRBP_kmerCount_disordered.fasta ];then
	bash $scriptDir/source/getOrderedUnorderedSequences.sh $scriptDir/../data/NRBP_9606.fasta $TEMP/9606/NRBP_kmerCount_ordered.fasta \
	$TEMP/9606/NRBP_kmerCount_disordered.fasta $TEMP/9606
fi

if [ ! -f $TEMP/9606/RBP_kmerCount_ordered.fasta ] || [ ! -f $TEMP/9606/RBP_kmerCount_disordered.fasta ];then
	bash $scriptDir/source/getOrderedUnorderedSequences.sh $scriptDir/../data/RBP_9606.fasta $TEMP/9606/RBP_kmerCount_ordered.fasta \
	$TEMP/9606/RBP_kmerCount_disordered.fasta $TEMP/9606
fi

#####  get ordered vs disordered regions: salmonella


if [ ! -f $TEMP/590/NRBP_kmerCount_ordered.fasta ] || [ ! -f $TEMP/590/NRBP_kmerCount_disordered.fasta ];then
	bash $scriptDir/source/getOrderedUnorderedSequences.sh $scriptDir/../data/NRBP_590.fasta $TEMP/590/NRBP_kmerCount_ordered.fasta \
	$TEMP/590/NRBP_kmerCount_disordered.fasta $TEMP/590
fi

if [ ! -f $TEMP/590/RBP_kmerCount_ordered.fasta ] || [ ! -f $TEMP/590/RBP_kmerCount_disordered.fasta ];then
	bash $scriptDir/source/getOrderedUnorderedSequences.sh $scriptDir/../data/RBP_590.fasta $TEMP/590/RBP_kmerCount_ordered.fasta \
	$TEMP/590/RBP_kmerCount_disordered.fasta $TEMP/590
fi

##### get all tripeptide sequences

if [ ! -f $TEMP/3mer.txt ];then
	Rscript $scriptDir/source/getAllAmino3Mer.r $TEMP/3mer.txt
fi

##### estimate tripeptide count: salmonella
if [ ! -f $TEMP/590/NRBP_kmerCount_ordered.txt ];then
	Rscript $scriptDir/source/estimateKmerCount.r $TEMP/590/NRBP_kmerCount_ordered.fasta $TEMP/3mer.txt $TEMP/590/NRBP_kmerCount_ordered.txt
fi

if [ ! -f $TEMP/590/RBP_kmerCount_ordered.txt ];then
	Rscript $scriptDir/source/estimateKmerCount.r $TEMP/590/RBP_kmerCount_ordered.fasta $TEMP/3mer.txt $TEMP/590/RBP_kmerCount_ordered.txt
fi

if [ ! -f $TEMP/590/NRBP_kmerCount_disordered.txt ];then
	Rscript $scriptDir/source/estimateKmerCount.r $TEMP/590/NRBP_kmerCount_disordered.fasta $TEMP/3mer.txt $TEMP/590/NRBP_kmerCount_disordered.txt
fi

if [ ! -f $TEMP/590/RBP_kmerCount_disordered.txt ];then
	Rscript $scriptDir/source/estimateKmerCount.r $TEMP/590/RBP_kmerCount_disordered.fasta $TEMP/3mer.txt $TEMP/590/RBP_kmerCount_disordered.txt
fi

##### estimate tripeptide count: human
if [ ! -f $TEMP/9606/NRBP_kmerCount_ordered.txt ];then
	Rscript $scriptDir/source/estimateKmerCount.r $TEMP/9606/NRBP_kmerCount_ordered.fasta $TEMP/3mer.txt $TEMP/9606/NRBP_kmerCount_ordered.txt
fi

if [ ! -f $TEMP/9606/RBP_kmerCount_ordered.txt ];then
	Rscript $scriptDir/source/estimateKmerCount.r $TEMP/9606/RBP_kmerCount_ordered.fasta $TEMP/3mer.txt $TEMP/9606/RBP_kmerCount_ordered.txt
fi

if [ ! -f $TEMP/9606/NRBP_kmerCount_disordered.txt ];then
	Rscript $scriptDir/source/estimateKmerCount.r $TEMP/9606/NRBP_kmerCount_disordered.fasta $TEMP/3mer.txt $TEMP/9606/NRBP_kmerCount_disordered.txt
fi

if [ ! -f $TEMP/9606/RBP_kmerCount_disordered.txt ];then
	Rscript $scriptDir/source/estimateKmerCount.r $TEMP/9606/RBP_kmerCount_disordered.fasta $TEMP/3mer.txt $TEMP/9606/RBP_kmerCount_disordered.txt
fi

Rscript $scriptDir/source/plotRankingFrac.r $TEMP/590/RBP_kmerCount_ordered.txt $TEMP/590/RBP_kmerCount_disordered.txt $scriptDir/../data/proteome_prediction_salmonella/proteome_99287.featureWeights.txt \
$TEMP/9606/RBP_kmerCount_ordered.txt $TEMP/9606/RBP_kmerCount_disordered.txt $scriptDir/../data/proteome_prediction_human/proteome_9606.featureWeights.txt 0.2 $scriptDir/figure_5.pdf


