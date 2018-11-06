#!/usr/bin/env bash

scriptDir=$(dirname "$0")

if [ ! -f $scriptDir/proteome_prediction_salmonella/proteome_99287.featureWeights.txt ];then
	TriPepSVM.sh -i $scriptDir/data/proteome_99287.fasta -o $scriptDir/proteome_prediction_salmonella -id 590 -pos 1.8 -neg 0.2 -thr 0.68 -r TRUE
fi

if [ ! -f $scriptDir/proteome_prediction_human/proteome_9606.featureWeights.txt ];then
	TriPepSVM.sh -i $scriptDir/data/proteome_9606.fasta -o $scriptDir/proteome_prediction_human -id 9606 -pos 1.8 -neg 0.2 -thr 0.28
fi 


Rscript $scriptDir/source/plotRanking.r $scriptDir/proteome_prediction_salmonella/proteome_99287.featureWeights.txt $scriptDir/proteome_prediction_human/proteome_9606.featureWeights.txt \
$scriptDir/data/kmer_enriched_human.txt $workDir/figure_4.pdf


