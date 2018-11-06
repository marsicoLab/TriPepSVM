#!/usr/bin/env bash

scriptDir=$(dirname "$0")

#####  get ordered vs disordered regions
if [ ! -f $RESULT/9606/NRBP_kmerCount_ordered.fasta ] || [ ! -f $RESULT/9606/NRBP_kmerCount_disordered.fasta ];then
	bash $workDir/getOrderedUnorderedSequences.sh $IUPred $DATA/NRBP_9606.fasta $RESULT/9606/NRBP_kmerCount_ordered.fasta $RESULT/9606/NRBP_kmerCount_disordered.fasta $RESULT/9606
fi

if [ ! -f $RESULT/9606/RBP_kmerCount_ordered.fasta ] || [ ! -f $RESULT/9606/RBP_kmerCount_disordered.fasta ];then
	bash $workDir/getOrderedUnorderedSequences.sh $IUPred $DATA/RBP_9606.fasta $RESULT/9606/RBP_kmerCount_ordered.fasta \
	$RESULT/9606/RBP_kmerCount_disordered.fasta $RESULT/9606
fi

if [ ! -f $RESULT/590/NRBP_kmerCount_ordered.fasta ] || [ ! -f $RESULT/590/NRBP_kmerCount_disordered.fasta ];then
	bash $workDir/getOrderedUnorderedSequences.sh $IUPred $DATA/NRBP_590.fasta $RESULT/590/NRBP_kmerCount_ordered.fasta $RESULT/590/NRBP_kmerCount_disordered.fasta $RESULT/590
fi

if [ ! -f $RESULT/590/RBP_kmerCount_ordered.fasta ] || [ ! -f $RESULT/590/RBP_kmerCount_disordered.fasta ];then
	bash $workDir/getOrderedUnorderedSequences.sh $IUPred $DATA/RBP_590.fasta $RESULT/590/RBP_kmerCount_ordered.fasta \
	$RESULT/590/RBP_kmerCount_disordered.fasta $RESULT/590
fi

